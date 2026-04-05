import 'package:oyin_front/domain/export.dart';

class SettingsState {
  const SettingsState({
    required this.searchPlaceholder,
    required this.userName,
    required this.userSubtitle,
    required this.userTag,
    required this.sections,
    required this.publicVisibility,
    required this.matchRequests,
    required this.disputeUpdates,
    required this.timedRemindersEnabled,
    required this.timedRemindersIntervalMinutes,
    required this.selectedLocale,
    required this.matchFilters,
  });

  final String searchPlaceholder;
  final String userName;
  final String userSubtitle;
  final String userTag;
  final List<SettingsSection> sections;
  final bool publicVisibility;
  final bool matchRequests;
  final bool disputeUpdates;
  final bool timedRemindersEnabled;
  final int timedRemindersIntervalMinutes;
  final String selectedLocale; // 'en', 'ru', 'kz'
  final MatchFilters matchFilters;

  SettingsState copyWith({
    String? userName,
    String? userSubtitle,
    String? userTag,
    bool? publicVisibility,
    bool? matchRequests,
    bool? disputeUpdates,
    bool? timedRemindersEnabled,
    int? timedRemindersIntervalMinutes,
    String? selectedLocale,
    MatchFilters? matchFilters,
  }) => SettingsState(
    searchPlaceholder: searchPlaceholder,
    userName: userName ?? this.userName,
    userSubtitle: userSubtitle ?? this.userSubtitle,
    userTag: userTag ?? this.userTag,
    sections: sections,
    publicVisibility: publicVisibility ?? this.publicVisibility,
    matchRequests: matchRequests ?? this.matchRequests,
    disputeUpdates: disputeUpdates ?? this.disputeUpdates,
    timedRemindersEnabled: timedRemindersEnabled ?? this.timedRemindersEnabled,
    timedRemindersIntervalMinutes:
        timedRemindersIntervalMinutes ?? this.timedRemindersIntervalMinutes,
    selectedLocale: selectedLocale ?? this.selectedLocale,
    matchFilters: matchFilters ?? this.matchFilters,
  );
}

class SettingsSection {
  const SettingsSection({required this.title, required this.items});

  final String title;
  final List<SettingsItem> items;
}

class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.toggleKey,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String? toggleKey;
}
