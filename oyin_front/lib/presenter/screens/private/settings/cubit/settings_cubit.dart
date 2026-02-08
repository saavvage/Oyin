import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import 'package:oyin_front/infrastructure/export.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            searchPlaceholder: 'search_settings_placeholder',
            userName: "Alex 'The Hammer'",
            userSubtitle: 'Muay Thai • Rank 4',
            userTag: 'PRO',
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
                  SettingsItem(
                    icon: 'link',
                    title: 'linked_accounts',
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
                  SettingsItem(
                    icon: 'help',
                    title: 'help_center',
                    subtitle: '',
                  ),
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
            selectedLocale: 'en',
            matchFilters: MatchFilters.defaults,
          ),
        ) {
    _loadMatchFilters();
  }

  Future<void> _loadMatchFilters() async {
    final filters = await SessionStorage.getMatchFilters();
    if (isClosed) return;
    emit(state.copyWith(matchFilters: filters));
  }

  void togglePublicVisibility(bool value) => emit(state.copyWith(publicVisibility: value));
  void toggleMatchRequests(bool value) => emit(state.copyWith(matchRequests: value));

  void toggleDisputeUpdates(bool value) => emit(state.copyWith(disputeUpdates: value));

  void setLocale(String localeCode) => emit(state.copyWith(selectedLocale: localeCode));

  Future<void> updateMatchFilters(MatchFilters filters) async {
    await SessionStorage.setMatchFilters(filters);
    emit(state.copyWith(matchFilters: filters));
  }
}
