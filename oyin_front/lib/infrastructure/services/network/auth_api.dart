import 'api_client.dart';
import 'api_endpoints.dart';

class AuthApi {
  static Future<AuthVerifyResponse> register({
    required String email,
    required String password,
    String? phone,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.authRegister,
      data: {
        'email': email,
        'password': password,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      },
    );

    return AuthVerifyResponse.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<AuthVerifyResponse> loginWithPassword({
    required String login,
    required String password,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.authLoginPassword,
      data: {'login': login.trim(), 'password': password},
    );

    return AuthVerifyResponse.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<void> login({required String phone}) async {
    await ApiClient.instance.post(
      ApiEndpoints.authLogin,
      data: {'phone': phone},
    );
  }

  static Future<void> loginWithEmail({required String email}) async {
    await ApiClient.instance.post(
      ApiEndpoints.authLogin,
      data: {'email': email},
    );
  }

  static Future<AuthVerifyResponse> verify({
    required String phone,
    required String code,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.authVerify,
      data: {'phone': phone, 'code': code},
    );

    return AuthVerifyResponse.fromMap(data as Map<String, dynamic>);
  }

  static Future<AuthVerifyResponse> verifyEmail({
    required String email,
    required String code,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.authVerify,
      data: {'email': email, 'code': code},
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
