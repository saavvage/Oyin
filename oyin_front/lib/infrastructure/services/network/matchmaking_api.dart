import '../../../domain/export.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'mock_demo_runtime.dart';

class SwipeResultDto {
  const SwipeResultDto({
    required this.success,
    required this.isMatch,
    this.threadId,
    this.gameId,
  });

  final bool success;
  final bool isMatch;
  final String? threadId;
  final String? gameId;

  factory SwipeResultDto.fromMap(Map<String, dynamic> map) {
    return SwipeResultDto(
      success: map['success'] == true,
      isMatch: map['isMatch'] == true,
      threadId: map['threadId']?.toString(),
      gameId: map['gameId']?.toString(),
    );
  }
}

class MatchmakingApi {
  static Future<List<MatchProfile>> getFeed(MatchFilters filters) async {
    try {
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

      if (data is! List) {
        return _mockFeed(filters);
      }

      final remote = data
          .whereType<Map>()
          .map((item) => MatchProfile.fromMap(item.cast<String, dynamic>()))
          .toList();

      if (remote.isNotEmpty) {
        return remote;
      }

      return _mockFeed(filters);
    } catch (_) {
      return _mockFeed(filters);
    }
  }

  static Future<SwipeResultDto> swipe({
    required String targetId,
    required String action,
  }) async {
    if (targetId.startsWith('test-')) {
      final mock = MockDemoRuntime.instance.swipe(
        targetId: targetId,
        action: action,
      );
      return SwipeResultDto.fromMap(mock);
    }

    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.matchmakingSwipe,
        data: {'targetId': targetId, 'action': action},
      );

      if (data is Map) {
        return SwipeResultDto.fromMap(data.cast<String, dynamic>());
      }
    } catch (_) {
      final mock = MockDemoRuntime.instance.swipe(
        targetId: targetId,
        action: action,
      );
      return SwipeResultDto.fromMap(mock);
    }

    return const SwipeResultDto(success: true, isMatch: false);
  }

  static Future<void> resetDislikes() async {
    try {
      await ApiClient.instance.post(ApiEndpoints.matchmakingResetDislikes);
    } catch (_) {
      MockDemoRuntime.instance.resetDislikes();
    }
  }

  static List<MatchProfile> _mockFeed(MatchFilters filters) {
    final data = MockDemoRuntime.instance.matchFeed(
      distanceMin: filters.distanceKmMin,
      distanceMax: filters.distanceKmMax,
      ageMin: filters.ageMin,
      ageMax: filters.ageMax,
      sport: filters.sport,
    );

    return data.map(MatchProfile.fromMap).toList();
  }
}
