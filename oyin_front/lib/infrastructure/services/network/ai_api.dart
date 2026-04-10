import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';
import 'session_storage.dart';

class AiChatRequest {
  const AiChatRequest({
    required this.userId,
    required this.message,
    this.userContext,
  });

  final String userId;
  final String message;
  final AiUserContext? userContext;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'message': message,
      if (userContext != null) 'user_context': userContext!.toMap(),
    };
  }
}

class AiUserContext {
  const AiUserContext({
    this.preferredSports = const [],
    this.skillLevels = const {},
    this.injuries = const [],
    this.matchesPlayed = 0,
  });

  final List<String> preferredSports;
  final Map<String, String> skillLevels;
  final List<String> injuries;
  final int matchesPlayed;

  Map<String, dynamic> toMap() {
    return {
      'preferred_sports': preferredSports,
      'skill_levels': skillLevels,
      'injuries': injuries,
      'matches_played': matchesPlayed,
    };
  }
}

class AiChatResponse {
  const AiChatResponse({
    required this.response,
    required this.usedRag,
    this.sources,
  });

  final String response;
  final bool usedRag;
  final List<String>? sources;

  factory AiChatResponse.fromMap(Map<String, dynamic> map) {
    return AiChatResponse(
      response: (map['response'] ?? '').toString(),
      usedRag: map['used_rag'] == true,
      sources: (map['sources'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}

class AiApi {
  AiApi._();
  static final AiApi instance = AiApi._();

  late final Dio _dio = _createDio();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.aiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SessionStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('[AI API] --> ${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[AI API] <-- ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[AI API] <-- ERROR ${error.response?.statusCode ?? '-'} ${error.requestOptions.uri}',
            );
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<AiChatResponse> chat(AiChatRequest request) async {
    final res = await _dio.post('/chat', data: request.toMap());
    return AiChatResponse.fromMap((res.data as Map).cast<String, dynamic>());
  }

  Future<bool> healthCheck() async {
    try {
      final res = await _dio.get('/health');
      return (res.data as Map?)?['status'] == 'healthy';
    } catch (_) {
      return false;
    }
  }
}
