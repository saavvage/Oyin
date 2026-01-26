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
    required this.selectedLocale,
  });

  final String searchPlaceholder;
  final String userName;
  final String userSubtitle;
  final String userTag;
  final List<SettingsSection> sections;
  final bool publicVisibility;
  final bool matchRequests;
  final bool disputeUpdates;
  final String selectedLocale; // 'en', 'ru', 'kz'

  SettingsState copyWith({
    bool? publicVisibility,
    bool? matchRequests,
    bool? disputeUpdates,
    String? selectedLocale,
  }) =>
      SettingsState(
        searchPlaceholder: searchPlaceholder,
        userName: userName,
        userSubtitle: userSubtitle,
        userTag: userTag,
        sections: sections,
        publicVisibility: publicVisibility ?? this.publicVisibility,
        matchRequests: matchRequests ?? this.matchRequests,
        disputeUpdates: disputeUpdates ?? this.disputeUpdates,
        selectedLocale: selectedLocale ?? this.selectedLocale,
      );
}

class SettingsSection {
  const SettingsSection({
    required this.title,
    required this.items,
  });

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
