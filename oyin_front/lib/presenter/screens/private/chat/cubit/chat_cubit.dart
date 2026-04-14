import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';
import '../../../../../app/localization/locale_keys.dart';
import '../../../../../infrastructure/services/network/chat_api.dart';
import '../../../../../infrastructure/services/network/disputes_api.dart';
import '../../../../../infrastructure/services/network/users_api.dart';

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
      final values = await Future.wait<dynamic>([
        UsersApi.getMe(),
        DisputesApi.getMyDisputes(),
        DisputesApi.getJuryDuty(),
      ]);

      final me = values[0] as Map<String, dynamic>;
      final myId = (me['id'] ?? '').toString();
      final myDisputes = values[1] as List<DisputeDetailsDto>;
      final juryDisputes = values[2] as List<DisputeDetailsDto>;

      final mineById = <String, DisputeDetailsDto>{};
      final communityById = <String, DisputeDetailsDto>{};

      for (final item in myDisputes) {
        mineById[item.id] = item;
      }

      for (final item in juryDisputes) {
        final isMine =
            item.plaintiff.id == myId ||
            item.defendant.id == myId ||
            item.player1.id == myId ||
            item.player2.id == myId;
        if (isMine) {
          mineById[item.id] = item;
        } else {
          communityById[item.id] = item;
        }
      }

      final mine = mineById.values.toList()
        ..sort(
          (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
        );
      final community = communityById.values.toList()
        ..sort(
          (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
        );

      emit(
        state.copyWith(
          myDisputes: mine,
          communityDisputes: community,
          isLoadingDisputes: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          myDisputes: const [],
          communityDisputes: const [],
          isLoadingDisputes: false,
        ),
      );
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
