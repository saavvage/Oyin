import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(
          ChatState(
            activeTab: 0,
            actionRequired: const [
              ChatCard(
                name: 'Sarah L.',
                subtitle: 'Dispute started regarding the final set score. Please upload…',
                avatarUrl:
                    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
                status: 'Dispute Open',
                timestamp: 'Mon',
                badgeCount: null,
                accent: 'red',
                highlight: true,
                buttonLabel: 'resolve',
              ),
            ],
            upcoming: const [
              ChatCard(
                name: 'Alex P.',
                subtitle: "See you at the court at 5? I'll bring th…",
                avatarUrl:
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
                status: 'CONTRACT SIGNED',
                timestamp: '10:30 AM',
                badgeCount: 1,
                accent: 'green',
                highlight: false,
                buttonLabel: null,
              ),
              ChatCard(
                name: 'Dmitry K.',
                subtitle: 'I sent the location proposal. Let me know if that works for you.',
                avatarUrl:
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
                status: 'DRAFTING CONTRACT…',
                timestamp: 'Yesterday',
                badgeCount: null,
                accent: 'yellow',
                highlight: false,
                buttonLabel: 'view',
              ),
              ChatCard(
                name: 'Maria S.',
                subtitle: 'Matched! Start chatting to set up.',
                avatarUrl:
                    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
                status: 'MATCHED',
                timestamp: '2d ago',
                badgeCount: null,
                accent: 'muted',
                highlight: false,
                buttonLabel: null,
              ),
            ],
          ),
        );

  void selectTab(int index) => emit(state.copyWith(activeTab: index));
}
