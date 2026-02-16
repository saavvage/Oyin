import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    final raw = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3000';
    final trimmed = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
    if (trimmed.endsWith('/api')) {
      return trimmed;
    }
    return '$trimmed/api';
  }
}
