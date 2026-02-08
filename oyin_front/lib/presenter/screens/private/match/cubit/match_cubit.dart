import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import 'package:oyin_front/infrastructure/export.dart';
import 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit()
      : super(
          MatchState(
            profiles: const [],
            nearbySelected: true,
            timeMatchSelected: false,
            isLoading: true,
            isFinished: false,
            filters: MatchFilters.defaults,
            currentUserAvatarUrl: null,
          ),
        ) {
    _loadInitial();
  }

  int _requestId = 0;
  final Set<String> _seenIds = {};
  final List<MatchProfile> _dislikedProfiles = [];
  final List<MatchProfile> _testProfiles = _buildTestProfiles();
  bool _useTestCards = true;

  void selectNearby() => emit(state.copyWith(nearbySelected: true, timeMatchSelected: false));

  void selectTimeMatch() => emit(state.copyWith(nearbySelected: false, timeMatchSelected: true));

  Future<void> _loadInitial() async {
    final filters = await SessionStorage.getMatchFilters();
    if (isClosed) return;
    emit(state.copyWith(filters: filters));

    await Future.wait([
      _loadCurrentUserAvatar(),
      _fetchFeed(filters: filters, showLoader: true),
    ]);
  }

  Future<void> _loadCurrentUserAvatar() async {
    try {
      final me = await UsersApi.getMe();
      final avatarUrl = me['avatarUrl']?.toString();
      if (!isClosed) {
        emit(state.copyWith(currentUserAvatarUrl: avatarUrl?.isEmpty ?? true ? null : avatarUrl));
      }
    } catch (_) {
      // ignore avatar load errors; feed can continue
    }
  }

  Future<void> _fetchFeed({
    MatchFilters? filters,
    bool showLoader = false,
  }) async {
    final requestId = ++_requestId;
    if (showLoader) {
      emit(state.copyWith(isLoading: true, isFinished: false));
    }
    final appliedFilters = filters ?? state.filters;
    final start = DateTime.now();

    List<MatchProfile> profiles = const [];
    try {
      profiles = await MatchmakingApi.getFeed(appliedFilters);
    } catch (_) {
      profiles = const [];
    }

    final elapsed = DateTime.now().difference(start);
    const minDelay = Duration(seconds: 2);
    if (elapsed < minDelay) {
      await Future.delayed(minDelay - elapsed);
    }

    profiles = _dedupe(profiles);

    if (profiles.isEmpty && _useTestCards) {
      profiles = _takeTestProfiles();
    }

    if (!isClosed && requestId == _requestId) {
      emit(
        state.copyWith(
          profiles: profiles,
          isLoading: false,
          isFinished: profiles.isEmpty,
        ),
      );
    }
  }

  Future<void> likeCurrent() async {
    final profile = state.currentProfile;
    if (profile == null) return;
    await _swipe(profile.id, 'LIKE');
  }

  Future<void> dislikeCurrent() async {
    final profile = state.currentProfile;
    if (profile == null) return;
    await _swipe(profile.id, 'DISLIKE');
  }

  Future<void> _swipe(String targetId, String action) async {
    try {
      await MatchmakingApi.swipe(targetId: targetId, action: action);
    } catch (_) {
      if (!_useTestCards) {
        return;
      }
    }

    if (action == 'DISLIKE') {
      final current = state.currentProfile;
      if (current != null) {
        _dislikedProfiles.add(current);
      }
    }

    final updated = List<MatchProfile>.from(state.profiles);
    if (updated.isNotEmpty) {
      updated.removeAt(0);
    }
    emit(state.copyWith(profiles: updated));

    if (updated.isEmpty) {
      await _fetchFeed(showLoader: true);
    }
  }

  Future<void> updateFilters(MatchFilters filters) async {
    await SessionStorage.setMatchFilters(filters);
    emit(state.copyWith(filters: filters));
    await _fetchFeed(filters: filters, showLoader: true);
  }

  Future<void> resetDislikes() async {
    emit(state.copyWith(isLoading: true, isFinished: false));
    try {
      await MatchmakingApi.resetDislikes();
    } catch (_) {
      // ignore
    }
    if (_dislikedProfiles.isNotEmpty) {
      _seenIds.removeAll(_dislikedProfiles.map((item) => item.id));
      if (_useTestCards) {
        final restored = List<MatchProfile>.from(_dislikedProfiles);
        _dislikedProfiles.clear();
        emit(
          state.copyWith(
            profiles: restored,
            isLoading: false,
            isFinished: restored.isEmpty,
          ),
        );
        return;
      }
      _dislikedProfiles.clear();
    }
    await _fetchFeed(showLoader: true);
  }

  List<MatchProfile> _dedupe(List<MatchProfile> incoming) {
    final unique = <MatchProfile>[];
    for (final profile in incoming) {
      if (profile.id.isEmpty) continue;
      if (_seenIds.add(profile.id)) {
        unique.add(profile);
      }
    }
    return unique;
  }

  List<MatchProfile> _takeTestProfiles() {
    final take = <MatchProfile>[];
    for (final profile in _testProfiles) {
      if (_seenIds.add(profile.id)) {
        take.add(profile);
      }
    }
    return take;
  }

  static List<MatchProfile> _buildTestProfiles() {
    return [
      const MatchProfile(
        id: 'test-1',
        name: 'Murat',
        age: 25,
        city: 'Almaty',
        distanceKm: 3.2,
        rating: 4.8,
        sport: 'Boxing',
        sports: ['Boxing', 'MMA'],
        level: 'Semi-Pro',
        tags: ['Speed', 'Footwork'],
        imageUrl:
            'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=1200&q=80',
        verified: true,
      ),
      const MatchProfile(
        id: 'test-2',
        name: 'Anya',
        age: 22,
        city: 'Astana',
        distanceKm: 5.6,
        rating: 4.5,
        sport: 'Tennis',
        sports: ['Tennis'],
        level: 'Amateur',
        tags: ['Serve', 'Agility'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-3',
        name: 'Daniyar',
        age: 29,
        city: 'Shymkent',
        distanceKm: 12.4,
        rating: 4.7,
        sport: 'Muay Thai',
        sports: ['Muay Thai', 'Kickboxing'],
        level: 'Pro',
        tags: ['Clinch', 'Power'],
        imageUrl:
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-4',
        name: 'Aruzhan',
        age: 24,
        city: 'Karaganda',
        distanceKm: 7.1,
        rating: 4.4,
        sport: 'Basketball',
        sports: ['Basketball'],
        level: 'Semi-Pro',
        tags: ['Defense', 'Stamina'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-5',
        name: 'Timur',
        age: 31,
        city: 'Aktobe',
        distanceKm: 18.9,
        rating: 4.9,
        sport: 'Football',
        sports: ['Football'],
        level: 'Pro',
        tags: ['Pace', 'Passing'],
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-6',
        name: 'Sofia',
        age: 27,
        city: 'Almaty',
        distanceKm: 2.1,
        rating: 4.6,
        sport: 'Boxing',
        sports: ['Boxing'],
        level: 'Amateur',
        tags: ['Counter', 'Endurance'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-7',
        name: 'Arman',
        age: 26,
        city: 'Astana',
        distanceKm: 9.3,
        rating: 4.3,
        sport: 'Basketball',
        sports: ['Basketball', 'Football'],
        level: 'Semi-Pro',
        tags: ['Teamplay', 'Sprint'],
        imageUrl:
            'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-8',
        name: 'Laura',
        age: 23,
        city: 'Pavlodar',
        distanceKm: 15.8,
        rating: 4.2,
        sport: 'Tennis',
        sports: ['Tennis', 'Badminton'],
        level: 'Amateur',
        tags: ['Serve', 'Spin'],
        imageUrl:
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-9',
        name: 'Eldar',
        age: 28,
        city: 'Taraz',
        distanceKm: 21.4,
        rating: 4.7,
        sport: 'MMA',
        sports: ['MMA', 'Wrestling'],
        level: 'Pro',
        tags: ['Grappling', 'Control'],
        imageUrl:
            'https://images.unsplash.com/photo-1541944743827-e04aa6427c33?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-10',
        name: 'Amina',
        age: 30,
        city: 'Kostanay',
        distanceKm: 4.7,
        rating: 4.5,
        sport: 'Muay Thai',
        sports: ['Muay Thai'],
        level: 'Semi-Pro',
        tags: ['Kicks', 'Timing'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }
}
