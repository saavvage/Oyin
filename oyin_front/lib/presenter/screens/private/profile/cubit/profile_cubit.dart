import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyin_front/infrastructure/export.dart';

import '../../../../../domain/export.dart';
import '../../../../../app/localization/locale_keys.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(_buildInitial()) {
    _loadProfile();
  }

  static ProfileState _buildInitial() {
    final user = MockUserRepository.instance.getOrDefault();
    final displayName = user.fullName.isNotEmpty
        ? user.fullName
        : '';
    final location = user.city.isNotEmpty ? user.city : '';

    return ProfileState(
      avatarUrl: '',
      name: displayName,
      tagline: '',
      email: user.email,
      location: location,
      league: '',
      stats: const ProfileStats(
        reputation: 0,
        reputationNoteKey: LocaleKeys.reputationExcellent,
        record: '0W-0L',
        matches: 0,
        matchesDeltaValue: '',
        reliability: 0,
      ),
      nextMatch: null,
      settingsItems: const [
        ProfileSettingItem(
          icon: 'availability',
          title: 'availability',
          subtitle: 'availability_desc',
        ),
        ProfileSettingItem(
          icon: 'sports',
          title: 'sport_preferences',
          subtitle: 'sport_preferences_desc',
        ),
        ProfileSettingItem(
          icon: 'history',
          title: 'match_history',
          subtitle: 'match_history_desc',
        ),
      ],
      sportProfiles: const [],
    );
  }

  Future<void> _loadProfile() async {
    try {
      final data = await UsersApi.getMe();
      final name = (data['name'] ?? state.name).toString();
      final email = (data['email'] ?? state.email).toString();
      final city = (data['city'] ?? state.location).toString();
      final avatar = (data['avatarUrl'] ?? '').toString();
      final reliability =
          (data['reliabilityScore'] as num?)?.toInt() ?? state.stats.reliability;
      final sportProfiles = _extractSportProfiles(data['sportProfiles']);

      final safeName = name.isNotEmpty && name.toLowerCase() != 'new user'
          ? name
          : state.name;
      final tagline = _buildTagline(sportProfiles);

      // Extract ELO rating for league calculation
      int eloRating = 1000;
      if (data['sportProfiles'] is List &&
          (data['sportProfiles'] as List).isNotEmpty) {
        eloRating = ((data['sportProfiles'] as List).first['eloRating'] as num?)
                ?.toInt() ??
            1000;
      }
      final league = _getLeague(eloRating);

      // Load game stats
      final myId = (data['id'] ?? '').toString();
      var stats = state.stats;
      NextMatch? nextMatch;
      try {
        final games = await GamesApi.getMyGames(myId);
        int wins = 0;
        int losses = 0;
        int draws = 0;
        for (final g in games) {
          switch (g.result) {
            case 'win':
              wins++;
              break;
            case 'loss':
              losses++;
              break;
            case 'draw':
              draws++;
              break;
          }
        }
        final total = wins + losses + draws;
        stats = ProfileStats(
          reputation: reliability / 20.0, // 0-100 → 0-5
          reputationNoteKey: reliability >= 80
              ? LocaleKeys.reputationExcellent
              : LocaleKeys.reputationExcellent,
          record: '${wins}W-${losses}L',
          matches: total,
          matchesDeltaValue: '',
          reliability: reliability,
        );

        // Find next upcoming match (PENDING or SCHEDULED)
        final upcoming = games.where((g) =>
            g.status == 'PENDING' || g.status == 'SCHEDULED').toList();
        if (upcoming.isNotEmpty) {
          final next = upcoming.first;
          nextMatch = NextMatch(
            opponentName: next.opponentName,
            opponentAvatar: next.opponentAvatarUrl,
            dateLabel: next.createdAt != null
                ? '${next.createdAt!.day}.${next.createdAt!.month.toString().padLeft(2, '0')}'
                : '',
            locationLabel: '',
            statusLabel: next.status == 'SCHEDULED' ? 'CONFIRMED' : next.status,
          );
        }
      } catch (_) {
        stats = state.stats.copyWith(reliability: reliability);
      }

      emit(
        state.copyWith(
          name: safeName,
          email: email.isNotEmpty ? email : state.email,
          location: city.isNotEmpty ? city : state.location,
          avatarUrl: avatar.isNotEmpty ? avatar : state.avatarUrl,
          tagline: tagline,
          league: league,
          sportProfiles: sportProfiles,
          stats: stats,
          nextMatch: nextMatch,
        ),
      );
    } catch (_) {}
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  Future<void> updateAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 86,
      maxWidth: 1280,
    );
    if (picked == null) return;

    final uploadedAvatar = await UsersApi.uploadAvatar(File(picked.path));
    if (uploadedAvatar == null || uploadedAvatar.isEmpty) {
      return;
    }

    emit(state.copyWith(avatarUrl: uploadedAvatar));
  }

  List<UserSportProfileView> _extractSportProfiles(dynamic rawValue) {
    if (rawValue is! List) return const [];
    final result = <UserSportProfileView>[];
    for (final item in rawValue) {
      if (item is! Map) continue;
      final map = item.cast<String, dynamic>();
      final rawSkills = map['skills'];
      final skills = rawSkills is List
          ? rawSkills.whereType<String>().where((s) => s.isNotEmpty).toList()
          : const <String>[];
      result.add(
        UserSportProfileView(
          sportType: (map['sportType'] ?? '').toString(),
          level: (map['level'] ?? '').toString(),
          skills: skills,
          experienceYears: (map['experienceYears'] as num?)?.toInt() ?? 0,
        ),
      );
    }
    return result;
  }

  static String _getLeague(int elo) {
    if (elo >= 1800) return 'DIAMOND LEAGUE';
    if (elo >= 1500) return 'PLATINUM LEAGUE';
    if (elo >= 1200) return 'GOLD LEAGUE';
    if (elo >= 900) return 'SILVER LEAGUE';
    return 'BRONZE LEAGUE';
  }

  String _buildTagline(List<UserSportProfileView> profiles) {
    if (profiles.isEmpty) {
      return state.tagline;
    }
    final labels = profiles
        .map((profile) => sportLabelByCode(profile.sportType))
        .where((label) => label.isNotEmpty)
        .toSet()
        .toList();

    if (labels.isEmpty) {
      return state.tagline;
    }

    return labels.take(3).join(' • ');
  }
}
