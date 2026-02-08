import '../../../../../app/localization/locale_keys.dart';

class ProfileStats {
  const ProfileStats({
    required this.reputation,
    required this.record,
    required this.matches,
    required this.reliability,
    this.reputationNoteKey = LocaleKeys.reputationExcellent,
    this.matchesDeltaValue = '2',
  });

  final double reputation;
  final String record;
  final int matches;
  final int reliability;
  final String reputationNoteKey;
  final String matchesDeltaValue;
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
    required this.email,
    required this.location,
    required this.league,
    required this.stats,
    required this.nextMatch,
    required this.settingsItems,
  });

  final String avatarUrl;
  final String name;
  final String tagline;
  final String email;
  final String location;
  final String league;
  final ProfileStats stats;
  final NextMatch nextMatch;
  final List<ProfileSettingItem> settingsItems;

  ProfileState copyWith({
    String? avatarUrl,
    String? name,
    String? tagline,
    String? email,
    String? location,
    String? league,
    ProfileStats? stats,
    NextMatch? nextMatch,
    List<ProfileSettingItem>? settingsItems,
  }) {
    return ProfileState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      email: email ?? this.email,
      location: location ?? this.location,
      league: league ?? this.league,
      stats: stats ?? this.stats,
      nextMatch: nextMatch ?? this.nextMatch,
      settingsItems: settingsItems ?? this.settingsItems,
    );
  }
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
