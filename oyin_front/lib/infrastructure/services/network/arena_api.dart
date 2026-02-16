import 'api_client.dart';
import 'api_endpoints.dart';

class ArenaPlayerDto {
  const ArenaPlayerDto({
    required this.rank,
    required this.userId,
    required this.name,
    required this.rating,
    required this.gamesPlayed,
    required this.avatar,
    required this.reliabilityScore,
  });

  final int rank;
  final String userId;
  final String name;
  final int rating;
  final int gamesPlayed;
  final String avatar;
  final double reliabilityScore;

  factory ArenaPlayerDto.fromMap(Map<String, dynamic> map) {
    return ArenaPlayerDto(
      rank: (map['rank'] is num) ? (map['rank'] as num).toInt() : 0,
      userId: (map['userId'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      rating: (map['rating'] is num) ? (map['rating'] as num).toInt() : 0,
      gamesPlayed: (map['gamesPlayed'] is num)
          ? (map['gamesPlayed'] as num).toInt()
          : 0,
      avatar: (map['avatar'] ?? '').toString(),
      reliabilityScore: (map['reliabilityScore'] is num)
          ? (map['reliabilityScore'] as num).toDouble()
          : 0,
    );
  }
}

class ArenaChallengeResponse {
  const ArenaChallengeResponse({
    required this.success,
    required this.gameId,
    required this.status,
  });

  final bool success;
  final String gameId;
  final String status;

  factory ArenaChallengeResponse.fromMap(Map<String, dynamic> map) {
    return ArenaChallengeResponse(
      success: map['success'] == true,
      gameId: (map['gameId'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
    );
  }
}

class ArenaApi {
  static Future<List<ArenaPlayerDto>> getLeaderboard({
    String sport = 'TENNIS',
  }) async {
    final data = await ApiClient.instance.get(
      ApiEndpoints.arenaLeaderboard,
      query: {'sport': sport},
    );

    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => ArenaPlayerDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static Future<ArenaChallengeResponse> challenge({
    required String targetId,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.arenaChallenge,
      data: {'targetId': targetId},
    );

    return ArenaChallengeResponse.fromMap(
      (data as Map).cast<String, dynamic>(),
    );
  }
}
