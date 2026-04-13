class MatchResultPlayer {
  const MatchResultPlayer({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isYou,
    required this.score,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final bool isYou;
  final int? score;

  MatchResultPlayer copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isYou,
    int? score,
    bool resetScore = false,
  }) => MatchResultPlayer(
    id: id ?? this.id,
    name: name ?? this.name,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    isYou: isYou ?? this.isYou,
    score: resetScore ? null : (score ?? this.score),
  );
}

class MatchResultContract {
  const MatchResultContract({
    required this.dateTime,
    required this.location,
    required this.reminder,
  });

  final DateTime dateTime;
  final String location;
  final bool reminder;
}

class MatchResultState {
  const MatchResultState({
    required this.gameId,
    required this.title,
    required this.dateLabel,
    required this.locationLabel,
    required this.statusLabel,
    required this.leftPlayer,
    required this.rightPlayer,
    required this.isCurrentUserPlayer1,
    required this.contract,
    required this.isLoading,
    required this.isSubmitting,
    required this.isCreatingDispute,
    required this.disputeId,
    required this.error,
  });

  final String gameId;
  final String title;
  final String dateLabel;
  final String locationLabel;
  final String statusLabel;
  final MatchResultPlayer leftPlayer;
  final MatchResultPlayer rightPlayer;
  final bool isCurrentUserPlayer1;
  final MatchResultContract? contract;
  final bool isLoading;
  final bool isSubmitting;
  final bool isCreatingDispute;
  final String? disputeId;
  final String? error;

  bool get hasContract => contract != null;

  bool get canSubmit =>
      hasContract &&
      !isLoading &&
      !isSubmitting &&
      leftPlayer.score != null &&
      rightPlayer.score != null;

  bool get canOpenDispute =>
      hasContract && (statusLabel == 'CONFLICT' || statusLabel == 'DISPUTED');

  MatchResultState copyWith({
    String? gameId,
    String? title,
    String? dateLabel,
    String? locationLabel,
    String? statusLabel,
    MatchResultPlayer? leftPlayer,
    MatchResultPlayer? rightPlayer,
    bool? isCurrentUserPlayer1,
    MatchResultContract? contract,
    bool clearContract = false,
    bool? isLoading,
    bool? isSubmitting,
    bool? isCreatingDispute,
    String? disputeId,
    bool clearDisputeId = false,
    String? error,
    bool clearError = false,
  }) => MatchResultState(
    gameId: gameId ?? this.gameId,
    title: title ?? this.title,
    dateLabel: dateLabel ?? this.dateLabel,
    locationLabel: locationLabel ?? this.locationLabel,
    statusLabel: statusLabel ?? this.statusLabel,
    leftPlayer: leftPlayer ?? this.leftPlayer,
    rightPlayer: rightPlayer ?? this.rightPlayer,
    isCurrentUserPlayer1: isCurrentUserPlayer1 ?? this.isCurrentUserPlayer1,
    contract: clearContract ? null : (contract ?? this.contract),
    isLoading: isLoading ?? this.isLoading,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isCreatingDispute: isCreatingDispute ?? this.isCreatingDispute,
    disputeId: clearDisputeId ? null : (disputeId ?? this.disputeId),
    error: clearError ? null : (error ?? this.error),
  );

  factory MatchResultState.initial({
    required String gameId,
    required String challengerName,
    required String opponentName,
    String opponentAvatarUrl = '',
  }) {
    return MatchResultState(
      gameId: gameId,
      title: 'Challenge Match',
      dateLabel: 'Pending schedule',
      locationLabel: 'Court TBD',
      statusLabel: 'PENDING',
      leftPlayer: MatchResultPlayer(
        id: 'player1',
        name: challengerName,
        avatarUrl: '',
        isYou: true,
        score: null,
      ),
      rightPlayer: MatchResultPlayer(
        id: 'player2',
        name: opponentName,
        avatarUrl: opponentAvatarUrl,
        isYou: false,
        score: null,
      ),
      isCurrentUserPlayer1: true,
      contract: null,
      isLoading: true,
      isSubmitting: false,
      isCreatingDispute: false,
      disputeId: null,
      error: null,
    );
  }
}
