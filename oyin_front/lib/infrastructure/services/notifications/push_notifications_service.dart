import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/session_storage.dart';
import '../network/users_api.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  debugPrint('[Push] Background message: ${message.messageId ?? 'unknown'}');
}

class PushNotificationsService {
  PushNotificationsService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'oyin_push_channel';
  static const String _channelName = 'Oyin Push Notifications';
  static const String _channelDescription = 'General app push notifications';
  static const int _timedReminderNotificationId = 93_001;

  static bool _isInitialized = false;
  static bool _isInitializing = false;
  static bool _isSyncingToken = false;
  static String? _lastSyncedToken;

  static Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      final firebaseReady = await _initializeFirebase();
      if (!firebaseReady) {
        return;
      }

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _initializeLocalNotifications();
      await _requestNotificationPermissions();
      await _logFcmToken();
      await syncTokenWithBackend();
      _listenTokenRefresh();
      await _restoreTimedReminderScheduleFromStorage();

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedFromPush);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleOpenedFromPush(initialMessage);
      }

      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<bool> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      return true;
    } catch (error) {
      debugPrint('[Push] Firebase init skipped: $error');
      return false;
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInitializationSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(settings);

    final androidImplementation = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );
      await androidImplementation.createNotificationChannel(channel);
    }
  }

  static Future<void> _requestNotificationPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      criticalAlert: false,
      carPlay: false,
    );

    debugPrint(
      '[Push] Permission status: ${settings.authorizationStatus.name}',
    );
  }

  static Future<void> _logFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[Push] FCM token (startup): <empty>');
        return;
      }

      debugPrint('[Push] FCM token (startup): $token');
    } catch (error) {
      debugPrint('[Push] Failed to get FCM token: $error');
    }
  }

  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen(
      (token) async {
        if (token.isEmpty) {
          debugPrint('[Push] FCM token refreshed: <empty>');
          return;
        }

        debugPrint('[Push] FCM token refreshed: $token');
        await syncTokenWithBackend(tokenOverride: token);
      },
      onError: (error) {
        debugPrint('[Push] FCM token refresh stream error: $error');
      },
    );
  }

  static Future<void> _restoreTimedReminderScheduleFromStorage() async {
    try {
      final enabled = await SessionStorage.getTimedReminderEnabled();
      final minutes = await SessionStorage.getTimedReminderIntervalMinutes();
      await _scheduleTimedReminder(
        enabled: enabled,
        interval: Duration(minutes: minutes),
      );
    } catch (error) {
      debugPrint('[Push] Failed to restore timed reminder settings: $error');
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  static void _handleOpenedFromPush(RemoteMessage message) {
    debugPrint('[Push] Opened from notification: ${message.data}');
  }

  static Future<void> applyTimedReminderSchedule({
    required bool enabled,
    required Duration interval,
  }) async {
    if (!_isInitialized && !_isInitializing) {
      await initialize();
    }

    if (!_isInitialized && !_isInitializing) {
      return;
    }

    await _scheduleTimedReminder(enabled: enabled, interval: interval);
  }

  static Future<void> _scheduleTimedReminder({
    required bool enabled,
    required Duration interval,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotificationsPlugin.cancel(_timedReminderNotificationId);

    if (!enabled) {
      debugPrint('[Push] Timed reminders disabled.');
      return;
    }

    await _localNotificationsPlugin.periodicallyShowWithDuration(
      _timedReminderNotificationId,
      'Oyin reminder',
      'Open the app to check matches, chats and dispute updates.',
      interval,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'timed_reminder',
    );

    debugPrint(
      '[Push] Timed reminders scheduled every ${interval.inMinutes} min.',
    );
  }

  static Future<String?> getToken() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return await _messaging.getToken();
    } catch (_) {
      return null;
    }
  }

  static Future<void> syncTokenWithBackend({String? tokenOverride}) async {
    if (_isSyncingToken) return;

    final accessToken = await SessionStorage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      debugPrint('[Push] Skip backend token sync: no authorized session.');
      return;
    }

    final token = (tokenOverride ?? await getToken() ?? '').trim();
    if (token.isEmpty) {
      debugPrint('[Push] Skip backend token sync: FCM token is empty.');
      return;
    }

    if (_lastSyncedToken == token) {
      return;
    }

    _isSyncingToken = true;

    try {
      await UsersApi.updatePushToken(
        token: token,
        platform: _resolvePlatform(),
      );
      _lastSyncedToken = token;
      debugPrint('[Push] FCM token synced with backend.');
    } catch (error) {
      debugPrint('[Push] Failed to sync FCM token with backend: $error');
    } finally {
      _isSyncingToken = false;
    }
  }

  static String _resolvePlatform() {
    if (kIsWeb) {
      return 'web';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'web';
    }
  }
}
