import 'package:equatable/equatable.dart';

enum AttachmentType { image, video, file }

class MessageAttachment extends Equatable {
  const MessageAttachment({
    required this.type,
    required this.name,
    required this.path,
  });

  final AttachmentType type;
  final String name;
  final String path;

  @override
  List<Object?> get props => [type, name, path];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.createdAt,
    this.attachments = const [],
  });

  final String id;
  final String text;
  final bool isMine;
  final DateTime createdAt;
  final List<MessageAttachment> attachments;

  @override
  List<Object?> get props => [id, text, isMine, createdAt, attachments];
}

class MessangerState extends Equatable {
  const MessangerState({
    required this.partnerName,
    required this.partnerAvatarUrl,
    required this.messages,
    required this.hasMore,
    required this.isLoadingMore,
    required this.isBlocked,
  });

  final String partnerName;
  final String partnerAvatarUrl;
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isBlocked;

  MessangerState copyWith({
    String? partnerName,
    String? partnerAvatarUrl,
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isBlocked,
  }) {
    return MessangerState(
      partnerName: partnerName ?? this.partnerName,
      partnerAvatarUrl: partnerAvatarUrl ?? this.partnerAvatarUrl,
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  List<Object?> get props => [
        partnerName,
        partnerAvatarUrl,
        messages,
        hasMore,
        isLoadingMore,
        isBlocked,
      ];
}
