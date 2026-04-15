import 'api_client.dart';
import 'api_endpoints.dart';
import 'mock_demo_runtime.dart';

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
    required this.isBlocked,
    this.partnerUserId,
    this.gameId,
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
  final bool isBlocked;
  final String? partnerUserId;
  final String? gameId;
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
      isBlocked: map['isBlocked'] == true,
      partnerUserId: map['partnerUserId']?.toString(),
      gameId: map['gameId']?.toString(),
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
    String partnerUserId, {
    String? partnerName,
    String? partnerAvatarUrl,
  }) async {
    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.chatsCreateThread,
        data: {'partnerUserId': partnerUserId},
      );

      return ChatThreadDto.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      final data = MockDemoRuntime.instance.createOrGetDirectThread(
        partnerUserId: partnerUserId,
        partnerName: partnerName,
        partnerAvatarUrl: partnerAvatarUrl,
      );
      return ChatThreadDto.fromMap(data);
    }
  }

  static Future<void> blockByPartner({
    required String partnerUserId,
    String? partnerName,
    String? partnerAvatarUrl,
  }) async {
    final thread = await createOrGetDirectThread(
      partnerUserId,
      partnerName: partnerName,
      partnerAvatarUrl: partnerAvatarUrl,
    );
    await blockByThread(
      threadId: thread.id,
      partnerUserId: partnerUserId,
      partnerName: partnerName,
      partnerAvatarUrl: partnerAvatarUrl,
    );
  }

  static Future<void> blockByThread({
    required String threadId,
    String? partnerUserId,
    String? partnerName,
    String? partnerAvatarUrl,
  }) async {
    final runtime = MockDemoRuntime.instance;
    final normalizedId = threadId.trim();
    if (normalizedId.isEmpty) {
      throw StateError('threadId is required');
    }

    if (runtime.isLocalThread(normalizedId)) {
      runtime.setThreadBlocked(normalizedId, true);
      return;
    }

    try {
      await ApiClient.instance.post(ApiEndpoints.chatsBlock(normalizedId));
    } catch (_) {
      final effectiveThreadId = _ensureLocalThreadForBlockFallback(
        threadId: normalizedId,
        partnerUserId: partnerUserId,
        partnerName: partnerName,
        partnerAvatarUrl: partnerAvatarUrl,
      );
      runtime.setThreadBlocked(effectiveThreadId, true);
    }
  }

  static Future<ChatThreadsResponse> getThreads() async {
    final runtime = MockDemoRuntime.instance;
    final local = runtime.chatThreads();
    final localAction = _threadsFromRaw(local['actionRequired']);
    final localUpcoming = _threadsFromRaw(local['upcoming']);

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.chatsThreads);
      final remote = ChatThreadsResponse.fromMap(
        (data as Map).cast<String, dynamic>(),
      );

      return ChatThreadsResponse(
        actionRequired: _mergeThreads(remote.actionRequired, localAction),
        upcoming: _mergeThreads(remote.upcoming, localUpcoming),
      );
    } catch (_) {
      return ChatThreadsResponse(
        actionRequired: localAction,
        upcoming: localUpcoming,
      );
    }
  }

  static Future<List<ChatThreadDto>> getBlockedThreads() async {
    final local = _threadsFromRaw(MockDemoRuntime.instance.blockedThreads());

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.chatsBlocked);
      if (data is! List) return local;
      final remote = data
          .whereType<Map>()
          .map((item) => ChatThreadDto.fromMap(item.cast<String, dynamic>()))
          .toList();
      return _mergeThreads(remote, local);
    } catch (_) {
      return local;
    }
  }

  static Future<List<ChatMessageDto>> getMessages(
    String threadId, {
    DateTime? before,
  }) async {
    final runtime = MockDemoRuntime.instance;
    final local = _messagesFromRaw(
      runtime.threadMessages(threadId, before: before),
    );

    if (runtime.isLocalThread(threadId)) {
      return local;
    }

    try {
      final data = await ApiClient.instance.get(
        ApiEndpoints.chatsMessages(threadId),
        query: {if (before != null) 'before': before.toIso8601String()},
      );

      if (data is! List) return local;
      final remote = data
          .whereType<Map>()
          .map((item) => ChatMessageDto.fromMap(item.cast<String, dynamic>()))
          .toList();
      if (remote.isNotEmpty) return remote;
      return local;
    } catch (_) {
      return local;
    }
  }

  static Future<ChatMessageDto> sendMessage(
    String threadId, {
    String? text,
    List<ChatAttachmentInput> attachments = const [],
  }) async {
    final runtime = MockDemoRuntime.instance;
    final payload = {
      if (text != null) 'text': text,
      if (attachments.isNotEmpty)
        'attachments': attachments.map((e) => e.toMap()).toList(),
    };

    if (runtime.isLocalThread(threadId)) {
      final local = runtime.sendMessage(
        threadId,
        text: text,
        attachments: attachments.map((e) => e.toMap()).toList(),
      );
      return ChatMessageDto.fromMap(local);
    }

    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.chatsMessages(threadId),
        data: payload,
      );

      return ChatMessageDto.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      final local = runtime.sendMessage(
        threadId,
        text: text,
        attachments: attachments.map((e) => e.toMap()).toList(),
      );
      return ChatMessageDto.fromMap(local);
    }
  }

  static Future<void> deleteThread(String threadId) async {
    final runtime = MockDemoRuntime.instance;
    if (runtime.isLocalThread(threadId)) {
      runtime.deleteThread(threadId);
      return;
    }

    try {
      await ApiClient.instance.delete(ApiEndpoints.chatsDelete(threadId));
    } catch (_) {
      runtime.deleteThread(threadId);
    }
  }

  static Future<void> blockThread(String threadId) async {
    final runtime = MockDemoRuntime.instance;
    if (runtime.isLocalThread(threadId)) {
      runtime.setThreadBlocked(threadId, true);
      return;
    }

    try {
      await ApiClient.instance.post(ApiEndpoints.chatsBlock(threadId));
    } catch (_) {
      final effectiveThreadId = _ensureLocalThreadForBlockFallback(
        threadId: threadId,
      );
      runtime.setThreadBlocked(effectiveThreadId, true);
    }
  }

  static Future<void> unblockThread(String threadId) async {
    final runtime = MockDemoRuntime.instance;
    if (runtime.isLocalThread(threadId)) {
      runtime.setThreadBlocked(threadId, false);
      return;
    }

    try {
      await ApiClient.instance.post(ApiEndpoints.chatsUnblock(threadId));
    } catch (_) {
      runtime.setThreadBlocked(threadId, false);
    }
  }

  static Future<void> reportThread(String threadId, {String? reason}) async {
    if (MockDemoRuntime.instance.isLocalThread(threadId)) {
      return;
    }

    try {
      await ApiClient.instance.post(
        ApiEndpoints.chatsReport(threadId),
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );
    } catch (_) {
      // ignore for mock-only chats
    }
  }

  static List<ChatThreadDto> _threadsFromRaw(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => ChatThreadDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static List<ChatThreadDto> _mergeThreads(
    List<ChatThreadDto> remote,
    List<ChatThreadDto> local,
  ) {
    final byId = <String, ChatThreadDto>{};
    for (final item in remote) {
      byId[item.id] = item;
    }
    for (final item in local) {
      byId[item.id] = item;
    }
    return byId.values.toList();
  }

  static List<ChatMessageDto> _messagesFromRaw(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => ChatMessageDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static String _ensureLocalThreadForBlockFallback({
    required String threadId,
    String? partnerUserId,
    String? partnerName,
    String? partnerAvatarUrl,
  }) {
    final runtime = MockDemoRuntime.instance;
    if (runtime.isLocalThread(threadId)) return threadId;

    if (partnerUserId != null && partnerUserId.trim().isNotEmpty) {
      final created = runtime.createOrGetDirectThread(
        partnerUserId: partnerUserId.trim(),
        partnerName: partnerName,
        partnerAvatarUrl: partnerAvatarUrl,
      );
      final id = (created['id'] ?? '').toString().trim();
      if (id.isNotEmpty) return id;
    }

    final created = runtime.ensureThread(
      threadId: threadId.trim(),
      partnerUserId: partnerUserId?.trim(),
      partnerName: partnerName,
      partnerAvatarUrl: partnerAvatarUrl,
    );
    final id = (created['id'] ?? '').toString().trim();
    return id.isEmpty ? threadId : id;
  }
}
