import 'package:oyin_front/domain/export.dart';


class MatchState {
  const MatchState({
    required this.profile,
    required this.nearbySelected,
    required this.timeMatchSelected,
  });

  final MatchProfile profile;
  final bool nearbySelected;
  final bool timeMatchSelected;

  MatchState copyWith({
    MatchProfile? profile,
    bool? nearbySelected,
    bool? timeMatchSelected,
  }) =>
      MatchState(
        profile: profile ?? this.profile,
        nearbySelected: nearbySelected ?? this.nearbySelected,
        timeMatchSelected: timeMatchSelected ?? this.timeMatchSelected,
      );
}
