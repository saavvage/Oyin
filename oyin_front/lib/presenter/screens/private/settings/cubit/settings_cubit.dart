import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import 'package:oyin_front/infrastructure/export.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(
          searchPlaceholder: 'search_settings_placeholder',
          userName: '',
          userSubtitle: '',
          userTag: '',
          sections: const [
            SettingsSection(
              title: 'account',
              items: [
                SettingsItem(
                  icon: 'person',
                  title: 'personal_info',
                  subtitle: '',
                ),
                SettingsItem(
                  icon: 'lock',
                  title: 'password_security',
                  subtitle: '',
                ),
              ],
            ),
            SettingsSection(
              title: 'sparring_privacy',
              items: [
                SettingsItem(
                  icon: 'visibility',
                  title: 'public_visibility',
                  subtitle: 'public_visibility_desc',
                  toggleKey: 'public_visibility',
                ),
                SettingsItem(
                  icon: 'shield',
                  title: 'sparring_preferences',
                  subtitle: '',
                ),
                SettingsItem(
                  icon: 'block',
                  title: 'blocked_users',
                  subtitle: '',
                ),
              ],
            ),
            SettingsSection(
              title: 'notifications',
              items: [
                SettingsItem(
                  icon: 'bell',
                  title: 'match_requests',
                  subtitle: '',
                  toggleKey: 'match_requests',
                ),
                SettingsItem(
                  icon: 'hammer',
                  title: 'dispute_updates',
                  subtitle: '',
                  toggleKey: 'dispute_updates',
                ),
              ],
            ),
            SettingsSection(
              title: 'support',
              items: [
                SettingsItem(icon: 'help', title: 'help_center', subtitle: ''),
                SettingsItem(
                  icon: 'rules',
                  title: 'fair_play_rules',
                  subtitle: '',
                ),
              ],
            ),
            SettingsSection(
              title: 'language',
              items: [
                SettingsItem(
                  icon: 'language_selector',
                  title: 'language',
                  subtitle: '',
                ),
              ],
            ),
          ],
          publicVisibility: true,
          matchRequests: true,
          disputeUpdates: false,
          timedRemindersEnabled: false,
          timedRemindersIntervalMinutes: 60,
          selectedLocale: 'en',
          matchFilters: MatchFilters.defaults,
        ),
      ) {
    _loadMatchFilters();
    _loadLocalToggleSettings();
    _loadTimedReminderSettings();
    _loadPushSettingsFromBackend();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await UsersApi.getMe();
      if (isClosed) return;
      final name = (data['name'] ?? '').toString();
      final sportProfiles = data['sportProfiles'];
      String subtitle = '';
      String tag = '';
      if (sportProfiles is List && sportProfiles.isNotEmpty) {
        final first = sportProfiles.first;
        if (first is Map) {
          final sport = (first['sportType'] ?? '').toString();
          final level = (first['level'] ?? '').toString();
          subtitle = sport;
          tag = level.toUpperCase();
        }
      }
      emit(
        state.copyWith(
          userName: name.isNotEmpty ? name : null,
          userSubtitle: subtitle.isNotEmpty ? subtitle : null,
          userTag: tag.isNotEmpty ? tag : null,
        ),
      );
    } catch (_) {}
  }

  Future<void> refreshUserData() async => _loadUserData();

  Future<void> _loadMatchFilters() async {
    final filters = await SessionStorage.getMatchFilters();
    if (isClosed) return;
    emit(state.copyWith(matchFilters: filters));
  }

  Future<void> _loadLocalToggleSettings() async {
    final publicVisibility = await SessionStorage.getPublicVisibility();
    final matchRequests = await SessionStorage.getMatchRequests();
    final disputeUpdates = await SessionStorage.getDisputeUpdates();
    if (isClosed) return;

    emit(
      state.copyWith(
        publicVisibility: publicVisibility ?? state.publicVisibility,
        matchRequests: matchRequests ?? state.matchRequests,
        disputeUpdates: disputeUpdates ?? state.disputeUpdates,
      ),
    );
  }

  Future<void> _loadTimedReminderSettings() async {
    final enabled = await SessionStorage.getTimedReminderEnabled();
    final minutes = await SessionStorage.getTimedReminderIntervalMinutes();
    if (isClosed) return;
    emit(
      state.copyWith(
        timedRemindersEnabled: enabled,
        timedRemindersIntervalMinutes: minutes,
      ),
    );
  }

  Future<void> _loadPushSettingsFromBackend() async {
    try {
      final settings = await UsersApi.getPushSettings();
      final interval = _normalizeIntervalMinutes(settings.intervalMinutes);

      await SessionStorage.setTimedReminderEnabled(settings.enabled);
      await SessionStorage.setTimedReminderIntervalMinutes(interval);

      if (isClosed) return;

      emit(
        state.copyWith(
          timedRemindersEnabled: settings.enabled,
          timedRemindersIntervalMinutes: interval,
        ),
      );

      await PushNotificationsService.applyTimedReminderSchedule(
        enabled: settings.enabled,
        interval: Duration(minutes: interval),
      );
    } catch (error) {
      debugPrint('[Settings] Failed to load server push settings: $error');
    }
  }

  void togglePublicVisibility(bool value) {
    SessionStorage.setPublicVisibility(value);
    emit(state.copyWith(publicVisibility: value));
  }

  void toggleMatchRequests(bool value) {
    SessionStorage.setMatchRequests(value);
    emit(state.copyWith(matchRequests: value));
  }

  void toggleDisputeUpdates(bool value) {
    SessionStorage.setDisputeUpdates(value);
    emit(state.copyWith(disputeUpdates: value));
  }

  Future<void> toggleTimedReminders(bool value) async {
    final intervalMinutes = state.timedRemindersIntervalMinutes;

    await SessionStorage.setTimedReminderEnabled(value);
    emit(state.copyWith(timedRemindersEnabled: value));
    await PushNotificationsService.applyTimedReminderSchedule(
      enabled: value,
      interval: Duration(minutes: intervalMinutes),
    );

    try {
      await UsersApi.updatePushSettings(
        enabled: value,
        intervalMinutes: intervalMinutes,
      );
    } catch (error) {
      debugPrint('[Settings] Failed to update server push settings: $error');
    }
  }

  Future<void> setTimedReminderIntervalMinutes(int minutes) async {
    final normalizedMinutes = _normalizeIntervalMinutes(minutes);
    final enabled = state.timedRemindersEnabled;

    await SessionStorage.setTimedReminderIntervalMinutes(normalizedMinutes);
    emit(state.copyWith(timedRemindersIntervalMinutes: normalizedMinutes));

    if (enabled) {
      await PushNotificationsService.applyTimedReminderSchedule(
        enabled: true,
        interval: Duration(minutes: normalizedMinutes),
      );
    }

    try {
      await UsersApi.updatePushSettings(
        enabled: enabled,
        intervalMinutes: normalizedMinutes,
      );
    } catch (error) {
      debugPrint('[Settings] Failed to update server push interval: $error');
    }
  }

  void setLocale(String localeCode) =>
      emit(state.copyWith(selectedLocale: localeCode));

  Future<void> updateMatchFilters(MatchFilters filters) async {
    await SessionStorage.setMatchFilters(filters);
    emit(state.copyWith(matchFilters: filters));
  }

  int _normalizeIntervalMinutes(int value) {
    if (value < 15) return 15;
    if (value > 1440) return 1440;
    return value;
  }
}
