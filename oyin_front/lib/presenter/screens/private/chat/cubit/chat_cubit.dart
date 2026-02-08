import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';
import '../../../../../app/localization/locale_keys.dart';
import '../../../../../infrastructure/services/network/chat_api.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(
          const ChatState(
            activeTab: 0,
            actionRequired: [],
            upcoming: [],
          ),
        );

  Future<void> loadThreads() async {
    try {
      final response = await ChatApi.getThreads();
      emit(
        state.copyWith(
          actionRequired: response.actionRequired.map(_toCard).toList(),
          upcoming: response.upcoming.map(_toCard).toList(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          actionRequired: _seedActionRequired(),
          upcoming: _seedUpcoming(),
        ),
      );
    }
  }

  void selectTab(int index) => emit(state.copyWith(activeTab: index));

  ChatCard _toCard(ChatThreadDto dto) {
    return ChatCard(
      id: dto.id,
      name: dto.name,
      subtitle: dto.subtitle,
      avatarUrl: dto.avatarUrl,
      statusKey: dto.statusKey,
      timestamp: dto.timestamp,
      badgeCount: dto.badgeCount,
      accent: dto.accent,
      highlight: dto.highlight,
      buttonKey: dto.buttonKey,
    );
  }

  List<ChatCard> _seedActionRequired() {
    return const [
      ChatCard(
        id: 'local_action_1',
        name: 'Sarah L.',
        subtitle: 'Dispute started regarding the final set score. Please upload…',
        avatarUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
        statusKey: LocaleKeys.statusDisputeOpen,
        timestamp: 'Mon',
        badgeCount: null,
        accent: 'red',
        highlight: true,
        buttonKey: 'resolve',
      ),
    ];
  }

  List<ChatCard> _seedUpcoming() {
    return const [
      ChatCard(
        id: 'local_upcoming_1',
        name: 'Alex P.',
        subtitle: "See you at the court at 5? I'll bring th…",
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
        statusKey: LocaleKeys.statusContractSigned,
        timestamp: '10:30 AM',
        badgeCount: 1,
        accent: 'green',
        highlight: false,
        buttonKey: null,
      ),
      ChatCard(
        id: 'local_upcoming_2',
        name: 'Dmitry K.',
        subtitle: 'I sent the location proposal. Let me know if that works for you.',
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
        statusKey: LocaleKeys.statusDraftingContract,
        timestamp: 'Yesterday',
        badgeCount: null,
        accent: 'yellow',
        highlight: false,
        buttonKey: 'view',
      ),
      ChatCard(
        id: 'local_upcoming_3',
        name: 'Maria S.',
        subtitle: 'Matched! Start chatting to set up.',
        avatarUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
        statusKey: LocaleKeys.statusMatched,
        timestamp: '2d ago',
        badgeCount: null,
        accent: 'muted',
        highlight: false,
        buttonKey: null,
      ),
    ];
  }
}
