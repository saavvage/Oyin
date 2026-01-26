import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(
          ProfileState(
            avatarUrl:
                'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
            name: "Alex 'The Jab' Johnson",
            tagline: 'Boxing & Muay Thai',
            location: 'San Francisco, CA',
            league: 'GOLD LEAGUE',
            stats: const ProfileStats(
              reputation: 4.9,
              reputationNote: 'Excellent',
              record: '12W-3L',
              matches: 15,
              matchesDelta: '+2 this mo.',
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
          ),
        );
}
