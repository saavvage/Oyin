import 'package:oyin_front/domain/export.dart';

class MutualLikeMatch {
  const MutualLikeMatch({
    required this.threadId,
    required this.partnerUserId,
    required this.partnerName,
    required this.partnerAvatarUrl,
    this.gameId,
  });

  final String threadId;
  final String partnerUserId;
  final String partnerName;
  final String partnerAvatarUrl;
  final String? gameId;
}

class MatchState {
  const MatchState({
    required this.profiles,
    required this.nearbySelected,
    required this.timeMatchSelected,
    required this.isLoading,
    required this.isFinished,
    required this.filters,
    required this.currentUserAvatarUrl,
    required this.mutualLikeMatch,
  });

  final List<MatchProfile> profiles;
  final bool nearbySelected;
  final bool timeMatchSelected;
  final bool isLoading;
  final bool isFinished;
  final MatchFilters filters;
  final String? currentUserAvatarUrl;
  final MutualLikeMatch? mutualLikeMatch;

  MatchProfile? get currentProfile =>
      profiles.isNotEmpty ? profiles.first : null;

  MatchState copyWith({
    List<MatchProfile>? profiles,
    bool? nearbySelected,
    bool? timeMatchSelected,
    bool? isLoading,
    bool? isFinished,
    MatchFilters? filters,
    String? currentUserAvatarUrl,
    MutualLikeMatch? mutualLikeMatch,
    bool clearMutualLikeMatch = false,
  }) => MatchState(
    profiles: profiles ?? this.profiles,
    nearbySelected: nearbySelected ?? this.nearbySelected,
    timeMatchSelected: timeMatchSelected ?? this.timeMatchSelected,
    isLoading: isLoading ?? this.isLoading,
    isFinished: isFinished ?? this.isFinished,
    filters: filters ?? this.filters,
    currentUserAvatarUrl: currentUserAvatarUrl ?? this.currentUserAvatarUrl,
    mutualLikeMatch: clearMutualLikeMatch
        ? null
        : (mutualLikeMatch ?? this.mutualLikeMatch),
  );
}
