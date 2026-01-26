class MatchResultPlayer {
  const MatchResultPlayer({
    required this.name,
    required this.avatarUrl,
    required this.isYou,
    required this.score,
  });

  final String name;
  final String avatarUrl;
  final bool isYou;
  final int? score;

  MatchResultPlayer copyWith({int? score}) => MatchResultPlayer(
        name: name,
        avatarUrl: avatarUrl,
        isYou: isYou,
        score: score ?? this.score,
      );
}

class MatchResultState {
  const MatchResultState({
    required this.title,
    required this.dateLabel,
    required this.locationLabel,
    required this.statusLabel,
    required this.leftPlayer,
    required this.rightPlayer,
  });

  final String title;
  final String dateLabel;
  final String locationLabel;
  final String statusLabel;
  final MatchResultPlayer leftPlayer;
  final MatchResultPlayer rightPlayer;

  MatchResultState copyWith({
    MatchResultPlayer? leftPlayer,
    MatchResultPlayer? rightPlayer,
  }) =>
      MatchResultState(
        title: title,
        dateLabel: dateLabel,
        locationLabel: locationLabel,
        statusLabel: statusLabel,
        leftPlayer: leftPlayer ?? this.leftPlayer,
        rightPlayer: rightPlayer ?? this.rightPlayer,
      );
}
