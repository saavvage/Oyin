import 'package:equatable/equatable.dart';

class AiMessage extends Equatable {
  const AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
    this.sources,
    this.usedRag = false,
    this.isLoading = false,
    this.isError = false,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final List<String>? sources;
  final bool usedRag;
  final bool isLoading;
  final bool isError;

  @override
  List<Object?> get props => [id, text, isUser, createdAt, sources, usedRag, isLoading, isError];
}

class AiChatState extends Equatable {
  const AiChatState({
    this.messages = const [],
    this.isSending = false,
    this.isOnline = true,
  });

  final List<AiMessage> messages;
  final bool isSending;
  final bool isOnline;

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? isSending,
    bool? isOnline,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, isOnline];
}
