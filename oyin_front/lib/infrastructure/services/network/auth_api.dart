import 'api_client.dart';
import 'api_endpoints.dart';

class AuthApi {
  static Future<void> login({required String phone}) async {
    await ApiClient.instance.post(ApiEndpoints.authLogin, data: {'phone': phone});
  }

  static Future<AuthVerifyResponse> verify({required String phone, required String code}) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.authVerify,
      data: {'phone': phone, 'code': code},
    );

    return AuthVerifyResponse.fromMap(data as Map<String, dynamic>);
  }
}

class AuthVerifyResponse {
  const AuthVerifyResponse({
    required this.accessToken,
    required this.isNewUser,
    required this.user,
  });

  final String accessToken;
  final bool isNewUser;
  final Map<String, dynamic> user;

  factory AuthVerifyResponse.fromMap(Map<String, dynamic> map) {
    return AuthVerifyResponse(
      accessToken: (map['accessToken'] ?? '').toString(),
      isNewUser: map['isNewUser'] == true,
      user: (map['user'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }
}
