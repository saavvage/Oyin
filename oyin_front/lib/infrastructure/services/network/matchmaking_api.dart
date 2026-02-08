import '../../../domain/export.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class MatchmakingApi {
  static Future<List<MatchProfile>> getFeed(MatchFilters filters) async {
    final data = await ApiClient.instance.get(
      ApiEndpoints.matchmakingFeed,
      query: {
        'distanceMin': filters.distanceKmMin,
        'distanceMax': filters.distanceKmMax,
        'ageMin': filters.ageMin,
        'ageMax': filters.ageMax,
      },
    );

    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => MatchProfile.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static Future<void> swipe({
    required String targetId,
    required String action,
  }) async {
    await ApiClient.instance.post(
      ApiEndpoints.matchmakingSwipe,
      data: {
        'targetId': targetId,
        'action': action,
      },
    );
  }

  static Future<void> resetDislikes() async {
    await ApiClient.instance.post(ApiEndpoints.matchmakingResetDislikes);
  }
}
