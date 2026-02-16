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
        : "Alex 'The Jab' Johnson";
    final location = user.city.isNotEmpty ? user.city : 'San Francisco, CA';
    final tagline = 'Boxing & Muay Thai';

    return ProfileState(
      avatarUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
      name: displayName,
      tagline: tagline,
      email: user.email,
      location: location,
      league: 'GOLD LEAGUE',
      stats: const ProfileStats(
        reputation: 4.9,
        reputationNoteKey: LocaleKeys.reputationExcellent,
        record: '12W-3L',
        matches: 15,
        matchesDeltaValue: '2',
        reliability: 98,
      ),
      nextMatch: const NextMatch(
        opponentName: 'Sarah K.',
        opponentAvatar:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
        dateLabel: 'Today, 18:00',
        locationLabel: 'Downtown Gym',
        statusLabel: 'CONFIRMED',
      ),
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
      final sportProfiles = _extractSportProfiles(data['sportProfiles']);

      final safeName = name.isNotEmpty && name.toLowerCase() != 'new user'
          ? name
          : state.name;
      final tagline = _buildTagline(sportProfiles);

      emit(
        state.copyWith(
          name: safeName,
          email: email.isNotEmpty ? email : state.email,
          location: city.isNotEmpty ? city : state.location,
          avatarUrl: avatar.isNotEmpty ? avatar : state.avatarUrl,
          tagline: tagline,
          sportProfiles: sportProfiles,
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
