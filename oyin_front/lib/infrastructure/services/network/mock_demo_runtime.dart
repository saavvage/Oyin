class MockDemoRuntime {
  MockDemoRuntime._() {
    _seed();
  }

  static final MockDemoRuntime instance = MockDemoRuntime._();

  final String currentUserId = 'mock-me';
  final Map<String, dynamic> _currentUser = {
    'id': 'mock-me',
    'name': 'You',
    'email': '',
    'city': 'Almaty',
    'avatarUrl': '',
    'reliabilityScore': 88,
    'phoneVerified': true,
    'emailVerified': true,
    'sportProfiles': [
      {
        'sportType': 'TENNIS',
        'level': 'AMATEUR',
        'eloRating': 1420,
        'skills': ['Footwork', 'Serve consistency'],
        'experienceYears': 3,
      },
    ],
  };

  final Map<String, _MockProfile> _profilesById = {};
  final Set<String> _mutualLikeProfileIds = {'test-match-1', 'test-match-2'};
  final Set<String> _likedProfileIds = {};
  final Set<String> _dislikedProfileIds = {};

  final Map<String, _MockThread> _threadsById = {};
  final Map<String, List<_MockMessage>> _messagesByThreadId = {};
  final Map<String, _MockGame> _gamesById = {};
  final Map<String, _MockDispute> _disputesById = {};

  int _sequence = 100;

  Map<String, dynamic> currentUser() {
    return Map<String, dynamic>.from(_currentUser);
  }

  void syncCurrentUserFromAccount(Map<String, dynamic> account) {
    final incomingName = (account['name'] ?? '').toString().trim();
    final incomingAvatar = (account['avatarUrl'] ?? '').toString().trim();
    final incomingEmail = (account['email'] ?? '').toString().trim();
    final incomingCity = (account['city'] ?? '').toString().trim();
    final incomingId = (account['id'] ?? '').toString().trim();
    final incomingReliability = account['reliabilityScore'];
    final incomingProfiles = account['sportProfiles'];

    if (incomingName.isNotEmpty && incomingName.toLowerCase() != 'new user') {
      _currentUser['name'] = incomingName;
    }
    if (incomingAvatar.isNotEmpty) {
      _currentUser['avatarUrl'] = incomingAvatar;
    }
    if (incomingEmail.isNotEmpty) {
      _currentUser['email'] = incomingEmail;
    }
    if (incomingCity.isNotEmpty) {
      _currentUser['city'] = incomingCity;
    }
    if (incomingId.isNotEmpty) {
      _currentUser['id'] = incomingId;
    }
    if (incomingReliability is num) {
      _currentUser['reliabilityScore'] = incomingReliability.toInt();
    }
    if (incomingProfiles is List && incomingProfiles.isNotEmpty) {
      _currentUser['sportProfiles'] = incomingProfiles;
    }
    if (account['phoneVerified'] is bool) {
      _currentUser['phoneVerified'] = account['phoneVerified'];
    }
    if (account['emailVerified'] is bool) {
      _currentUser['emailVerified'] = account['emailVerified'];
    }

    _applyCurrentUserIdentity();
  }

  bool hasLocalGame(String gameId) => _gamesById.containsKey(gameId);

  bool hasLocalDispute(String disputeId) =>
      _disputesById.containsKey(disputeId);

  bool isLocalThread(String threadId) => _threadsById.containsKey(threadId);

  List<Map<String, dynamic>> matchFeed({
    required double distanceMin,
    required double distanceMax,
    required int ageMin,
    required int ageMax,
    String? sport,
  }) {
    final normalizedSport = sport?.trim().toUpperCase();

    return _profilesById.values
        .where((profile) {
          if (_likedProfileIds.contains(profile.id)) return false;
          if (_dislikedProfileIds.contains(profile.id)) return false;
          if (profile.distanceKm < distanceMin ||
              profile.distanceKm > distanceMax) {
            return false;
          }
          if (profile.age < ageMin || profile.age > ageMax) {
            return false;
          }
          if (normalizedSport != null && normalizedSport.isNotEmpty) {
            if (profile.sport != normalizedSport &&
                !profile.sports.contains(normalizedSport)) {
              return false;
            }
          }
          return true;
        })
        .map((profile) => profile.toMap())
        .toList();
  }

  Map<String, dynamic> swipe({
    required String targetId,
    required String action,
  }) {
    final normalizedAction = action.toUpperCase();

    if (normalizedAction == 'DISLIKE') {
      _dislikedProfileIds.add(targetId);
      return const {'success': true, 'isMatch': false};
    }

    _likedProfileIds.add(targetId);

    if (!_mutualLikeProfileIds.contains(targetId)) {
      return const {'success': true, 'isMatch': false};
    }

    final matchPayload = _ensureMatchForProfile(targetId);
    return {
      'success': true,
      'isMatch': true,
      'threadId': matchPayload.threadId,
      'gameId': matchPayload.gameId,
    };
  }

  void resetDislikes() {
    _dislikedProfileIds.clear();
  }

  Map<String, List<Map<String, dynamic>>> chatThreads() {
    final actionRequired = <Map<String, dynamic>>[];
    final upcoming = <Map<String, dynamic>>[];

    final sorted = _threadsById.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    for (final thread in sorted) {
      final map = thread.toMap();
      if (thread.isBlocked) {
        continue;
      }
      if (thread.bucket == 'actionRequired') {
        actionRequired.add(map);
      } else {
        upcoming.add(map);
      }
    }

    return {'actionRequired': actionRequired, 'upcoming': upcoming};
  }

  List<Map<String, dynamic>> blockedThreads() {
    return _threadsById.values
        .where((thread) => thread.isBlocked)
        .map((thread) => thread.toMap())
        .toList();
  }

  List<Map<String, dynamic>> threadMessages(
    String threadId, {
    DateTime? before,
  }) {
    final messages = List<_MockMessage>.from(
      _messagesByThreadId[threadId] ?? const <_MockMessage>[],
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final filtered = before == null
        ? messages
        : messages.where((item) => item.createdAt.isBefore(before)).toList();

    return filtered.take(20).map((item) => item.toMap(currentUserId)).toList();
  }

  Map<String, dynamic> sendMessage(
    String threadId, {
    String? text,
    List<Map<String, dynamic>> attachments = const [],
  }) {
    final thread = _threadsById.putIfAbsent(
      threadId,
      () => _MockThread(
        id: threadId,
        bucket: 'upcoming',
        statusKey: 'status_matched',
        subtitle: '',
        partnerName: 'New opponent',
        partnerAvatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80',
      ),
    );

    final now = DateTime.now();
    final safeText = (text ?? '').trim();
    final message = _MockMessage(
      id: 'mock-msg-${++_sequence}',
      threadId: threadId,
      senderId: currentUserId,
      text: safeText,
      createdAt: now,
      attachments: attachments
          .map(
            (item) => _MockAttachment(
              type: (item['type'] ?? 'file').toString(),
              name: (item['name'] ?? 'Attachment').toString(),
              path: (item['path'] ?? '').toString(),
            ),
          )
          .toList(),
    );

    final threadMessages = _messagesByThreadId.putIfAbsent(threadId, () => []);
    threadMessages.add(message);

    final preview = safeText.isNotEmpty
        ? safeText
        : (message.attachments.isEmpty ? '...' : 'Attachment sent');

    thread
      ..subtitle = preview
      ..badgeCount = 0
      ..updatedAt = now
      ..highlight = false;

    return message.toMap(currentUserId);
  }

  void deleteThread(String threadId) {
    _threadsById.remove(threadId);
    _messagesByThreadId.remove(threadId);
  }

  void setThreadBlocked(String threadId, bool blocked) {
    final thread = _threadsById[threadId];
    if (thread == null) return;
    thread.isBlocked = blocked;
    thread.updatedAt = DateTime.now();
  }

  List<Map<String, dynamic>> myGames(String userId) {
    final requestedUserId = userId.trim().isEmpty
        ? currentUserId
        : userId.trim();
    var effectiveUserId = requestedUserId;

    var games = _gamesById.values
        .where(
          (game) =>
              game.player1.id == requestedUserId ||
              game.player2.id == requestedUserId,
        )
        .toList();

    if (games.isEmpty && requestedUserId != currentUserId) {
      effectiveUserId = currentUserId;
      games = _gamesById.values
          .where(
            (game) =>
                game.player1.id == currentUserId ||
                game.player2.id == currentUserId,
          )
          .toList();
    }

    games.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return games.map((game) => game.toHistoryMap(effectiveUserId)).toList();
  }

  Map<String, dynamic> gameById(String gameId) {
    final game = _gamesById[gameId];
    if (game != null) {
      return game.toMap();
    }

    if (gameId.startsWith('demo-game-')) {
      final created = _ensureGameFromToken(gameId: gameId);
      return created.toMap();
    }

    throw StateError('Game not found in mock runtime');
  }

  Map<String, dynamic> proposeContract({
    required String gameId,
    required DateTime dateTime,
    required String location,
    bool reminder = true,
    String? venueId,
  }) {
    final game = _ensureGameFromToken(gameId: gameId);

    game
      ..contract = _MockContract(
        date: dateTime,
        location: location,
        reminder: reminder,
        venueId: venueId,
      )
      ..status = 'SCHEDULED';

    _ensureThreadForGame(
      game,
      statusKey: 'status_contract_signed',
      bucket: 'upcoming',
      subtitle: 'Contract confirmed at $location',
      accent: 'green',
      highlight: false,
      buttonKey: null,
    );

    return game.toMap();
  }

  Map<String, dynamic> submitResult({
    required String gameId,
    required int myScore,
    required int opponentScore,
  }) {
    final game = _ensureGameFromToken(gameId: gameId);

    final isCurrentPlayer1 = game.player1.id == currentUserId;
    final player1Score = isCurrentPlayer1 ? myScore : opponentScore;
    final player2Score = isCurrentPlayer1 ? opponentScore : myScore;
    final canonical = '$player1Score-$player2Score';

    game
      ..scorePlayer1 = canonical
      ..scorePlayer2 = canonical
      ..player1Submitted = true
      ..player2Submitted = true
      ..status = 'PLAYED'
      ..winnerId = player1Score == player2Score
          ? null
          : (player1Score > player2Score ? game.player1.id : game.player2.id);

    _ensureThreadForGame(
      game,
      statusKey: 'status_contract_signed',
      bucket: 'upcoming',
      subtitle: 'Result approved: $canonical',
      accent: 'green',
      highlight: false,
      buttonKey: null,
    );

    return {
      'success': true,
      'gameId': game.id,
      'status': game.status,
      'scoresMatch': true,
      'game': game.toMap(),
    };
  }

  void ensureDemoGame({
    required String gameId,
    required String challengerName,
    required String opponentName,
    required String opponentAvatarUrl,
  }) {
    if (_gamesById.containsKey(gameId)) return;

    final me = _mockMePerson(challengerName);
    final opponent = _MockPerson(
      id: 'mock-user-${++_sequence}',
      name: opponentName,
      avatarUrl: opponentAvatarUrl,
      reliabilityScore: 82,
    );

    _gamesById[gameId] = _MockGame(
      id: gameId,
      type: 'RANKED_CHALLENGE',
      status: 'PENDING',
      player1: me,
      player2: opponent,
      createdAt: DateTime.now(),
    );

    _ensureThreadForGame(
      _gamesById[gameId]!,
      statusKey: 'status_matched',
      bucket: 'upcoming',
      subtitle: "It's a match! Set your contract details.",
      accent: 'yellow',
      highlight: false,
      buttonKey: null,
    );
  }

  List<Map<String, dynamic>> myDisputes(String userId) {
    final requestedUserId = userId.trim().isEmpty
        ? currentUserId
        : userId.trim();
    final hasRequested = _disputesById.values.any(
      (dispute) => dispute.involves(requestedUserId),
    );
    final effectiveUserId = hasRequested ? requestedUserId : currentUserId;

    final list =
        _disputesById.values
            .where((dispute) => dispute.involves(effectiveUserId))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list
        .map((dispute) => dispute.toMap(viewerId: effectiveUserId))
        .toList();
  }

  List<Map<String, dynamic>> juryDuty(String userId) {
    final requestedUserId = userId.trim().isEmpty
        ? currentUserId
        : userId.trim();
    final hasRequested = _disputesById.values.any(
      (dispute) => dispute.involves(requestedUserId),
    );
    final effectiveUserId = hasRequested ? requestedUserId : currentUserId;

    final list =
        _disputesById.values
            .where(
              (dispute) =>
                  !dispute.involves(effectiveUserId) &&
                  (dispute.status == 'OPEN' || dispute.status == 'VOTING'),
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list
        .map((dispute) => dispute.toMap(viewerId: effectiveUserId))
        .toList();
  }

  Map<String, dynamic> disputeById(String disputeId, String userId) {
    final dispute = _disputesById[disputeId];
    if (dispute == null) {
      throw StateError('Dispute not found in mock runtime');
    }
    return dispute.toMap(viewerId: userId);
  }

  Map<String, dynamic> createDispute({
    required String gameId,
    required String comment,
    String? evidenceUrl,
    String? subject,
    String? sport,
    String? locationLabel,
    String? plaintiffStatement,
    String? defendantStatement,
    List<Map<String, dynamic>> evidenceItems = const [],
  }) {
    final game = _ensureGameFromToken(gameId: gameId);
    final id = 'mock-dispute-${++_sequence}';

    final evidence = <_MockEvidence>[];
    if (evidenceItems.isNotEmpty) {
      for (final item in evidenceItems) {
        evidence.add(
          _MockEvidence(
            id: 'mock-ev-${++_sequence}',
            type: (item['type'] ?? 'VIDEO').toString().toUpperCase(),
            url: (item['url'] ?? '').toString(),
            thumbnailUrl: item['thumbnailUrl']?.toString(),
            durationLabel: item['durationLabel']?.toString(),
          ),
        );
      }
    } else if (evidenceUrl != null && evidenceUrl.trim().isNotEmpty) {
      evidence.add(
        _MockEvidence(
          id: 'mock-ev-${++_sequence}',
          type: 'VIDEO',
          url: evidenceUrl,
          thumbnailUrl: evidenceUrl,
          durationLabel: '00:40',
        ),
      );
    }

    final dispute = _MockDispute(
      id: id,
      displayId: '${5000 + _sequence}',
      gameId: game.id,
      status: 'VOTING',
      sport: sport?.trim().isNotEmpty == true ? sport!.trim() : 'TENNIS',
      subject: subject?.trim().isNotEmpty == true
          ? subject!.trim()
          : 'Result dispute',
      locationLabel: locationLabel?.trim().isNotEmpty == true
          ? locationLabel!.trim()
          : (game.contract?.location ?? 'Training Arena'),
      description: comment.trim().isNotEmpty
          ? comment.trim()
          : 'Please review final score evidence.',
      createdAt: DateTime.now(),
      rewardKarma: 50,
      player1: game.player1,
      player2: game.player2,
      plaintiff: _MockParticipant(
        id: game.player1.id,
        name: game.player1.name,
        avatarUrl: game.player1.avatarUrl,
        statement: plaintiffStatement?.trim().isNotEmpty == true
            ? plaintiffStatement!.trim()
            : 'Submitted score is correct from my side.',
      ),
      defendant: _MockParticipant(
        id: game.player2.id,
        name: game.player2.name,
        avatarUrl: game.player2.avatarUrl,
        statement: defendantStatement?.trim().isNotEmpty == true
            ? defendantStatement!.trim()
            : 'I disagree with submitted score.',
      ),
      evidence: evidence,
      requiredVotes: 3,
      player1Votes: 1,
      player2Votes: 1,
      drawVotes: 0,
    );

    _disputesById[id] = dispute;

    game
      ..status = 'DISPUTED'
      ..disputeId = id;

    _ensureThreadForGame(
      game,
      statusKey: 'status_dispute_open',
      bucket: 'actionRequired',
      subtitle: 'Dispute opened. Community vote in progress.',
      accent: 'red',
      highlight: true,
      buttonKey: 'resolve',
    );

    return {
      'success': true,
      'disputeId': id,
      'status': game.status,
      'dispute': dispute.toMap(viewerId: currentUserId),
    };
  }

  Map<String, dynamic> vote({
    required String disputeId,
    required String winner,
  }) {
    final dispute = _disputesById[disputeId];
    if (dispute == null) {
      throw StateError('Dispute not found in mock runtime');
    }

    dispute.applyLocalVote(winner.toUpperCase(), viewerId: currentUserId);

    if (dispute.status == 'RESOLVED') {
      final game = _gamesById[dispute.gameId];
      if (game != null) {
        game
          ..status = 'PLAYED'
          ..disputeId = dispute.id;

        if (dispute.resolution?.winningSide == 'PLAYER1') {
          game.winnerId = game.player1.id;
        } else if (dispute.resolution?.winningSide == 'PLAYER2') {
          game.winnerId = game.player2.id;
        } else {
          game.winnerId = null;
        }
      }
    }

    return {
      'success': true,
      'voteCount': dispute.totalVotes,
      'requiredVotes': dispute.requiredVotes,
      'resolved': dispute.status == 'RESOLVED',
      'winningSide': dispute.resolution?.winningSide,
      'myKarmaAward': dispute.status == 'RESOLVED' ? 50 : 10,
      'dispute': dispute.toMap(viewerId: currentUserId),
    };
  }

  Map<String, dynamic> mockEvidenceUpload(String filePath) {
    final fileName = filePath.split('/').isNotEmpty
        ? filePath.split('/').last
        : 'evidence.mp4';
    final url =
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80';

    return {
      'url': url,
      'type': 'VIDEO',
      'thumbnailUrl': url,
      'durationLabel': '00:32',
      'name': fileName,
    };
  }

  _MatchPayload _ensureMatchForProfile(String profileId) {
    final profile =
        _profilesById[profileId] ??
        _MockProfile(
          id: profileId,
          name: 'New Opponent',
          age: 24,
          city: 'Almaty',
          distanceKm: 4.0,
          rating: 4.5,
          sport: 'TENNIS',
          sports: const ['TENNIS'],
          level: 'AMATEUR',
          tags: const ['Consistency'],
          imageUrl:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=1200&q=80',
          verified: true,
        );

    final threadId = 'mock-thread-$profileId';
    final gameId = 'demo-game-$profileId';

    if (!_gamesById.containsKey(gameId)) {
      _gamesById[gameId] = _MockGame(
        id: gameId,
        type: 'RANKED_CHALLENGE',
        status: 'PENDING',
        player1: _mockMePerson('You'),
        player2: _MockPerson(
          id: profile.id,
          name: profile.name,
          avatarUrl: profile.imageUrl,
          reliabilityScore: profile.verified ? 90 : 76,
        ),
        createdAt: DateTime.now(),
      );
    }

    _threadsById[threadId] = _MockThread(
      id: threadId,
      bucket: 'actionRequired',
      statusKey: 'status_drafting_contract',
      subtitle: 'Mutual like! Open chat and confirm contract details.',
      partnerName: profile.name,
      partnerAvatarUrl: profile.imageUrl,
      partnerUserId: profile.id,
      gameId: gameId,
      accent: 'yellow',
      badgeCount: 1,
      highlight: true,
      buttonKey: 'view',
      updatedAt: DateTime.now(),
    );

    final chat = _messagesByThreadId.putIfAbsent(threadId, () => []);
    if (chat.isEmpty) {
      chat.add(
        _MockMessage(
          id: 'mock-msg-${++_sequence}',
          threadId: threadId,
          senderId: profile.id,
          text: 'Great! Let\'s agree on date and location.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      );
      chat.add(
        _MockMessage(
          id: 'mock-msg-${++_sequence}',
          threadId: threadId,
          senderId: currentUserId,
          text: 'Perfect, opening contract now.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );
    }

    return _MatchPayload(threadId: threadId, gameId: gameId);
  }

  _MockGame _ensureGameFromToken({required String gameId}) {
    final existing = _gamesById[gameId];
    if (existing != null) {
      return existing;
    }

    String token = gameId;
    if (token.startsWith('demo-game-')) {
      token = token.substring('demo-game-'.length);
    }

    final profile = _profilesById[token];
    final opponent = profile == null
        ? _MockPerson(
            id: 'mock-user-${++_sequence}',
            name: 'Challenge Opponent',
            avatarUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
            reliabilityScore: 80,
          )
        : _MockPerson(
            id: profile.id,
            name: profile.name,
            avatarUrl: profile.imageUrl,
            reliabilityScore: profile.verified ? 90 : 76,
          );

    final game = _MockGame(
      id: gameId,
      type: 'RANKED_CHALLENGE',
      status: 'PENDING',
      player1: _mockMePerson('You'),
      player2: opponent,
      createdAt: DateTime.now(),
    );

    _gamesById[gameId] = game;
    return game;
  }

  _MockPerson _mockMePerson(String fallbackName) {
    final user = currentUser();
    return _MockPerson(
      id: currentUserId,
      name: (user['name'] ?? fallbackName).toString(),
      avatarUrl: (user['avatarUrl'] ?? '').toString(),
      reliabilityScore: (user['reliabilityScore'] is num)
          ? (user['reliabilityScore'] as num).toDouble()
          : 88,
    );
  }

  void _ensureThreadForGame(
    _MockGame game, {
    required String statusKey,
    required String bucket,
    required String subtitle,
    required String accent,
    required bool highlight,
    required String? buttonKey,
  }) {
    final existing = _threadsById.values.cast<_MockThread?>().firstWhere(
      (thread) => thread?.gameId == game.id,
      orElse: () => null,
    );

    final partner = game.player1.id == currentUserId
        ? game.player2
        : game.player1;

    if (existing != null) {
      existing
        ..statusKey = statusKey
        ..bucket = bucket
        ..subtitle = subtitle
        ..accent = accent
        ..highlight = highlight
        ..buttonKey = buttonKey
        ..badgeCount = (existing.badgeCount ?? 0) + 1
        ..updatedAt = DateTime.now();
      return;
    }

    final threadId = 'mock-thread-game-${game.id}';
    _threadsById[threadId] = _MockThread(
      id: threadId,
      bucket: bucket,
      statusKey: statusKey,
      subtitle: subtitle,
      partnerName: partner.name,
      partnerAvatarUrl: partner.avatarUrl,
      partnerUserId: partner.id,
      gameId: game.id,
      accent: accent,
      badgeCount: 1,
      highlight: highlight,
      buttonKey: buttonKey,
      updatedAt: DateTime.now(),
    );

    final chat = _messagesByThreadId.putIfAbsent(threadId, () => []);
    chat.add(
      _MockMessage(
        id: 'mock-msg-${++_sequence}',
        threadId: threadId,
        senderId: partner.id,
        text: subtitle,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _seed() {
    _seedProfiles();
    _seedGames();
    _seedDisputes();
    _seedThreads();
    _applyCurrentUserIdentity();
  }

  void _applyCurrentUserIdentity() {
    final meName = (_currentUser['name'] ?? '').toString().trim();
    final meAvatar = (_currentUser['avatarUrl'] ?? '').toString().trim();
    final meReliability = (_currentUser['reliabilityScore'] is num)
        ? (_currentUser['reliabilityScore'] as num).toDouble()
        : 88.0;

    for (final game in _gamesById.values) {
      if (game.player1.id == currentUserId) {
        if (meName.isNotEmpty) game.player1.name = meName;
        if (meAvatar.isNotEmpty) game.player1.avatarUrl = meAvatar;
        game.player1.reliabilityScore = meReliability;
      }
      if (game.player2.id == currentUserId) {
        if (meName.isNotEmpty) game.player2.name = meName;
        if (meAvatar.isNotEmpty) game.player2.avatarUrl = meAvatar;
        game.player2.reliabilityScore = meReliability;
      }
    }

    for (final dispute in _disputesById.values) {
      if (dispute.player1.id == currentUserId) {
        if (meName.isNotEmpty) dispute.player1.name = meName;
        if (meAvatar.isNotEmpty) dispute.player1.avatarUrl = meAvatar;
        dispute.player1.reliabilityScore = meReliability;
      }
      if (dispute.player2.id == currentUserId) {
        if (meName.isNotEmpty) dispute.player2.name = meName;
        if (meAvatar.isNotEmpty) dispute.player2.avatarUrl = meAvatar;
        dispute.player2.reliabilityScore = meReliability;
      }
      if (dispute.plaintiff.id == currentUserId) {
        if (meName.isNotEmpty) dispute.plaintiff.name = meName;
        if (meAvatar.isNotEmpty) dispute.plaintiff.avatarUrl = meAvatar;
      }
      if (dispute.defendant.id == currentUserId) {
        if (meName.isNotEmpty) dispute.defendant.name = meName;
        if (meAvatar.isNotEmpty) dispute.defendant.avatarUrl = meAvatar;
      }
    }
  }

  void _seedProfiles() {
    final profiles = [
      _MockProfile(
        id: 'test-match-1',
        name: 'Murat',
        age: 25,
        city: 'Almaty',
        distanceKm: 3.2,
        rating: 4.8,
        sport: 'BOXING',
        sports: const ['BOXING', 'MMA'],
        level: 'SEMI_PRO',
        tags: const ['Speed', 'Footwork'],
        imageUrl:
            'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=1200&q=80',
        verified: true,
      ),
      _MockProfile(
        id: 'test-match-2',
        name: 'Anya',
        age: 22,
        city: 'Astana',
        distanceKm: 5.6,
        rating: 4.5,
        sport: 'TENNIS',
        sports: const ['TENNIS'],
        level: 'AMATEUR',
        tags: const ['Serve', 'Agility'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
        verified: true,
      ),
      _MockProfile(
        id: 'test-match-3',
        name: 'Daniyar',
        age: 29,
        city: 'Shymkent',
        distanceKm: 12.4,
        rating: 4.7,
        sport: 'MUAY_THAI',
        sports: const ['MUAY_THAI', 'KICKBOXING'],
        level: 'PRO',
        tags: const ['Clinch', 'Power'],
        imageUrl:
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=1200&q=80',
        verified: false,
      ),
      _MockProfile(
        id: 'test-match-4',
        name: 'Aruzhan',
        age: 24,
        city: 'Karaganda',
        distanceKm: 7.1,
        rating: 4.4,
        sport: 'BASKETBALL',
        sports: const ['BASKETBALL'],
        level: 'SEMI_PRO',
        tags: const ['Defense', 'Stamina'],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
        verified: false,
      ),
      _MockProfile(
        id: 'test-match-5',
        name: 'Timur',
        age: 31,
        city: 'Aktobe',
        distanceKm: 18.9,
        rating: 4.9,
        sport: 'FOOTBALL',
        sports: const ['FOOTBALL'],
        level: 'PRO',
        tags: const ['Pace', 'Passing'],
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
        verified: true,
      ),
    ];

    for (final profile in profiles) {
      _profilesById[profile.id] = profile;
    }
  }

  void _seedGames() {
    final me = _mockMePerson('You');

    final rival1 = _MockPerson(
      id: 'mock-rival-1',
      name: 'Nurlan A.',
      avatarUrl: 'https://i.pravatar.cc/200?img=11',
      reliabilityScore: 85,
    );
    final rival2 = _MockPerson(
      id: 'mock-rival-2',
      name: 'Kamila D.',
      avatarUrl: 'https://i.pravatar.cc/200?img=32',
      reliabilityScore: 90,
    );
    final rival3 = _MockPerson(
      id: 'mock-rival-3',
      name: 'Ruslan M.',
      avatarUrl: 'https://i.pravatar.cc/200?img=18',
      reliabilityScore: 79,
    );
    final rival4 = _MockPerson(
      id: 'mock-rival-4',
      name: 'Aigerim S.',
      avatarUrl: 'https://i.pravatar.cc/200?img=25',
      reliabilityScore: 87,
    );

    _gamesById['mock-game-history-1'] = _MockGame(
      id: 'mock-game-history-1',
      type: 'RANKED_CHALLENGE',
      status: 'PLAYED',
      player1: me,
      player2: rival1,
      scorePlayer1: '3-1',
      scorePlayer2: '3-1',
      player1Submitted: true,
      player2Submitted: true,
      winnerId: me.id,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      contract: _MockContract(
        date: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
        location: 'Mega Tennis Court',
        reminder: true,
      ),
    );

    _gamesById['mock-game-history-2'] = _MockGame(
      id: 'mock-game-history-2',
      type: 'RANKED_CHALLENGE',
      status: 'PLAYED',
      player1: me,
      player2: rival2,
      scorePlayer1: '1-3',
      scorePlayer2: '1-3',
      player1Submitted: true,
      player2Submitted: true,
      winnerId: rival2.id,
      createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
      contract: _MockContract(
        date: DateTime.now().subtract(const Duration(days: 5, hours: 7)),
        location: 'Sparta Hall',
        reminder: true,
      ),
    );

    _gamesById['mock-game-history-3'] = _MockGame(
      id: 'mock-game-history-3',
      type: 'RANKED_CHALLENGE',
      status: 'PLAYED',
      player1: me,
      player2: rival3,
      scorePlayer1: '2-2',
      scorePlayer2: '2-2',
      player1Submitted: true,
      player2Submitted: true,
      winnerId: null,
      createdAt: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
      contract: _MockContract(
        date: DateTime.now().subtract(const Duration(days: 7, hours: 4)),
        location: 'Central Arena',
        reminder: false,
      ),
    );

    _gamesById['mock-game-dispute-1'] = _MockGame(
      id: 'mock-game-dispute-1',
      type: 'RANKED_CHALLENGE',
      status: 'DISPUTED',
      player1: me,
      player2: rival4,
      scorePlayer1: '2-1',
      scorePlayer2: '1-2',
      player1Submitted: true,
      player2Submitted: true,
      winnerId: null,
      disputeId: 'mock-dispute-my-1',
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      contract: _MockContract(
        date: DateTime.now().subtract(const Duration(hours: 23)),
        location: 'Falcon Club',
        reminder: true,
      ),
    );

    _gamesById['mock-game-upcoming-1'] = _MockGame(
      id: 'mock-game-upcoming-1',
      type: 'RANKED_CHALLENGE',
      status: 'SCHEDULED',
      player1: me,
      player2: rival1,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      contract: _MockContract(
        date: DateTime.now().add(const Duration(days: 1, hours: 2)),
        location: 'South Court',
        reminder: true,
      ),
    );
  }

  void _seedDisputes() {
    final game = _gamesById['mock-game-dispute-1'];
    if (game != null) {
      _disputesById['mock-dispute-my-1'] = _MockDispute(
        id: 'mock-dispute-my-1',
        displayId: '4901',
        gameId: game.id,
        status: 'VOTING',
        sport: 'TENNIS',
        subject: 'Disputed last set score',
        locationLabel: game.contract?.location ?? 'Falcon Club',
        description:
            'Players submitted different final score. Need community decision.',
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        rewardKarma: 50,
        player1: game.player1,
        player2: game.player2,
        plaintiff: _MockParticipant(
          id: game.player1.id,
          name: game.player1.name,
          avatarUrl: game.player1.avatarUrl,
          statement:
              'I won the final rally. Video from my side confirms the score.',
        ),
        defendant: _MockParticipant(
          id: game.player2.id,
          name: game.player2.name,
          avatarUrl: game.player2.avatarUrl,
          statement:
              'Final point was replayed due to interruption. Score should be 2:2.',
        ),
        evidence: const [
          _MockEvidence(
            id: 'mock-ev-my-1',
            type: 'VIDEO',
            url:
                'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1280&q=80',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1280&q=80',
            durationLabel: '01:14',
          ),
        ],
        requiredVotes: 3,
        player1Votes: 1,
        player2Votes: 1,
        drawVotes: 0,
      );
    }

    final juryPlayer1 = _MockPerson(
      id: 'mock-jury-player-1',
      name: 'Arman B.',
      avatarUrl: 'https://i.pravatar.cc/200?img=49',
      reliabilityScore: 86,
    );
    final juryPlayer2 = _MockPerson(
      id: 'mock-jury-player-2',
      name: 'Lina R.',
      avatarUrl: 'https://i.pravatar.cc/200?img=36',
      reliabilityScore: 81,
    );

    _disputesById['mock-dispute-jury-1'] = _MockDispute(
      id: 'mock-dispute-jury-1',
      displayId: '4920',
      gameId: 'mock-game-jury-1',
      status: 'VOTING',
      sport: 'BADMINTON',
      subject: 'Shuttle touched line in deciding rally',
      locationLabel: 'East Club Court 2',
      description: 'Please review two camera angles and pick fair winner.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      rewardKarma: 50,
      player1: juryPlayer1,
      player2: juryPlayer2,
      plaintiff: _MockParticipant(
        id: juryPlayer1.id,
        name: juryPlayer1.name,
        avatarUrl: juryPlayer1.avatarUrl,
        statement: 'Line was in, point should stay for me.',
      ),
      defendant: _MockParticipant(
        id: juryPlayer2.id,
        name: juryPlayer2.name,
        avatarUrl: juryPlayer2.avatarUrl,
        statement: 'Shuttle landed outside by a small margin.',
      ),
      evidence: const [
        _MockEvidence(
          id: 'mock-ev-jury-1',
          type: 'VIDEO',
          url:
              'https://images.unsplash.com/photo-1543351611-58f69d33b2f2?auto=format&fit=crop&w=1280&q=80',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1543351611-58f69d33b2f2?auto=format&fit=crop&w=1280&q=80',
          durationLabel: '00:29',
        ),
        _MockEvidence(
          id: 'mock-ev-jury-2',
          type: 'PHOTO',
          url:
              'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
          durationLabel: null,
        ),
      ],
      requiredVotes: 3,
      player1Votes: 0,
      player2Votes: 2,
      drawVotes: 0,
    );
  }

  void _seedThreads() {
    final upcomingGame = _gamesById['mock-game-upcoming-1'];
    if (upcomingGame != null) {
      _threadsById['mock-thread-upcoming-1'] = _MockThread(
        id: 'mock-thread-upcoming-1',
        bucket: 'upcoming',
        statusKey: 'status_contract_signed',
        subtitle: 'Contract is signed. Training tomorrow at South Court.',
        partnerName: upcomingGame.player2.name,
        partnerAvatarUrl: upcomingGame.player2.avatarUrl,
        partnerUserId: upcomingGame.player2.id,
        gameId: upcomingGame.id,
        accent: 'green',
        badgeCount: 1,
        highlight: false,
        buttonKey: null,
        updatedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      );

      _messagesByThreadId['mock-thread-upcoming-1'] = [
        _MockMessage(
          id: 'mock-msg-9001',
          threadId: 'mock-thread-upcoming-1',
          senderId: upcomingGame.player2.id,
          text: 'All set for tomorrow. I\'ll be there 10 min early.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ];
    }

    final disputedGame = _gamesById['mock-game-dispute-1'];
    if (disputedGame != null) {
      _threadsById['mock-thread-dispute-1'] = _MockThread(
        id: 'mock-thread-dispute-1',
        bucket: 'actionRequired',
        statusKey: 'status_dispute_open',
        subtitle: 'Dispute opened. Please review jury decision progress.',
        partnerName: disputedGame.player2.name,
        partnerAvatarUrl: disputedGame.player2.avatarUrl,
        partnerUserId: disputedGame.player2.id,
        gameId: disputedGame.id,
        accent: 'red',
        badgeCount: 1,
        highlight: true,
        buttonKey: 'resolve',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      _messagesByThreadId['mock-thread-dispute-1'] = [
        _MockMessage(
          id: 'mock-msg-9002',
          threadId: 'mock-thread-dispute-1',
          senderId: disputedGame.player2.id,
          text: 'I submitted dispute evidence. Let\'s wait for jury.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ];
    }
  }
}

class _MatchPayload {
  const _MatchPayload({required this.threadId, required this.gameId});

  final String threadId;
  final String gameId;
}

class _MockProfile {
  const _MockProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.distanceKm,
    required this.rating,
    required this.sport,
    required this.sports,
    required this.level,
    required this.tags,
    required this.imageUrl,
    required this.verified,
  });

  final String id;
  final String name;
  final int age;
  final String city;
  final double distanceKm;
  final double rating;
  final String sport;
  final List<String> sports;
  final String level;
  final List<String> tags;
  final String imageUrl;
  final bool verified;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'city': city,
      'distanceKm': distanceKm,
      'rating': rating,
      'sport': sport,
      'sports': sports,
      'level': level,
      'tags': tags,
      'imageUrl': imageUrl,
      'verified': verified,
    };
  }
}

class _MockPerson {
  _MockPerson({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.reliabilityScore,
  });

  final String id;
  String name;
  String avatarUrl;
  double reliabilityScore;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'avatarUrl': avatarUrl};
  }

  Map<String, dynamic> toDisputeMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'reliabilityScore': reliabilityScore,
    };
  }
}

class _MockParticipant {
  _MockParticipant({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.statement,
  });

  final String id;
  String name;
  String avatarUrl;
  final String statement;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'statement': statement,
    };
  }
}

class _MockEvidence {
  const _MockEvidence({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'durationLabel': durationLabel,
    };
  }
}

class _MockContract {
  const _MockContract({
    required this.date,
    required this.location,
    required this.reminder,
    this.venueId,
  });

  final DateTime date;
  final String location;
  final bool reminder;
  final String? venueId;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'venueId': venueId,
      'reminder': reminder,
      'location': location,
    };
  }
}

class _MockGame {
  _MockGame({
    required this.id,
    required this.type,
    required this.status,
    required this.player1,
    required this.player2,
    required this.createdAt,
    this.scorePlayer1,
    this.scorePlayer2,
    this.player1Submitted = false,
    this.player2Submitted = false,
    this.disputeId,
    this.contract,
    this.winnerId,
  });

  final String id;
  final String type;
  String status;
  final _MockPerson player1;
  final _MockPerson player2;
  String? scorePlayer1;
  String? scorePlayer2;
  bool player1Submitted;
  bool player2Submitted;
  String? disputeId;
  _MockContract? contract;
  String? winnerId;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'player1': player1.toMap(),
      'player2': player2.toMap(),
      'scorePlayer1': scorePlayer1,
      'scorePlayer2': scorePlayer2,
      'player1Submitted': player1Submitted,
      'player2Submitted': player2Submitted,
      'disputeId': disputeId,
      'contractData': contract?.toMap(),
      'location': contract?.location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toHistoryMap(String myUserId) {
    final map = toMap();
    map['result'] = _myResult(myUserId);
    return map;
  }

  String _myResult(String myUserId) {
    if (status != 'PLAYED') return 'pending';
    if (winnerId == null || winnerId!.isEmpty) return 'draw';
    return winnerId == myUserId ? 'win' : 'loss';
  }
}

class _MockThread {
  _MockThread({
    required this.id,
    required this.bucket,
    required this.statusKey,
    required this.subtitle,
    required this.partnerName,
    required this.partnerAvatarUrl,
    this.partnerUserId,
    this.gameId,
    this.badgeCount,
    this.accent,
    this.highlight,
    this.buttonKey,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final String id;
  String bucket;
  String statusKey;
  String subtitle;
  final String partnerName;
  final String partnerAvatarUrl;
  final String? partnerUserId;
  final String? gameId;
  int? badgeCount;
  String? accent;
  bool? highlight;
  String? buttonKey;
  bool isBlocked = false;
  DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': partnerName,
      'subtitle': subtitle,
      'avatarUrl': partnerAvatarUrl,
      'statusKey': statusKey,
      'timestamp': _formatTimestamp(updatedAt),
      'isBlocked': isBlocked,
      'badgeCount': badgeCount,
      'accent': accent,
      'highlight': highlight,
      'buttonKey': buttonKey,
      'bucket': bucket,
      'partnerUserId': partnerUserId,
      'gameId': gameId,
    };
  }

  String _formatTimestamp(DateTime value) {
    final now = DateTime.now();
    final local = value.toLocal();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfYesterday = startOfDay.subtract(const Duration(days: 1));

    if (local.isAfter(startOfDay)) {
      final hh = local.hour.toString().padLeft(2, '0');
      final mm = local.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }

    if (local.isAfter(startOfYesterday)) {
      return 'Yesterday';
    }

    final dd = local.day.toString().padLeft(2, '0');
    final mm = local.month.toString().padLeft(2, '0');
    return '$dd.$mm';
  }
}

class _MockAttachment {
  const _MockAttachment({
    required this.type,
    required this.name,
    required this.path,
  });

  final String type;
  final String name;
  final String path;

  Map<String, dynamic> toMap() {
    return {'type': type, 'name': name, 'path': path};
  }
}

class _MockMessage {
  const _MockMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.attachments = const [],
  });

  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final List<_MockAttachment> attachments;

  Map<String, dynamic> toMap(String currentUserId) {
    return {
      'id': id,
      'threadId': threadId,
      'senderId': senderId,
      'text': text,
      'isMine': senderId == currentUserId,
      'createdAt': createdAt.toIso8601String(),
      'attachments': attachments.map((item) => item.toMap()).toList(),
    };
  }
}

class _MockResolution {
  const _MockResolution({
    required this.winningSide,
    required this.winner,
    required this.loser,
    required this.player1Before,
    required this.player1After,
    required this.player2Before,
    required this.player2After,
  });

  final String winningSide;
  final _MockPerson? winner;
  final _MockPerson? loser;
  final int player1Before;
  final int player1After;
  final int player2Before;
  final int player2After;

  Map<String, dynamic> toMap() {
    return {
      'winningSide': winningSide,
      'winner': winner?.toMap(),
      'loser': loser?.toMap(),
      'ratingImpact': {
        'player1Before': player1Before,
        'player1After': player1After,
        'player2Before': player2Before,
        'player2After': player2After,
      },
    };
  }
}

class _MockDispute {
  _MockDispute({
    required this.id,
    required this.displayId,
    required this.gameId,
    required this.status,
    required this.sport,
    required this.subject,
    required this.locationLabel,
    required this.description,
    required this.createdAt,
    required this.rewardKarma,
    required this.player1,
    required this.player2,
    required this.plaintiff,
    required this.defendant,
    required this.evidence,
    required this.requiredVotes,
    required this.player1Votes,
    required this.player2Votes,
    required this.drawVotes,
  });

  final String id;
  final String displayId;
  final String gameId;
  String status;
  final String sport;
  final String subject;
  final String locationLabel;
  final String description;
  final DateTime createdAt;
  DateTime? resolvedAt;
  final int rewardKarma;
  final _MockPerson player1;
  final _MockPerson player2;
  final _MockParticipant plaintiff;
  final _MockParticipant defendant;
  final List<_MockEvidence> evidence;
  final int requiredVotes;
  int player1Votes;
  int player2Votes;
  int drawVotes;
  bool localUserHasVoted = false;
  String? localUserVote;
  _MockResolution? resolution;

  int get totalVotes => player1Votes + player2Votes + drawVotes;

  bool involves(String userId) {
    return plaintiff.id == userId || defendant.id == userId;
  }

  void applyLocalVote(String vote, {required String viewerId}) {
    if (involves(viewerId)) {
      return;
    }
    if (localUserHasVoted || status == 'RESOLVED') {
      return;
    }

    localUserHasVoted = true;
    localUserVote = vote;

    switch (vote) {
      case 'PLAYER1':
        player1Votes += 1;
        break;
      case 'PLAYER2':
        player2Votes += 1;
        break;
      case 'DRAW':
        drawVotes += 1;
        break;
      default:
        break;
    }

    final winnerSide = _winnerSideIfResolved();
    if (winnerSide == null) {
      status = 'VOTING';
      return;
    }

    status = 'RESOLVED';
    resolvedAt = DateTime.now();

    final winner = winnerSide == 'PLAYER1'
        ? player1
        : winnerSide == 'PLAYER2'
        ? player2
        : null;
    final loser = winnerSide == 'PLAYER1'
        ? player2
        : winnerSide == 'PLAYER2'
        ? player1
        : null;

    resolution = _MockResolution(
      winningSide: winnerSide,
      winner: winner,
      loser: loser,
      player1Before: 1410,
      player1After: winnerSide == 'PLAYER1' ? 1432 : 1398,
      player2Before: 1380,
      player2After: winnerSide == 'PLAYER2' ? 1401 : 1360,
    );
  }

  String? _winnerSideIfResolved() {
    if (player1Votes >= requiredVotes) return 'PLAYER1';
    if (player2Votes >= requiredVotes) return 'PLAYER2';
    if (drawVotes >= requiredVotes) return 'DRAW';
    return null;
  }

  Map<String, dynamic> toMap({required String viewerId}) {
    final canVote =
        !involves(viewerId) && status != 'RESOLVED' && !localUserHasVoted;

    return {
      'id': id,
      'displayId': displayId,
      'gameId': gameId,
      'status': status,
      'sport': sport,
      'subject': subject,
      'locationLabel': locationLabel,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'rewardKarma': rewardKarma,
      'players': {
        'player1': player1.toDisputeMap(),
        'player2': player2.toDisputeMap(),
      },
      'plaintiff': plaintiff.toMap(),
      'defendant': defendant.toMap(),
      'evidence': evidence.map((item) => item.toMap()).toList(),
      'voteSummary': {
        'total': totalVotes,
        'requiredToResolve': requiredVotes,
        'player1': player1Votes,
        'player2': player2Votes,
        'draw': drawVotes,
      },
      'hasVoted': localUserHasVoted,
      'myVote': localUserVote,
      'canVote': canVote,
      'resolution': resolution?.toMap(),
    };
  }
}
