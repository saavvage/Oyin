import 'api_client.dart';
import 'api_endpoints.dart';

class GameUserDto {
  const GameUserDto({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String avatarUrl;

  factory GameUserDto.fromMap(Map<String, dynamic> map) {
    return GameUserDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
    );
  }
}

class GameDetailsDto {
  const GameDetailsDto({
    required this.id,
    required this.type,
    required this.status,
    required this.player1,
    required this.player2,
    required this.scorePlayer1,
    required this.scorePlayer2,
    required this.player1Submitted,
    required this.player2Submitted,
    required this.disputeId,
    required this.location,
  });

  final String id;
  final String type;
  final String status;
  final GameUserDto player1;
  final GameUserDto player2;
  final String? scorePlayer1;
  final String? scorePlayer2;
  final bool player1Submitted;
  final bool player2Submitted;
  final String? disputeId;
  final String? location;

  factory GameDetailsDto.fromMap(Map<String, dynamic> map) {
    return GameDetailsDto(
      id: (map['id'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      player1: GameUserDto.fromMap(
        ((map['player1'] as Map?) ?? const {}).cast<String, dynamic>(),
      ),
      player2: GameUserDto.fromMap(
        ((map['player2'] as Map?) ?? const {}).cast<String, dynamic>(),
      ),
      scorePlayer1: map['scorePlayer1']?.toString(),
      scorePlayer2: map['scorePlayer2']?.toString(),
      player1Submitted: map['player1Submitted'] == true,
      player2Submitted: map['player2Submitted'] == true,
      disputeId: map['disputeId']?.toString(),
      location: (((map['contractData'] as Map?) ?? const {})['location'])
          ?.toString(),
    );
  }
}

class GameResultResponse {
  const GameResultResponse({
    required this.success,
    required this.gameId,
    required this.status,
    required this.scoresMatch,
    required this.game,
  });

  final bool success;
  final String gameId;
  final String status;
  final bool scoresMatch;
  final GameDetailsDto? game;

  factory GameResultResponse.fromMap(Map<String, dynamic> map) {
    final rawGame = map['game'];
    return GameResultResponse(
      success: map['success'] == true,
      gameId: (map['gameId'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      scoresMatch: map['scoresMatch'] == true,
      game: rawGame is Map
          ? GameDetailsDto.fromMap(rawGame.cast<String, dynamic>())
          : null,
    );
  }
}

class GamesApi {
  static Future<GameDetailsDto> getById(String gameId) async {
    final data = await ApiClient.instance.get(ApiEndpoints.gamesById(gameId));
    return GameDetailsDto.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<GameResultResponse> submitResult({
    required String gameId,
    required int myScore,
    required int opponentScore,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.gamesResult(gameId),
      data: {
        'myScore': myScore.toString(),
        'opponentScore': opponentScore.toString(),
      },
    );

    return GameResultResponse.fromMap((data as Map).cast<String, dynamic>());
  }
}
