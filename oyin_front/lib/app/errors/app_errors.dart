import 'dart:io';

import 'package:dio/dio.dart';

enum AppErrorCode {
  noConnection,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  server,
  unknown,
}

class AppErrorMapper {
  static AppErrorCode fromException(Object error) {
    if (error is DioException) {
      return _fromDio(error);
    }

    if (error is SocketException) {
      return AppErrorCode.noConnection;
    }

    return AppErrorCode.unknown;
  }

  static AppErrorCode _fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppErrorCode.timeout;
      case DioExceptionType.connectionError:
        return AppErrorCode.noConnection;
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        if (status == 401) return AppErrorCode.unauthorized;
        if (status == 403) return AppErrorCode.forbidden;
        if (status == 404) return AppErrorCode.notFound;
        if (status >= 500) return AppErrorCode.server;
        return AppErrorCode.unknown;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return AppErrorCode.unknown;
    }
  }
}
