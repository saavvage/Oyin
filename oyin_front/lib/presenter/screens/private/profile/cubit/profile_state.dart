class ProfileStats {
  const ProfileStats({
    required this.reputation,
    required this.reputationNote,
    required this.record,
    required this.matches,
    required this.matchesDelta,
    required this.reliability,
  });

  final double reputation;
  final String reputationNote;
  final String record;
  final int matches;
  final String matchesDelta;
  final int reliability;
}

class NextMatch {
  const NextMatch({
    required this.opponentName,
    required this.opponentAvatar,
    required this.dateLabel,
    required this.locationLabel,
    required this.statusLabel,
  });

  final String opponentName;
  final String opponentAvatar;
  final String dateLabel;
  final String locationLabel;
  final String statusLabel;
}

class ProfileState {
  const ProfileState({
    required this.avatarUrl,
    required this.name,
    required this.tagline,
    required this.location,
    required this.league,
    required this.stats,
    required this.nextMatch,
    required this.settingsItems,
  });

  final String avatarUrl;
  final String name;
  final String tagline;
  final String location;
  final String league;
  final ProfileStats stats;
  final NextMatch nextMatch;
  final List<ProfileSettingItem> settingsItems;
}

class ProfileSettingItem {
  const ProfileSettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;
}
