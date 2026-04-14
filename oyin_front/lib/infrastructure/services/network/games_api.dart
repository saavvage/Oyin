import 'api_client.dart';
import 'api_endpoints.dart';
import 'mock_demo_runtime.dart';

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

class GameContractDto {
  const GameContractDto({
    required this.date,
    required this.venueId,
    required this.reminder,
    required this.location,
  });

  final DateTime? date;
  final String? venueId;
  final bool reminder;
  final String? location;

  factory GameContractDto.fromMap(Map<String, dynamic> map) {
    return GameContractDto(
      date: DateTime.tryParse((map['date'] ?? '').toString()),
      venueId: map['venueId']?.toString(),
      reminder: map['reminder'] == true,
      location: map['location']?.toString(),
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
    required this.contractData,
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
  final GameContractDto? contractData;
  final String? location;

  factory GameDetailsDto.fromMap(Map<String, dynamic> map) {
    final rawContract = map['contractData'];
    final contract = rawContract is Map
        ? GameContractDto.fromMap(rawContract.cast<String, dynamic>())
        : null;

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
      contractData: contract,
      location: contract?.location,
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

class GameHistoryDto {
  const GameHistoryDto({
    required this.id,
    required this.status,
    required this.opponentName,
    required this.opponentAvatarUrl,
    required this.result,
    required this.score,
    required this.createdAt,
    required this.disputeId,
  });

  final String id;
  final String status;
  final String opponentName;
  final String opponentAvatarUrl;
  final String result; // win, loss, draw, pending
  final String? score;
  final DateTime? createdAt;
  final String? disputeId;

  factory GameHistoryDto.fromMap(Map<String, dynamic> map, String myUserId) {
    final player1 = (map['player1'] as Map?)?.cast<String, dynamic>() ?? {};
    final player2 = (map['player2'] as Map?)?.cast<String, dynamic>() ?? {};
    final isPlayer1 = (player1['id'] ?? '') == myUserId;
    final opponent = isPlayer1 ? player2 : player1;
    final scoreP1 = map['scorePlayer1']?.toString();

    return GameHistoryDto(
      id: (map['id'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      opponentName: (opponent['name'] ?? 'Opponent').toString(),
      opponentAvatarUrl: (opponent['avatarUrl'] ?? '').toString(),
      result: (map['result'] ?? 'pending').toString(),
      score: scoreP1,
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()),
      disputeId: map['disputeId']?.toString(),
    );
  }
}

class GamesApi {
  static Future<List<GameHistoryDto>> getMyGames(String myUserId) async {
    final runtime = MockDemoRuntime.instance;
    final localMaps = runtime.myGames(myUserId);
    final localMyUserId = runtime.currentUserId;
    final local = localMaps
        .map((e) => GameHistoryDto.fromMap(e, localMyUserId))
        .toList();

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.gamesMy);
      if (data is! List) return local;

      final remote = data
          .whereType<Map>()
          .map(
            (e) => GameHistoryDto.fromMap(e.cast<String, dynamic>(), myUserId),
          )
          .toList();

      if (remote.isEmpty) {
        return local;
      }

      final byId = <String, GameHistoryDto>{};
      for (final game in remote) {
        byId[game.id] = game;
      }
      for (final game in local) {
        byId[game.id] = game;
      }
      final merged = byId.values.toList()
        ..sort(
          (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
        );
      return merged;
    } catch (_) {
      return local;
    }
  }

  static Future<GameDetailsDto> getById(String gameId) async {
    final runtime = MockDemoRuntime.instance;
    if (runtime.hasLocalGame(gameId) || gameId.startsWith('demo-game-')) {
      return GameDetailsDto.fromMap(runtime.gameById(gameId));
    }

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.gamesById(gameId));
      return GameDetailsDto.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      return GameDetailsDto.fromMap(runtime.gameById(gameId));
    }
  }

  static Future<GameDetailsDto> proposeContract({
    required String gameId,
    required DateTime dateTime,
    required String location,
    bool reminder = true,
    String? venueId,
  }) async {
    final payload = {
      'date': dateTime.toIso8601String(),
      'location': location,
      'reminder': reminder,
      if (venueId != null && venueId.isNotEmpty) 'venueId': venueId,
    };

    final runtime = MockDemoRuntime.instance;
    if (runtime.hasLocalGame(gameId) || gameId.startsWith('demo-game-')) {
      final data = runtime.proposeContract(
        gameId: gameId,
        dateTime: dateTime,
        location: location,
        reminder: reminder,
        venueId: venueId,
      );
      return GameDetailsDto.fromMap(data);
    }

    try {
      await ApiClient.instance.post(
        ApiEndpoints.gamesContract(gameId),
        data: payload,
      );
      return getById(gameId);
    } catch (_) {
      final data = runtime.proposeContract(
        gameId: gameId,
        dateTime: dateTime,
        location: location,
        reminder: reminder,
        venueId: venueId,
      );
      return GameDetailsDto.fromMap(data);
    }
  }

  static Future<GameResultResponse> submitResult({
    required String gameId,
    required int myScore,
    required int opponentScore,
  }) async {
    final payload = {
      'myScore': myScore.toString(),
      'opponentScore': opponentScore.toString(),
    };

    final runtime = MockDemoRuntime.instance;
    if (runtime.hasLocalGame(gameId) || gameId.startsWith('demo-game-')) {
      final data = runtime.submitResult(
        gameId: gameId,
        myScore: myScore,
        opponentScore: opponentScore,
      );
      return GameResultResponse.fromMap(data);
    }

    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.gamesResult(gameId),
        data: payload,
      );
      return GameResultResponse.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      final data = runtime.submitResult(
        gameId: gameId,
        myScore: myScore,
        opponentScore: opponentScore,
      );
      return GameResultResponse.fromMap(data);
    }
  }
}
