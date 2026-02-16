import 'api_client.dart';
import 'api_endpoints.dart';

class ChatThreadsResponse {
  const ChatThreadsResponse({
    required this.actionRequired,
    required this.upcoming,
  });

  final List<ChatThreadDto> actionRequired;
  final List<ChatThreadDto> upcoming;

  factory ChatThreadsResponse.fromMap(Map<String, dynamic> map) {
    return ChatThreadsResponse(
      actionRequired: _parseThreads(map['actionRequired']),
      upcoming: _parseThreads(map['upcoming']),
    );
  }

  static List<ChatThreadDto> _parseThreads(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => ChatThreadDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }
}

class ChatThreadDto {
  const ChatThreadDto({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.statusKey,
    required this.timestamp,
    this.badgeCount,
    this.accent,
    this.highlight,
    this.buttonKey,
  });

  final String id;
  final String name;
  final String subtitle;
  final String avatarUrl;
  final String statusKey;
  final String timestamp;
  final int? badgeCount;
  final String? accent;
  final bool? highlight;
  final String? buttonKey;

  factory ChatThreadDto.fromMap(Map<String, dynamic> map) {
    return ChatThreadDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
      statusKey: (map['statusKey'] ?? '').toString(),
      timestamp: (map['timestamp'] ?? '').toString(),
      badgeCount: map['badgeCount'] is int ? map['badgeCount'] as int : null,
      accent: map['accent']?.toString(),
      highlight: map['highlight'] == true,
      buttonKey: map['buttonKey']?.toString(),
    );
  }
}

class ChatAttachmentDto {
  const ChatAttachmentDto({
    required this.type,
    required this.name,
    required this.path,
  });

  final String type;
  final String name;
  final String path;

  factory ChatAttachmentDto.fromMap(Map<String, dynamic> map) {
    return ChatAttachmentDto(
      type: (map['type'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      path: (map['path'] ?? '').toString(),
    );
  }
}

class ChatMessageDto {
  const ChatMessageDto({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.isMine,
    required this.createdAt,
    required this.attachments,
  });

  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final bool isMine;
  final DateTime createdAt;
  final List<ChatAttachmentDto> attachments;

  factory ChatMessageDto.fromMap(Map<String, dynamic> map) {
    final rawAttachments = map['attachments'];
    final attachments = <ChatAttachmentDto>[];
    if (rawAttachments is List) {
      for (final item in rawAttachments) {
        if (item is Map) {
          attachments.add(
            ChatAttachmentDto.fromMap(item.cast<String, dynamic>()),
          );
        }
      }
    }

    return ChatMessageDto(
      id: (map['id'] ?? '').toString(),
      threadId: (map['threadId'] ?? '').toString(),
      senderId: (map['senderId'] ?? '').toString(),
      text: (map['text'] ?? '').toString(),
      isMine: map['isMine'] == true,
      createdAt:
          DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      attachments: attachments,
    );
  }
}

class ChatAttachmentInput {
  const ChatAttachmentInput({
    required this.type,
    required this.name,
    required this.path,
  });

  final String type;
  final String name;
  final String path;

  Map<String, dynamic> toMap() {
    return {'type': type, 'name': name, 'path': path};
  }
}

class ChatApi {
  static Future<ChatThreadDto> createOrGetDirectThread(
    String partnerUserId,
  ) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.chatsCreateThread,
      data: {'partnerUserId': partnerUserId},
    );

    return ChatThreadDto.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<ChatThreadsResponse> getThreads() async {
    final data = await ApiClient.instance.get(ApiEndpoints.chatsThreads);
    return ChatThreadsResponse.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<List<ChatMessageDto>> getMessages(
    String threadId, {
    DateTime? before,
  }) async {
    final data = await ApiClient.instance.get(
      ApiEndpoints.chatsMessages(threadId),
      query: {if (before != null) 'before': before.toIso8601String()},
    );

    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => ChatMessageDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static Future<ChatMessageDto> sendMessage(
    String threadId, {
    String? text,
    List<ChatAttachmentInput> attachments = const [],
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.chatsMessages(threadId),
      data: {
        if (text != null) 'text': text,
        if (attachments.isNotEmpty)
          'attachments': attachments.map((e) => e.toMap()).toList(),
      },
    );

    return ChatMessageDto.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<void> deleteThread(String threadId) async {
    await ApiClient.instance.delete(ApiEndpoints.chatsDelete(threadId));
  }

  static Future<void> blockThread(String threadId) async {
    await ApiClient.instance.post(ApiEndpoints.chatsBlock(threadId));
  }

  static Future<void> reportThread(String threadId, {String? reason}) async {
    await ApiClient.instance.post(
      ApiEndpoints.chatsReport(threadId),
      data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
  }
}
