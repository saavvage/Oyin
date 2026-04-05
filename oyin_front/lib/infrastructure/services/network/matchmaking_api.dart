import '../../../domain/export.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class SwipeResultDto {
  const SwipeResultDto({
    required this.success,
    required this.isMatch,
    this.threadId,
  });

  final bool success;
  final bool isMatch;
  final String? threadId;

  factory SwipeResultDto.fromMap(Map<String, dynamic> map) {
    return SwipeResultDto(
      success: map['success'] == true,
      isMatch: map['isMatch'] == true,
      threadId: map['threadId']?.toString(),
    );
  }
}

class MatchmakingApi {
  static Future<List<MatchProfile>> getFeed(MatchFilters filters) async {
    final data = await ApiClient.instance.get(
      ApiEndpoints.matchmakingFeed,
      query: {
        'distanceMin': filters.distanceKmMin,
        'distanceMax': filters.distanceKmMax,
        'ageMin': filters.ageMin,
        'ageMax': filters.ageMax,
        if (filters.sport != null) 'sport': filters.sport,
      },
    );

    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => MatchProfile.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static Future<SwipeResultDto> swipe({
    required String targetId,
    required String action,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.matchmakingSwipe,
      data: {'targetId': targetId, 'action': action},
    );

    if (data is Map) {
      return SwipeResultDto.fromMap(data.cast<String, dynamic>());
    }

    return const SwipeResultDto(success: true, isMatch: false);
  }

  static Future<void> resetDislikes() async {
    await ApiClient.instance.post(ApiEndpoints.matchmakingResetDislikes);
  }
}
