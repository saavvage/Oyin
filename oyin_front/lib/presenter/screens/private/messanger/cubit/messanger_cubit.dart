import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../infrastructure/services/network/chat_api.dart';
import 'messanger_state.dart';

class MessangerCubit extends Cubit<MessangerState> {
  MessangerCubit({
    required this.chatId,
    required String partnerName,
    required String partnerAvatarUrl,
  }) : super(
          MessangerState(
            partnerName: partnerName,
            partnerAvatarUrl: partnerAvatarUrl,
            messages: const [],
            hasMore: true,
            isLoadingMore: false,
            isBlocked: false,
          ),
        );

  final String chatId;

  Future<void> loadInitial() async {
    try {
      final messages = await ChatApi.getMessages(chatId);
      emit(
        state.copyWith(
          messages: _mapMessages(messages),
          hasMore: messages.isNotEmpty,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          messages: _seedMessages(),
          hasMore: false,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));

    try {
      final before = state.messages.isNotEmpty ? state.messages.last.createdAt : null;
      final older = await ChatApi.getMessages(chatId, before: before);
      final mapped = _mapMessages(older);
      emit(
        state.copyWith(
          messages: [...state.messages, ...mapped],
          isLoadingMore: false,
          hasMore: mapped.isNotEmpty,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false, hasMore: false));
    }
  }

  Future<void> sendText(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    try {
      final response = await ChatApi.sendMessage(chatId, text: trimmed);
      emit(state.copyWith(messages: [_mapMessage(response), ...state.messages]));
    } catch (_) {
      final local = ChatMessage(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        text: trimmed,
        isMine: true,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(messages: [local, ...state.messages]));
    }
  }

  Future<void> sendAttachment(MessageAttachment attachment) async {
    try {
      final response = await ChatApi.sendMessage(
        chatId,
        attachments: [
          ChatAttachmentInput(
            type: _typeToString(attachment.type),
            name: attachment.name,
            path: attachment.path,
          ),
        ],
      );
      emit(state.copyWith(messages: [_mapMessage(response), ...state.messages]));
    } catch (_) {
      final local = ChatMessage(
        id: 'file_${DateTime.now().millisecondsSinceEpoch}',
        text: '',
        isMine: true,
        createdAt: DateTime.now(),
        attachments: [attachment],
      );
      emit(state.copyWith(messages: [local, ...state.messages]));
    }
  }

  Future<bool> deleteChat() async {
    try {
      await ChatApi.deleteThread(chatId);
      emit(state.copyWith(messages: const []));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> blockUser() async {
    try {
      await ChatApi.blockThread(chatId);
      emit(state.copyWith(isBlocked: true));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> reportUser() async {
    try {
      await ChatApi.reportThread(chatId);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<ChatMessage> _mapMessages(List<ChatMessageDto> messages) {
    return messages.map(_mapMessage).toList();
  }

  ChatMessage _mapMessage(ChatMessageDto message) {
    return ChatMessage(
      id: message.id,
      text: message.text,
      isMine: message.isMine,
      createdAt: message.createdAt,
      attachments: message.attachments
          .map(
            (att) => MessageAttachment(
              type: _mapType(att.type),
              name: att.name,
              path: att.path,
            ),
          )
          .toList(),
    );
  }

  AttachmentType _mapType(String raw) {
    switch (raw) {
      case 'image':
        return AttachmentType.image;
      case 'video':
        return AttachmentType.video;
      case 'file':
      default:
        return AttachmentType.file;
    }
  }

  String _typeToString(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return 'image';
      case AttachmentType.video:
        return 'video';
      case AttachmentType.file:
        return 'file';
    }
  }

  List<ChatMessage> _seedMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 'seed_1',
        text: 'Привет! Готов к тренировке завтра?',
        isMine: false,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      ChatMessage(
        id: 'seed_2',
        text: 'Да, могу после 18:00. Где удобно?',
        isMine: true,
        createdAt: now.subtract(const Duration(minutes: 1)),
      ),
    ];
  }
}
