import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../network/api_config.dart';
import '../network/chat_api.dart';
import '../network/session_storage.dart';

class ChatSocketService {
  ChatSocketService._();

  static final ChatSocketService instance = ChatSocketService._();

  final StreamController<ChatMessageDto> _messagesController =
      StreamController<ChatMessageDto>.broadcast();

  io.Socket? _socket;
  bool _isConnecting = false;
  final Set<String> _joinedThreads = <String>{};

  Stream<ChatMessageDto> get messages => _messagesController.stream;

  Future<void> connect() async {
    if (_socket?.connected == true || _isConnecting) return;

    final token = await SessionStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[ChatWS] Access token is missing, socket not connected.');
      return;
    }

    _isConnecting = true;

    final baseUrl = _resolveSocketBaseUrl(ApiConfig.baseUrl);
    final socket = io.io(
      '$baseUrl/chats',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(10000)
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      debugPrint('[ChatWS] Connected');
      _joinAllSubscribedThreads();
    });

    socket.onDisconnect((reason) {
      debugPrint('[ChatWS] Disconnected: $reason');
    });

    socket.onConnectError((error) {
      debugPrint('[ChatWS] Connect error: $error');
    });

    socket.onError((error) {
      debugPrint('[ChatWS] Socket error: $error');
    });

    socket.on('chat:error', (payload) {
      debugPrint('[ChatWS] chat:error -> $payload');
    });

    socket.on('message:new', (payload) {
      final parsed = _parseChatMessage(payload);
      if (parsed == null) return;
      _messagesController.add(parsed);
    });

    _socket = socket;
    socket.connect();
    _isConnecting = false;
  }

  void joinThread(String threadId) {
    final normalized = threadId.trim();
    if (normalized.isEmpty) return;

    _joinedThreads.add(normalized);

    if (_socket?.connected == true) {
      _socket?.emit('thread:join', {'threadId': normalized});
    }
  }

  void leaveThread(String threadId) {
    final normalized = threadId.trim();
    if (normalized.isEmpty) return;

    _joinedThreads.remove(normalized);

    if (_socket?.connected == true) {
      _socket?.emit('thread:leave', {'threadId': normalized});
    }
  }

  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void _joinAllSubscribedThreads() {
    if (_socket?.connected != true) return;

    for (final threadId in _joinedThreads) {
      _socket?.emit('thread:join', {'threadId': threadId});
    }
  }

  ChatMessageDto? _parseChatMessage(dynamic payload) {
    if (payload is! Map) {
      return null;
    }

    try {
      return ChatMessageDto.fromMap(payload.cast<String, dynamic>());
    } catch (error) {
      debugPrint('[ChatWS] Failed to parse message payload: $error');
      return null;
    }
  }

  String _resolveSocketBaseUrl(String apiBaseUrl) {
    final trimmed = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;

    if (trimmed.endsWith('/api')) {
      return trimmed.substring(0, trimmed.length - 4);
    }

    return trimmed;
  }
}
