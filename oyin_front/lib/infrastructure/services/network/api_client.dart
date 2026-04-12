import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';
import 'session_storage.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requestId = ++_requestCounter;
          options.extra['requestId'] = requestId;
          options.extra['startedAtMs'] = DateTime.now().millisecondsSinceEpoch;

          final token = await SessionStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logRequest(options, requestId);

          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);

          handler.next(response);
        },
        onError: (error, handler) async {
          await _handleUnauthorizedIfNeeded(error);
          _logError(error);

          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();
  static int _requestCounter = 0;
  static bool _isHandlingUnauthorized = false;
  late final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await _dio.get(path, queryParameters: query);
    return res.data;
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    final res = await _dio.post(path, data: data);
    return res.data;
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    final res = await _dio.put(path, data: data);
    return res.data;
  }

  Future<dynamic> delete(String path) async {
    final res = await _dio.delete(path);
    return res.data;
  }

  static void _logRequest(RequestOptions options, int requestId) {
    if (!kDebugMode) return;

    final method = options.method.toUpperCase();
    final uri = options.uri.toString();
    final query = options.queryParameters;
    final data = options.data;

    debugPrint('[API #$requestId] --> $method $uri');
    if (query.isNotEmpty) {
      debugPrint('[API #$requestId] query: ${_preview(query)}');
    }
    if (data != null) {
      debugPrint('[API #$requestId] body: ${_preview(data)}');
    }
  }

  static void _logResponse(Response<dynamic> response) {
    if (!kDebugMode) return;

    final options = response.requestOptions;
    final requestId = options.extra['requestId'] ?? '-';
    final startedAtMs = options.extra['startedAtMs'] as int?;
    final elapsedMs = startedAtMs == null
        ? '?'
        : '${DateTime.now().millisecondsSinceEpoch - startedAtMs}';
    final method = options.method.toUpperCase();
    final uri = options.uri.toString();
    final code = response.statusCode ?? 0;

    debugPrint('[API #$requestId] <-- $code $method $uri (${elapsedMs}ms)');
    if (response.data != null) {
      debugPrint('[API #$requestId] response: ${_preview(response.data)}');
    }
  }

  static void _logError(DioException error) {
    if (!kDebugMode) return;

    final options = error.requestOptions;
    final requestId = options.extra['requestId'] ?? '-';
    final startedAtMs = options.extra['startedAtMs'] as int?;
    final elapsedMs = startedAtMs == null
        ? '?'
        : '${DateTime.now().millisecondsSinceEpoch - startedAtMs}';
    final method = options.method.toUpperCase();
    final uri = options.uri.toString();
    final code = error.response?.statusCode;

    debugPrint(
      '[API #$requestId] <-- ERROR ${code ?? '-'} $method $uri (${elapsedMs}ms)',
    );
    debugPrint('[API #$requestId] message: ${error.message}');

    final errorBody = error.response?.data;
    if (errorBody != null) {
      debugPrint('[API #$requestId] errorBody: ${_preview(errorBody)}');
    }
  }

  static String _preview(dynamic value) {
    final text = value.toString().replaceAll('\n', ' ');
    const max = 500;
    if (text.length <= max) {
      return text;
    }
    return '${text.substring(0, max)}...';
  }

  static Future<void> _handleUnauthorizedIfNeeded(DioException error) async {
    final status = error.response?.statusCode;
    if (status != 401) return;

    final path = error.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/verify') ||
        path.contains('/auth/login-password')) {
      return;
    }

    if (_isHandlingUnauthorized) return;
    _isHandlingUnauthorized = true;
    try {
      if (kDebugMode) {
        debugPrint('[Session] Unauthorized response. Signing out.');
      }
      await SessionStorage.forceSignOut();
    } finally {
      _isHandlingUnauthorized = false;
    }
  }
}
