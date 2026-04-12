import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../app/errors/app_errors.dart';
import '../../../app/localization/app_localizations.dart';
import 'app_notification.dart';

class AppNotifier {
  static void show(
    BuildContext context,
    AppNotificationData data, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AppNotificationOverlay(
        data: data,
        duration: duration,
        onDismissed: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  static void showError(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);

    if (error is DioException) {
      final serverMessage = _extractServerMessage(error.response?.data);
      if (serverMessage != null && serverMessage.trim().isNotEmpty) {
        final path = error.requestOptions.path;
        if (_isAuthFlowPath(path)) {
          show(
            context,
            AppNotificationData.warning(l10n.notifTitleWarning, serverMessage),
          );
          return;
        }
      }
    }

    final code = AppErrorMapper.fromException(error);
    final title = _errorTitle(l10n, code);
    final message = _errorMessage(l10n, code);
    show(
      context,
      AppNotificationData.error(title, message),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      AppNotificationData.success(title ?? l10n.notifTitleSuccess, message),
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      AppNotificationData.warning(title ?? l10n.notifTitleWarning, message),
    );
  }

  static void showMessage(
    BuildContext context,
    String message, {
    String? title,
    AppNotificationType type = AppNotificationType.info,
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      AppNotificationData(
        title: title ?? _defaultTitle(l10n, type),
        message: message,
        type: type,
      ),
    );
  }

  static String _defaultTitle(AppLocalizations l10n, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.success:
        return l10n.notifTitleSuccess;
      case AppNotificationType.warning:
        return l10n.notifTitleWarning;
      case AppNotificationType.error:
        return l10n.notifTitleError;
      case AppNotificationType.info:
      default:
        return l10n.notifTitleInfo;
    }
  }

  static String _errorTitle(AppLocalizations l10n, AppErrorCode code) {
    switch (code) {
      case AppErrorCode.noConnection:
        return l10n.errorNoConnectionTitle;
      case AppErrorCode.timeout:
        return l10n.errorTimeoutTitle;
      case AppErrorCode.unauthorized:
        return l10n.errorUnauthorizedTitle;
      case AppErrorCode.forbidden:
        return l10n.errorForbiddenTitle;
      case AppErrorCode.notFound:
        return l10n.errorNotFoundTitle;
      case AppErrorCode.server:
        return l10n.errorServerTitle;
      case AppErrorCode.unknown:
      default:
        return l10n.errorUnknownTitle;
    }
  }

  static String _errorMessage(AppLocalizations l10n, AppErrorCode code) {
    switch (code) {
      case AppErrorCode.noConnection:
        return l10n.errorNoConnectionMessage;
      case AppErrorCode.timeout:
        return l10n.errorTimeoutMessage;
      case AppErrorCode.unauthorized:
        return l10n.errorUnauthorizedMessage;
      case AppErrorCode.forbidden:
        return l10n.errorForbiddenMessage;
      case AppErrorCode.notFound:
        return l10n.errorNotFoundMessage;
      case AppErrorCode.server:
        return l10n.errorServerMessage;
      case AppErrorCode.unknown:
      default:
        return l10n.errorUnknownMessage;
    }
  }

  static bool _isAuthFlowPath(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/verify') ||
        path.contains('/auth/login-password');
  }

  static String? _extractServerMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final message = data.trim();
      return message.isEmpty ? null : message;
    }

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return null;
  }
}

class _AppNotificationOverlay extends StatefulWidget {
  const _AppNotificationOverlay({
    required this.data,
    required this.duration,
    required this.onDismissed,
  });

  final AppNotificationData data;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_AppNotificationOverlay> createState() => _AppNotificationOverlayState();
}

class _AppNotificationOverlayState extends State<_AppNotificationOverlay> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
      _timer = Timer(widget.duration, _dismiss);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    if (!mounted) return;
    setState(() => _visible = false);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 16,
      right: 16,
      child: SafeArea(
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, -0.3),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _dismiss,
              child: AppNotificationBanner(
                data: widget.data,
                onClose: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
