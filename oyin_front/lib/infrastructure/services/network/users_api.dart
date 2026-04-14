import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_endpoints.dart';
import 'mock_demo_runtime.dart';

class UserPushSettings {
  const UserPushSettings({
    required this.enabled,
    required this.intervalMinutes,
    required this.hasFcmToken,
    required this.pushPlatform,
    required this.pushTokenUpdatedAt,
    required this.pushReminderLastSentAt,
  });

  final bool enabled;
  final int intervalMinutes;
  final bool hasFcmToken;
  final String? pushPlatform;
  final DateTime? pushTokenUpdatedAt;
  final DateTime? pushReminderLastSentAt;

  factory UserPushSettings.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is! String || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    return UserPushSettings(
      enabled: json['enabled'] == true,
      intervalMinutes: (json['intervalMinutes'] as num?)?.toInt() ?? 60,
      hasFcmToken: json['hasFcmToken'] == true,
      pushPlatform: json['pushPlatform']?.toString(),
      pushTokenUpdatedAt: parseDate(json['pushTokenUpdatedAt']),
      pushReminderLastSentAt: parseDate(json['pushReminderLastSentAt']),
    );
  }
}

class UserAvailabilitySettings {
  const UserAvailabilitySettings({
    required this.city,
    required this.schedule,
    required this.profilesCount,
  });

  final String city;
  final Map<String, dynamic> schedule;
  final int profilesCount;

  factory UserAvailabilitySettings.fromJson(Map<String, dynamic> json) {
    final rawSchedule = json['schedule'];
    final schedule = rawSchedule is Map
        ? rawSchedule.cast<String, dynamic>()
        : <String, dynamic>{};

    return UserAvailabilitySettings(
      city: (json['city'] ?? '').toString(),
      schedule: schedule,
      profilesCount:
          (json['profilesCount'] as num?)?.toInt() ??
          (json['profilesUpdated'] as num?)?.toInt() ??
          0,
    );
  }
}

class UsersApi {
  static Future<Map<String, dynamic>> getMe() async {
    final runtime = MockDemoRuntime.instance;
    try {
      final data = await ApiClient.instance.get(ApiEndpoints.usersMe);
      final me = (data as Map).cast<String, dynamic>();
      runtime.syncCurrentUserFromAccount(me);
      return me;
    } catch (_) {
      return runtime.currentUser();
    }
  }

  static Future<void> updateProfile({
    String? name,
    String? email,
    String? city,
    DateTime? birthDate,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersUpdateProfile,
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (city != null) 'city': city,
        if (birthDate != null) 'birthDate': birthDate.toIso8601String(),
      },
    );
  }

  static Future<void> updatePassword({
    required String newPassword,
    String? currentPassword,
    String? code,
    String? email,
    String? phone,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersUpdatePassword,
      data: {
        'newPassword': newPassword,
        if (currentPassword != null && currentPassword.trim().isNotEmpty)
          'currentPassword': currentPassword.trim(),
        if (code != null && code.trim().isNotEmpty) 'code': code.trim(),
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      },
    );
  }

  static Future<void> createSportProfile({
    required String sportType,
    required String level,
    List<String> skills = const [],
    Map<String, dynamic> schedule = const {},
    List<String> achievements = const [],
    int? experienceYears,
  }) async {
    await ApiClient.instance.post(
      ApiEndpoints.usersOnboarding,
      data: {
        'sportType': sportType,
        'level': level,
        'skills': skills,
        'schedule': schedule,
        'achievements': achievements,
        if (experienceYears != null) 'experienceYears': experienceYears,
      },
    );
  }

  static Future<void> updateLocation({
    required double lat,
    required double lng,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersLocation,
      data: {'lat': lat, 'lng': lng},
    );
  }

  static Future<UserPushSettings> getPushSettings() async {
    final data = await ApiClient.instance.get(ApiEndpoints.usersPushSettings);
    return UserPushSettings.fromJson((data as Map).cast<String, dynamic>());
  }

  static Future<void> updatePushSettings({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersPushSettings,
      data: {'enabled': enabled, 'intervalMinutes': intervalMinutes},
    );
  }

  static Future<void> updatePushToken({
    required String token,
    required String platform,
  }) async {
    await ApiClient.instance.put(
      ApiEndpoints.usersPushToken,
      data: {'token': token, 'platform': platform},
    );
  }

  static Future<UserAvailabilitySettings> getAvailabilitySettings() async {
    final data = await ApiClient.instance.get(ApiEndpoints.usersAvailability);
    return UserAvailabilitySettings.fromJson(
      (data as Map).cast<String, dynamic>(),
    );
  }

  static Future<UserAvailabilitySettings> updateAvailabilitySettings({
    String? city,
    Map<String, dynamic>? schedule,
  }) async {
    final data = await ApiClient.instance.put(
      ApiEndpoints.usersAvailability,
      data: {
        if (city != null) 'city': city,
        if (schedule != null) 'schedule': schedule,
      },
    );
    return UserAvailabilitySettings.fromJson(
      (data as Map).cast<String, dynamic>(),
    );
  }

  static Future<List<Map<String, dynamic>>> replaceSportProfiles({
    required List<UserSportProfileInput> profiles,
  }) async {
    final data = await ApiClient.instance.put(
      ApiEndpoints.usersSportProfiles,
      data: {'profiles': profiles.map((item) => item.toMap()).toList()},
    );

    if (data is! Map) return const [];
    final rawProfiles = data['profiles'];
    if (rawProfiles is! List) return const [];
    return rawProfiles
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .toList();
  }

  static Future<String?> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final data = await ApiClient.instance.put(
      ApiEndpoints.usersAvatar,
      data: formData,
    );

    if (data is! Map) return null;
    final avatarUrl = data['avatarUrl']?.toString();
    if (avatarUrl == null || avatarUrl.isEmpty) return null;
    return avatarUrl;
  }
}

class UserSportProfileInput {
  const UserSportProfileInput({
    required this.sportType,
    required this.level,
    this.skills = const [],
    this.schedule = const {},
    this.achievements = const [],
    this.experienceYears,
  });

  final String sportType;
  final String level;
  final List<String> skills;
  final Map<String, dynamic> schedule;
  final List<dynamic> achievements;
  final int? experienceYears;

  Map<String, dynamic> toMap() {
    return {
      'sportType': sportType,
      'level': level,
      'skills': skills,
      'schedule': schedule,
      'achievements': achievements,
      if (experienceYears != null) 'experienceYears': experienceYears,
    };
  }
}
