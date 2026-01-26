import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/private/models/match_profile.dart';
import 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit()
      : super(
          MatchState(
            profile: const MatchProfile(
              name: 'Alex',
              age: 26,
              distanceKm: 2.5,
              rating: 4.9,
              sport: 'Muay Thai',
              level: 'Semi-Pro',
              tags: ['Kickboxing', 'Heavyweight', 'Sparring'],
              imageUrl:
                  'https://images.unsplash.com/photo-1541944743827-e04aa6427c33?auto=format&fit=crop&w=1200&q=80',
              verified: true,
            ),
            nearbySelected: true,
            timeMatchSelected: false,
          ),
        );

  void selectNearby() => emit(state.copyWith(nearbySelected: true, timeMatchSelected: false));

  void selectTimeMatch() => emit(state.copyWith(nearbySelected: false, timeMatchSelected: true));
}
