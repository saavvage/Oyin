import 'api_client.dart';
import 'api_endpoints.dart';

class UsersApi {
  static Future<Map<String, dynamic>> getMe() async {
    final data = await ApiClient.instance.get(ApiEndpoints.usersMe);
    return (data as Map).cast<String, dynamic>();
  }

  static Future<void> updateProfile({
    required String name,
    required String email,
    required String city,
    DateTime? birthDate,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersUpdateProfile,
      data: {
        'name': name,
        'email': email,
        'city': city,
        if (birthDate != null) 'birthDate': birthDate.toIso8601String(),
      },
    );
  }

  static Future<void> createSportProfile({
    required String sportType,
    required String level,
    List<String> skills = const [],
    Map<String, dynamic> schedule = const {},
    List<String> achievements = const [],
  }) async {
    await ApiClient.instance.post(
      ApiEndpoints.usersOnboarding,
      data: {
        'sportType': sportType,
        'level': level,
        'skills': skills,
        'schedule': schedule,
        'achievements': achievements,
      },
    );
  }

  static Future<void> updateLocation({required double lat, required double lng}) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersLocation,
      data: {'lat': lat, 'lng': lng},
    );
  }
}
