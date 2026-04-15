import 'dart:async';

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
          mutualLikeMatch: null,
        ),
      ) {
    _loadInitial();
    _startAutoRefresh();
  }

  int _requestId = 0;
  Timer? _autoRefreshTimer;
  final Set<String> _seenIds = {};
  final List<MatchProfile> _dislikedProfiles = [];
  final List<MatchProfile> _testProfiles = _buildTestProfiles();
  final bool _useTestCards = true;

  void selectNearby() =>
      emit(state.copyWith(nearbySelected: true, timeMatchSelected: false));

  void selectTimeMatch() =>
      emit(state.copyWith(nearbySelected: false, timeMatchSelected: true));

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
        emit(
          state.copyWith(
            currentUserAvatarUrl: avatarUrl?.isEmpty ?? true ? null : avatarUrl,
          ),
        );
      }
    } catch (_) {
      // ignore avatar load errors; feed can continue
    }
  }

  Future<void> _fetchFeed({
    MatchFilters? filters,
    bool showLoader = false,
    bool append = false,
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
      if (append && profiles.isEmpty) {
        return;
      }

      final nextProfiles = append
          ? <MatchProfile>[...state.profiles, ...profiles]
          : profiles;

      emit(
        state.copyWith(
          profiles: nextProfiles,
          isLoading: false,
          isFinished: nextProfiles.isEmpty,
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

  Future<void> removeCurrentBlockedProfile(String profileId) async {
    final normalized = profileId.trim();
    final current = state.currentProfile;
    if (normalized.isEmpty || current == null || current.id != normalized) {
      return;
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

  Future<void> _swipe(String targetId, String action) async {
    final current = state.currentProfile;
    SwipeResultDto? swipeResult;

    try {
      swipeResult = await MatchmakingApi.swipe(
        targetId: targetId,
        action: action,
      );
    } catch (_) {
      if (!_useTestCards) {
        return;
      }
    }

    if (action == 'DISLIKE') {
      if (current != null) {
        _dislikedProfiles.add(current);
      }
    }

    MutualLikeMatch? mutualLikeMatch;
    if (action == 'LIKE' &&
        current != null &&
        swipeResult != null &&
        swipeResult.isMatch) {
      var threadId = swipeResult.threadId;
      if (threadId == null || threadId.isEmpty) {
        try {
          final thread = await ChatApi.createOrGetDirectThread(current.id);
          threadId = thread.id;
        } catch (_) {
          threadId = null;
        }
      }

      if (threadId != null && threadId.isNotEmpty) {
        mutualLikeMatch = MutualLikeMatch(
          threadId: threadId,
          partnerUserId: current.id,
          partnerName: current.name,
          partnerAvatarUrl: current.imageUrl,
          gameId: swipeResult.gameId,
        );
      }
    }

    final updated = List<MatchProfile>.from(state.profiles);
    if (updated.isNotEmpty) {
      updated.removeAt(0);
    }
    emit(state.copyWith(profiles: updated, mutualLikeMatch: mutualLikeMatch));

    if (updated.isEmpty) {
      await _fetchFeed(showLoader: true);
    }
  }

  void clearMutualLikeMatch() {
    emit(state.copyWith(clearMutualLikeMatch: true));
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

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _autoRefreshTick();
    });
  }

  Future<void> _autoRefreshTick() async {
    if (isClosed || state.isLoading) {
      return;
    }

    if (state.profiles.length <= 2 || state.isFinished) {
      await _fetchFeed(showLoader: false, append: true);
    }
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
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
        id: 'test-match-1',
        name: 'Murat',
        age: 25,
        city: 'Almaty',
        distanceKm: 3.2,
        rating: 4.8,
        sport: 'BOXING',
        sports: ['BOXING', 'MMA'],
        level: 'SEMI_PRO',
        tags: ['Speed', 'Footwork'],
        imageUrl:
            'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=1200&q=80',
        verified: true,
      ),
      const MatchProfile(
        id: 'test-match-2',
        name: 'Anya',
        age: 22,
        city: 'Astana',
        distanceKm: 5.6,
        rating: 4.5,
        sport: 'TENNIS',
        sports: ['TENNIS'],
        level: 'AMATEUR',
        tags: ['Serve', 'Agility'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-match-3',
        name: 'Daniyar',
        age: 29,
        city: 'Shymkent',
        distanceKm: 12.4,
        rating: 4.7,
        sport: 'MUAY_THAI',
        sports: ['MUAY_THAI', 'KICKBOXING'],
        level: 'PRO',
        tags: ['Clinch', 'Power'],
        imageUrl:
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-match-4',
        name: 'Aruzhan',
        age: 24,
        city: 'Karaganda',
        distanceKm: 7.1,
        rating: 4.4,
        sport: 'BASKETBALL',
        sports: ['BASKETBALL'],
        level: 'SEMI_PRO',
        tags: ['Defense', 'Stamina'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
      ),
      const MatchProfile(
        id: 'test-match-5',
        name: 'Timur',
        age: 31,
        city: 'Aktobe',
        distanceKm: 18.9,
        rating: 4.9,
        sport: 'FOOTBALL',
        sports: ['FOOTBALL'],
        level: 'PRO',
        tags: ['Pace', 'Passing'],
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }
}
