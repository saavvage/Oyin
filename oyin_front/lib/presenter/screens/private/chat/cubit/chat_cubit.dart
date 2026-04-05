import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';
import '../../../../../app/localization/locale_keys.dart';
import '../../../../../infrastructure/services/network/chat_api.dart';
import '../../../../../infrastructure/services/network/disputes_api.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
    : super(const ChatState(activeTab: 0, actionRequired: [], upcoming: []));

  Future<void> loadThreads() async {
    try {
      final response = await ChatApi.getThreads();
      final actionRequired = response.actionRequired.map(_toCard).toList();
      final upcoming = response.upcoming.map(_toCard).toList();

      if (actionRequired.isEmpty && upcoming.isEmpty) {
        emit(
          state.copyWith(
            actionRequired: _seedActionRequired(),
            upcoming: _seedUpcoming(),
          ),
        );
        return;
      }

      emit(state.copyWith(actionRequired: actionRequired, upcoming: upcoming));
    } catch (_) {
      emit(
        state.copyWith(
          actionRequired: _seedActionRequired(),
          upcoming: _seedUpcoming(),
        ),
      );
    }
  }

  Future<void> loadDisputes() async {
    emit(state.copyWith(isLoadingDisputes: true));
    try {
      final disputes = await DisputesApi.getMyDisputes();
      emit(state.copyWith(disputes: disputes, isLoadingDisputes: false));
    } catch (_) {
      emit(state.copyWith(disputes: const [], isLoadingDisputes: false));
    }
  }

  void selectTab(int index) {
    emit(state.copyWith(activeTab: index));
    if (index == 1 && state.disputes.isEmpty && !state.isLoadingDisputes) {
      loadDisputes();
    }
  }

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
    return const [];
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
        subtitle:
            'I sent the location proposal. Let me know if that works for you.',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
        statusKey: LocaleKeys.statusDraftingContract,
        timestamp: 'Yesterday',
        badgeCount: null,
        accent: 'yellow',
        highlight: false,
        buttonKey: null,
      ),
    ];
  }
}
