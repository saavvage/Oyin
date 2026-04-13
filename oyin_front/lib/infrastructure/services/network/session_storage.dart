import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/export.dart';

class SessionStorage {
  static SharedPreferences? _prefs;
  static final ValueNotifier<int> sessionVersion = ValueNotifier<int>(0);

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setAccessToken(String token) async {
    await init();
    await _prefs!.setString(_Keys.accessToken, token);
    await _prefs!.setBool(_Keys.guestMode, false);
    _bumpSessionVersion();
  }

  static Future<String?> getAccessToken() async {
    await init();
    return _prefs!.getString(_Keys.accessToken);
  }

  static Future<void> clearAccessToken() async {
    await init();
    await _prefs!.remove(_Keys.accessToken);
    _bumpSessionVersion();
  }

  static Future<void> setGuestMode(bool enabled) async {
    await init();
    await _prefs!.setBool(_Keys.guestMode, enabled);
    if (enabled) {
      await _prefs!.remove(_Keys.accessToken);
    }
    _bumpSessionVersion();
  }

  static Future<void> forceSignOut() async {
    await init();
    await _prefs!.remove(_Keys.accessToken);
    await _prefs!.setBool(_Keys.guestMode, false);
    _bumpSessionVersion();
  }

  static Future<bool> getGuestMode() async {
    await init();
    return _prefs!.getBool(_Keys.guestMode) ?? false;
  }

  static Future<void> setMatchFilters(MatchFilters filters) async {
    await init();
    await _prefs!.setDouble(_Keys.matchDistanceMin, filters.distanceKmMin);
    await _prefs!.setDouble(_Keys.matchDistanceMax, filters.distanceKmMax);
    await _prefs!.setInt(_Keys.matchAgeMin, filters.ageMin);
    await _prefs!.setInt(_Keys.matchAgeMax, filters.ageMax);
  }

  static Future<MatchFilters> getMatchFilters() async {
    await init();
    final distanceMin =
        _prefs!.getDouble(_Keys.matchDistanceMin) ??
        MatchFilters.defaults.distanceKmMin;
    final distanceMax =
        _prefs!.getDouble(_Keys.matchDistanceMax) ??
        MatchFilters.defaults.distanceKmMax;
    final ageMin =
        _prefs!.getInt(_Keys.matchAgeMin) ?? MatchFilters.defaults.ageMin;
    final ageMax =
        _prefs!.getInt(_Keys.matchAgeMax) ?? MatchFilters.defaults.ageMax;
    return MatchFilters(
      distanceKmMin: distanceMin,
      distanceKmMax: distanceMax,
      ageMin: ageMin,
      ageMax: ageMax,
    );
  }

  static Future<void> setTimedReminderEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(_Keys.timedReminderEnabled, enabled);
  }

  static Future<bool> getTimedReminderEnabled() async {
    await init();
    return _prefs!.getBool(_Keys.timedReminderEnabled) ?? false;
  }

  static Future<void> setTimedReminderIntervalMinutes(int minutes) async {
    await init();
    await _prefs!.setInt(_Keys.timedReminderIntervalMinutes, minutes);
  }

  static Future<int> getTimedReminderIntervalMinutes() async {
    await init();
    return _prefs!.getInt(_Keys.timedReminderIntervalMinutes) ?? 60;
  }

  static Future<void> setLocale(String localeCode) async {
    await init();
    await _prefs!.setString(_Keys.locale, localeCode);
  }

  static Future<String?> getLocale() async {
    await init();
    return _prefs!.getString(_Keys.locale);
  }

  static Future<void> setPublicVisibility(bool value) async {
    await init();
    await _prefs!.setBool(_Keys.publicVisibility, value);
  }

  static Future<bool?> getPublicVisibility() async {
    await init();
    return _prefs!.getBool(_Keys.publicVisibility);
  }

  static Future<void> setMatchRequests(bool value) async {
    await init();
    await _prefs!.setBool(_Keys.matchRequests, value);
  }

  static Future<bool?> getMatchRequests() async {
    await init();
    return _prefs!.getBool(_Keys.matchRequests);
  }

  static Future<void> setDisputeUpdates(bool value) async {
    await init();
    await _prefs!.setBool(_Keys.disputeUpdates, value);
  }

  static Future<bool?> getDisputeUpdates() async {
    await init();
    return _prefs!.getBool(_Keys.disputeUpdates);
  }

  static void _bumpSessionVersion() {
    sessionVersion.value = sessionVersion.value + 1;
  }
}

class _Keys {
  static const String accessToken = 'access_token';
  static const String guestMode = 'guest_mode';
  static const String matchDistanceMin = 'match_distance_min';
  static const String matchDistanceMax = 'match_distance_max';
  static const String matchAgeMin = 'match_age_min';
  static const String matchAgeMax = 'match_age_max';
  static const String timedReminderEnabled = 'timed_reminder_enabled';
  static const String timedReminderIntervalMinutes =
      'timed_reminder_interval_minutes';
  static const String locale = 'app_locale';
  static const String publicVisibility = 'public_visibility';
  static const String matchRequests = 'match_requests';
  static const String disputeUpdates = 'dispute_updates';
}
