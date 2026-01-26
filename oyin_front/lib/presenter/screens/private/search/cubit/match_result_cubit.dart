import 'package:flutter_bloc/flutter_bloc.dart';

import 'match_result_state.dart';

class MatchResultCubit extends Cubit<MatchResultState> {
  MatchResultCubit()
      : super(
          MatchResultState(
            title: 'Sparring Session',
            dateLabel: 'Today · 18:00',
            locationLabel: 'Downtown Gym',
            statusLabel: 'PENDING',
            leftPlayer: const MatchResultPlayer(
              name: 'Alex',
              avatarUrl:
                  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
              isYou: true,
              score: null,
            ),
            rightPlayer: const MatchResultPlayer(
              name: 'Sarah K.',
              avatarUrl:
                  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
              isYou: false,
              score: null,
            ),
          ),
        );

  void setScoreLeft(int value) => emit(state.copyWith(leftPlayer: state.leftPlayer.copyWith(score: value)));

  void setScoreRight(int value) =>
      emit(state.copyWith(rightPlayer: state.rightPlayer.copyWith(score: value)));
}
