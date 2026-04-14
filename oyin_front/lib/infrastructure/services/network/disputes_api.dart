import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_endpoints.dart';
import 'mock_demo_runtime.dart';

class DisputeEvidenceInput {
  const DisputeEvidenceInput({
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.durationLabel,
  });

  final String type;
  final String url;
  final String? thumbnailUrl;
  final String? durationLabel;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'url': url,
      if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
        'thumbnailUrl': thumbnailUrl,
      if (durationLabel != null && durationLabel!.isNotEmpty)
        'durationLabel': durationLabel,
    };
  }
}

class DisputeEvidenceDto {
  const DisputeEvidenceDto({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    required this.durationLabel,
  });

  final String id;
  final String type;
  final String url;
  final String? thumbnailUrl;
  final String? durationLabel;

  factory DisputeEvidenceDto.fromMap(Map<String, dynamic> map) {
    return DisputeEvidenceDto(
      id: (map['id'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      url: (map['url'] ?? '').toString(),
      thumbnailUrl: map['thumbnailUrl']?.toString(),
      durationLabel: map['durationLabel']?.toString(),
    );
  }
}

class DisputePlayerSideDto {
  const DisputePlayerSideDto({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.reliabilityScore,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final double? reliabilityScore;

  factory DisputePlayerSideDto.fromMap(Map<String, dynamic> map) {
    return DisputePlayerSideDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
      reliabilityScore: map['reliabilityScore'] is num
          ? (map['reliabilityScore'] as num).toDouble()
          : null,
    );
  }
}

class DisputeParticipantDto {
  const DisputeParticipantDto({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.statement,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String statement;

  factory DisputeParticipantDto.fromMap(Map<String, dynamic> map) {
    return DisputeParticipantDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
      statement: (map['statement'] ?? '').toString(),
    );
  }
}

class DisputeVoteSummaryDto {
  const DisputeVoteSummaryDto({
    required this.total,
    required this.requiredToResolve,
    required this.player1,
    required this.player2,
    required this.draw,
  });

  final int total;
  final int requiredToResolve;
  final int player1;
  final int player2;
  final int draw;

  factory DisputeVoteSummaryDto.fromMap(Map<String, dynamic> map) {
    return DisputeVoteSummaryDto(
      total: (map['total'] is num) ? (map['total'] as num).toInt() : 0,
      requiredToResolve: (map['requiredToResolve'] is num)
          ? (map['requiredToResolve'] as num).toInt()
          : 3,
      player1: (map['player1'] is num) ? (map['player1'] as num).toInt() : 0,
      player2: (map['player2'] is num) ? (map['player2'] as num).toInt() : 0,
      draw: (map['draw'] is num) ? (map['draw'] as num).toInt() : 0,
    );
  }
}

class DisputeResolutionPersonDto {
  const DisputeResolutionPersonDto({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String avatarUrl;

  factory DisputeResolutionPersonDto.fromMap(Map<String, dynamic> map) {
    return DisputeResolutionPersonDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
    );
  }
}

class DisputeRatingImpactDto {
  const DisputeRatingImpactDto({
    required this.player1Before,
    required this.player1After,
    required this.player2Before,
    required this.player2After,
  });

  final int? player1Before;
  final int? player1After;
  final int? player2Before;
  final int? player2After;

  factory DisputeRatingImpactDto.fromMap(Map<String, dynamic> map) {
    int? asInt(dynamic value) => value is num ? value.toInt() : null;

    return DisputeRatingImpactDto(
      player1Before: asInt(map['player1Before']),
      player1After: asInt(map['player1After']),
      player2Before: asInt(map['player2Before']),
      player2After: asInt(map['player2After']),
    );
  }
}

class DisputeResolutionDto {
  const DisputeResolutionDto({
    required this.winningSide,
    required this.winner,
    required this.loser,
    required this.ratingImpact,
  });

  final String winningSide;
  final DisputeResolutionPersonDto? winner;
  final DisputeResolutionPersonDto? loser;
  final DisputeRatingImpactDto? ratingImpact;

  factory DisputeResolutionDto.fromMap(Map<String, dynamic> map) {
    final winnerRaw = map['winner'];
    final loserRaw = map['loser'];
    final ratingRaw = map['ratingImpact'];

    return DisputeResolutionDto(
      winningSide: (map['winningSide'] ?? '').toString(),
      winner: winnerRaw is Map
          ? DisputeResolutionPersonDto.fromMap(
              winnerRaw.cast<String, dynamic>(),
            )
          : null,
      loser: loserRaw is Map
          ? DisputeResolutionPersonDto.fromMap(loserRaw.cast<String, dynamic>())
          : null,
      ratingImpact: ratingRaw is Map
          ? DisputeRatingImpactDto.fromMap(ratingRaw.cast<String, dynamic>())
          : null,
    );
  }
}

class DisputeDetailsDto {
  const DisputeDetailsDto({
    required this.id,
    required this.displayId,
    required this.gameId,
    required this.status,
    required this.sport,
    required this.subject,
    required this.locationLabel,
    required this.description,
    required this.createdAt,
    required this.resolvedAt,
    required this.rewardKarma,
    required this.player1,
    required this.player2,
    required this.plaintiff,
    required this.defendant,
    required this.evidence,
    required this.voteSummary,
    required this.hasVoted,
    required this.myVote,
    required this.canVote,
    required this.resolution,
  });

  final String id;
  final String displayId;
  final String gameId;
  final String status;
  final String sport;
  final String subject;
  final String locationLabel;
  final String description;
  final DateTime? createdAt;
  final DateTime? resolvedAt;
  final int rewardKarma;
  final DisputePlayerSideDto player1;
  final DisputePlayerSideDto player2;
  final DisputeParticipantDto plaintiff;
  final DisputeParticipantDto defendant;
  final List<DisputeEvidenceDto> evidence;
  final DisputeVoteSummaryDto voteSummary;
  final bool hasVoted;
  final String? myVote;
  final bool canVote;
  final DisputeResolutionDto? resolution;

  factory DisputeDetailsDto.fromMap(Map<String, dynamic> map) {
    final rawPlayers = ((map['players'] as Map?) ?? const {})
        .cast<String, dynamic>();
    final player1Raw = ((rawPlayers['player1'] as Map?) ?? const {})
        .cast<String, dynamic>();
    final player2Raw = ((rawPlayers['player2'] as Map?) ?? const {})
        .cast<String, dynamic>();

    final rawEvidence = map['evidence'];
    final evidence = <DisputeEvidenceDto>[];
    if (rawEvidence is List) {
      for (final item in rawEvidence) {
        if (item is Map) {
          evidence.add(
            DisputeEvidenceDto.fromMap(item.cast<String, dynamic>()),
          );
        }
      }
    }

    final rawResolution = map['resolution'];

    return DisputeDetailsDto(
      id: (map['id'] ?? '').toString(),
      displayId: (map['displayId'] ?? '').toString(),
      gameId: (map['gameId'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      sport: (map['sport'] ?? '').toString(),
      subject: (map['subject'] ?? '').toString(),
      locationLabel: (map['locationLabel'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()),
      resolvedAt: DateTime.tryParse((map['resolvedAt'] ?? '').toString()),
      rewardKarma: (map['rewardKarma'] is num)
          ? (map['rewardKarma'] as num).toInt()
          : 0,
      player1: DisputePlayerSideDto.fromMap(player1Raw),
      player2: DisputePlayerSideDto.fromMap(player2Raw),
      plaintiff: DisputeParticipantDto.fromMap(
        ((map['plaintiff'] as Map?) ?? const {}).cast<String, dynamic>(),
      ),
      defendant: DisputeParticipantDto.fromMap(
        ((map['defendant'] as Map?) ?? const {}).cast<String, dynamic>(),
      ),
      evidence: evidence,
      voteSummary: DisputeVoteSummaryDto.fromMap(
        ((map['voteSummary'] as Map?) ?? const {}).cast<String, dynamic>(),
      ),
      hasVoted: map['hasVoted'] == true,
      myVote: map['myVote']?.toString(),
      canVote: map['canVote'] == true,
      resolution: rawResolution is Map
          ? DisputeResolutionDto.fromMap(rawResolution.cast<String, dynamic>())
          : null,
    );
  }
}

class CreateDisputeResponse {
  const CreateDisputeResponse({
    required this.success,
    required this.disputeId,
    required this.status,
    required this.dispute,
  });

  final bool success;
  final String disputeId;
  final String status;
  final DisputeDetailsDto? dispute;

  factory CreateDisputeResponse.fromMap(Map<String, dynamic> map) {
    final rawDispute = map['dispute'];
    return CreateDisputeResponse(
      success: map['success'] == true,
      disputeId: (map['disputeId'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      dispute: rawDispute is Map
          ? DisputeDetailsDto.fromMap(rawDispute.cast<String, dynamic>())
          : null,
    );
  }
}

class DisputeVoteResponse {
  const DisputeVoteResponse({
    required this.success,
    required this.voteCount,
    required this.requiredVotes,
    required this.resolved,
    required this.winningSide,
    required this.myKarmaAward,
    required this.dispute,
  });

  final bool success;
  final int voteCount;
  final int requiredVotes;
  final bool resolved;
  final String? winningSide;
  final int myKarmaAward;
  final DisputeDetailsDto? dispute;

  factory DisputeVoteResponse.fromMap(Map<String, dynamic> map) {
    final rawDispute = map['dispute'];
    return DisputeVoteResponse(
      success: map['success'] == true,
      voteCount: (map['voteCount'] is num)
          ? (map['voteCount'] as num).toInt()
          : 0,
      requiredVotes: (map['requiredVotes'] is num)
          ? (map['requiredVotes'] as num).toInt()
          : 3,
      resolved: map['resolved'] == true,
      winningSide: map['winningSide']?.toString(),
      myKarmaAward: (map['myKarmaAward'] is num)
          ? (map['myKarmaAward'] as num).toInt()
          : 0,
      dispute: rawDispute is Map
          ? DisputeDetailsDto.fromMap(rawDispute.cast<String, dynamic>())
          : null,
    );
  }
}

class DisputeEvidenceUploadDto {
  const DisputeEvidenceUploadDto({
    required this.url,
    required this.type,
    required this.thumbnailUrl,
    required this.durationLabel,
  });

  final String url;
  final String type;
  final String? thumbnailUrl;
  final String? durationLabel;

  factory DisputeEvidenceUploadDto.fromMap(Map<String, dynamic> map) {
    return DisputeEvidenceUploadDto(
      url: (map['url'] ?? '').toString(),
      type: (map['type'] ?? 'VIDEO').toString(),
      thumbnailUrl: map['thumbnailUrl']?.toString(),
      durationLabel: map['durationLabel']?.toString(),
    );
  }
}

class DisputesApi {
  static Future<CreateDisputeResponse> createDispute({
    required String gameId,
    required String comment,
    String? evidenceUrl,
    String? subject,
    String? sport,
    String? locationLabel,
    String? plaintiffStatement,
    String? defendantStatement,
    List<DisputeEvidenceInput> evidenceItems = const [],
  }) async {
    final payload = {
      'gameId': gameId,
      'comment': comment,
      if (evidenceUrl != null && evidenceUrl.isNotEmpty)
        'evidenceUrl': evidenceUrl,
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      if (sport != null && sport.isNotEmpty) 'sport': sport,
      if (locationLabel != null && locationLabel.isNotEmpty)
        'locationLabel': locationLabel,
      if (plaintiffStatement != null && plaintiffStatement.isNotEmpty)
        'plaintiffStatement': plaintiffStatement,
      if (defendantStatement != null && defendantStatement.isNotEmpty)
        'defendantStatement': defendantStatement,
      if (evidenceItems.isNotEmpty)
        'evidenceItems': evidenceItems.map((e) => e.toMap()).toList(),
    };

    final runtime = MockDemoRuntime.instance;
    if (runtime.hasLocalGame(gameId) || gameId.startsWith('demo-game-')) {
      final local = runtime.createDispute(
        gameId: gameId,
        comment: comment,
        evidenceUrl: evidenceUrl,
        subject: subject,
        sport: sport,
        locationLabel: locationLabel,
        plaintiffStatement: plaintiffStatement,
        defendantStatement: defendantStatement,
        evidenceItems: evidenceItems.map((e) => e.toMap()).toList(),
      );
      return CreateDisputeResponse.fromMap(local);
    }

    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.disputesCreate,
        data: payload,
      );
      return CreateDisputeResponse.fromMap(
        (data as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      final local = runtime.createDispute(
        gameId: gameId,
        comment: comment,
        evidenceUrl: evidenceUrl,
        subject: subject,
        sport: sport,
        locationLabel: locationLabel,
        plaintiffStatement: plaintiffStatement,
        defendantStatement: defendantStatement,
        evidenceItems: evidenceItems.map((e) => e.toMap()).toList(),
      );
      return CreateDisputeResponse.fromMap(local);
    }
  }

  static Future<DisputeEvidenceUploadDto?> uploadEvidenceFile(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      });

      final data = await ApiClient.instance.post(
        ApiEndpoints.disputesEvidenceUpload,
        data: formData,
      );

      if (data is! Map) return null;
      return DisputeEvidenceUploadDto.fromMap((data).cast<String, dynamic>());
    } catch (_) {
      final data = MockDemoRuntime.instance.mockEvidenceUpload(file.path);
      return DisputeEvidenceUploadDto.fromMap(data);
    }
  }

  static Future<List<DisputeDetailsDto>> getJuryDuty() async {
    final me = MockDemoRuntime.instance.currentUser();
    final userId = (me['id'] ?? '').toString();
    final local = MockDemoRuntime.instance
        .juryDuty(userId)
        .map(DisputeDetailsDto.fromMap)
        .toList();

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.disputesJuryDuty);
      if (data is! List) return local;

      final remote = data
          .whereType<Map>()
          .map(
            (item) => DisputeDetailsDto.fromMap(item.cast<String, dynamic>()),
          )
          .toList();

      return _mergeDisputes(remote, local);
    } catch (_) {
      return local;
    }
  }

  static Future<List<DisputeDetailsDto>> getMyDisputes() async {
    final me = MockDemoRuntime.instance.currentUser();
    final userId = (me['id'] ?? '').toString();
    final local = MockDemoRuntime.instance
        .myDisputes(userId)
        .map(DisputeDetailsDto.fromMap)
        .toList();

    try {
      final data = await ApiClient.instance.get(ApiEndpoints.disputesMy);
      if (data is! List) return local;

      final remote = data
          .whereType<Map>()
          .map(
            (item) => DisputeDetailsDto.fromMap(item.cast<String, dynamic>()),
          )
          .toList();

      return _mergeDisputes(remote, local);
    } catch (_) {
      return local;
    }
  }

  static Future<DisputeDetailsDto> getById(String disputeId) async {
    final runtime = MockDemoRuntime.instance;
    final me = runtime.currentUser();
    final userId = (me['id'] ?? '').toString();

    if (runtime.hasLocalDispute(disputeId)) {
      return DisputeDetailsDto.fromMap(runtime.disputeById(disputeId, userId));
    }

    try {
      final data = await ApiClient.instance.get(
        ApiEndpoints.disputesById(disputeId),
      );
      return DisputeDetailsDto.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      return DisputeDetailsDto.fromMap(runtime.disputeById(disputeId, userId));
    }
  }

  static Future<DisputeVoteResponse> vote({
    required String disputeId,
    required String winner,
  }) async {
    final runtime = MockDemoRuntime.instance;
    if (runtime.hasLocalDispute(disputeId)) {
      final data = runtime.vote(disputeId: disputeId, winner: winner);
      return DisputeVoteResponse.fromMap(data);
    }

    try {
      final data = await ApiClient.instance.post(
        ApiEndpoints.disputesVote(disputeId),
        data: {'winner': winner},
      );

      return DisputeVoteResponse.fromMap((data as Map).cast<String, dynamic>());
    } catch (_) {
      final data = runtime.vote(disputeId: disputeId, winner: winner);
      return DisputeVoteResponse.fromMap(data);
    }
  }

  static List<DisputeDetailsDto> _mergeDisputes(
    List<DisputeDetailsDto> remote,
    List<DisputeDetailsDto> local,
  ) {
    final byId = <String, DisputeDetailsDto>{};
    for (final item in remote) {
      byId[item.id] = item;
    }
    for (final item in local) {
      byId[item.id] = item;
    }

    final merged = byId.values.toList()
      ..sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
    return merged;
  }
}
