import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../infrastructure/export.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit() : super(const AiChatState());

  String? _userId;

  Future<void> init() async {
    try {
      final me = await UsersApi.getMe();
      _userId = (me['id'] ?? '').toString();
    } catch (_) {
      _userId = 'anonymous';
    }

    final online = await AiApi.instance.healthCheck();
    emit(state.copyWith(isOnline: online));
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final userMsg = AiMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      createdAt: DateTime.now(),
    );

    final loadingMsg = AiMessage(
      id: 'ai_loading_${DateTime.now().millisecondsSinceEpoch}',
      text: '',
      isUser: false,
      createdAt: DateTime.now(),
      isLoading: true,
    );

    emit(state.copyWith(
      messages: [...state.messages, userMsg, loadingMsg],
      isSending: true,
    ));

    try {
      final response = await AiApi.instance.chat(
        AiChatRequest(
          userId: _userId ?? 'anonymous',
          message: trimmed,
        ),
      );

      final aiMsg = AiMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: response.response,
        isUser: false,
        createdAt: DateTime.now(),
        sources: response.sources,
        usedRag: response.usedRag,
      );

      final updated = state.messages
          .where((m) => !m.isLoading)
          .toList()
        ..add(aiMsg);

      emit(state.copyWith(messages: updated, isSending: false));
    } catch (_) {
      final errorMsg = AiMessage(
        id: 'ai_error_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Failed to get a response. Please try again.',
        isUser: false,
        createdAt: DateTime.now(),
        isError: true,
      );

      final updated = state.messages
          .where((m) => !m.isLoading)
          .toList()
        ..add(errorMsg);

      emit(state.copyWith(messages: updated, isSending: false));
    }
  }
}
