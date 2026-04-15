import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/localization/locale_keys.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'contract_setup_screen.dart';
import 'match_result_screen.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key, this.isActive = false});

  final bool isActive;

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  bool _isLoading = true;
  bool _isChallenging = false;
  String _currentUserId = '';
  String _currentUserName = 'You';
  int _currentUserRating = 0;
  int? _currentUserRank;
  List<_Player> _players = const [];
  List<_MatchingContract> _matchingContracts = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ArenaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    String nextCurrentUserId = _currentUserId;
    String nextCurrentUserName = _currentUserName;
    int nextCurrentUserRating = _currentUserRating;
    int? nextCurrentUserRank = _currentUserRank;
    List<_Player> nextPlayers = _players;
    List<_MatchingContract> nextMatchingContracts = _matchingContracts;

    try {
      final results = await Future.wait<dynamic>([
        ArenaApi.getLeaderboard(sport: 'TENNIS'),
        UsersApi.getMe(),
        ChatApi.getThreads(),
      ]);

      final leaderboard = results[0] as List<ArenaPlayerDto>;
      final me = (results[1] as Map<String, dynamic>);
      final threads = results[2] as ChatThreadsResponse;

      final userId = (me['id'] ?? '').toString();
      final userName = (me['name'] ?? '').toString().trim();

      final mapped = leaderboard
          .map(
            (item) => _Player(
              userId: item.userId,
              rank: item.rank,
              name: item.name,
              rating: item.rating,
              avatar: item.avatar,
              reliabilityScore: item.reliabilityScore,
            ),
          )
          .toList();

      final rank = mapped.cast<_Player?>().firstWhere(
        (item) => item?.userId == userId,
        orElse: () => null,
      );

      nextCurrentUserId = userId;
      nextCurrentUserName = userName.isEmpty ? 'You' : userName;
      nextCurrentUserRating =
          (me['sportProfiles'] is List &&
              (me['sportProfiles'] as List).isNotEmpty)
          ? ((me['sportProfiles'] as List).first['eloRating'] as num?)
                    ?.toInt() ??
                0
          : 0;
      nextCurrentUserRank = rank?.rank;
      nextPlayers = mapped.isEmpty ? _mockPlayers : mapped;
      nextMatchingContracts = _extractMatchingContracts(threads);
    } catch (_) {
      nextCurrentUserId = 'me-local';
      nextCurrentUserName = 'You';
      nextCurrentUserRating = 1450;
      nextCurrentUserRank = 42;
      nextPlayers = _mockPlayers;

      try {
        final threads = await ChatApi.getThreads();
        nextMatchingContracts = _extractMatchingContracts(threads);
      } catch (_) {
        nextMatchingContracts = const [];
      }
    }

    if (!mounted) return;
    setState(() {
      _currentUserId = nextCurrentUserId;
      _currentUserName = nextCurrentUserName;
      _currentUserRating = nextCurrentUserRating;
      _currentUserRank = nextCurrentUserRank;
      _players = nextPlayers;
      _matchingContracts = nextMatchingContracts;
      _isLoading = false;
    });
  }

  List<_MatchingContract> _extractMatchingContracts(ChatThreadsResponse data) {
    final byGameId = <String, _MatchingContract>{};
    final allThreads = <ChatThreadDto>[
      ...data.actionRequired,
      ...data.upcoming,
    ];

    for (final item in allThreads) {
      final gameId = item.gameId?.trim() ?? '';
      if (gameId.isEmpty) {
        continue;
      }
      if (item.statusKey != LocaleKeys.statusDraftingContract &&
          item.statusKey != LocaleKeys.statusMatched) {
        continue;
      }

      byGameId[gameId] = _MatchingContract(
        gameId: gameId,
        partnerName: item.name.trim().isEmpty ? 'Opponent' : item.name.trim(),
        partnerAvatarUrl: item.avatarUrl,
        subtitle: item.subtitle,
        statusKey: item.statusKey,
      );
    }

    return byGameId.values.toList();
  }

  Future<void> _challenge(_Player player) async {
    if (_isChallenging) return;

    // Demo/seed opponents still follow the same contract -> result flow.
    if (player.userId.startsWith('seed-')) {
      await _openContractThenResult(
        gameId: 'demo-game-${player.userId}',
        player: player,
      );
      return;
    }

    setState(() => _isChallenging = true);
    try {
      final response = await ArenaApi.challenge(targetId: player.userId);
      if (!mounted) return;
      await _openContractThenResult(gameId: response.gameId, player: player);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isChallenging = false);
      }
    }
  }

  Future<void> _openContractThenResult({
    required String gameId,
    required _Player player,
  }) async {
    final confirmed = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => ContractSetupScreen(gameId: gameId)),
    );

    if (!mounted || confirmed != true) return;

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MatchResultScreen(
          gameId: gameId,
          challengerName: _currentUserName,
          opponentName: player.name,
          opponentAvatarUrl: player.avatar,
        ),
      ),
    );
  }

  Future<void> _openMatchingContract(_MatchingContract contract) async {
    final confirmed = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ContractSetupScreen(gameId: contract.gameId),
      ),
    );

    if (!mounted || confirmed != true) return;

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MatchResultScreen(
          gameId: contract.gameId,
          challengerName: _currentUserName,
          opponentName: contract.partnerName,
          opponentAvatarUrl: contract.partnerAvatarUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final topPlayers = _players.take(3).toList();
    final inRange = _players.skip(3).take(8).toList();
    final navOverlayInset = MediaQuery.of(context).viewPadding.bottom + 82;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.arenaTitle),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  navOverlayInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_matchingContracts.isNotEmpty) ...[
                      Text(
                        l10n.arenaMatching.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: palette.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      12.vSpacing,
                      ..._matchingContracts.map(
                        (contract) => _MatchingContractRow(
                          contract: contract,
                          palette: palette,
                          l10n: l10n,
                          onOpen: () => _openMatchingContract(contract),
                        ),
                      ),
                      16.vSpacing,
                    ],
                    _StandingCard(
                      palette: palette,
                      standingLabel: l10n.arenaStanding,
                      rankLabel: l10n.arenaRank,
                      rank: _currentUserRank,
                      ratingLabel: l10n.arenaRating(
                        _currentUserRating.toString(),
                      ),
                      userLabel: _currentUserName,
                    ),
                    16.vSpacing,
                    Row(
                      children: [
                        _FilterChip(
                          label: l10n.arenaAllPlayers,
                          selected: true,
                          palette: palette,
                        ),
                        10.hSpacing,
                        _FilterChip(
                          label: l10n.arenaFairFight,
                          selected: false,
                          palette: palette,
                          icon: Icons.scale,
                        ),
                      ],
                    ),
                    16.vSpacing,
                    ...topPlayers.map(
                      (p) => _PlayerRow(
                        player: p,
                        palette: palette,
                        challengeLabel: l10n.arenaChallenge,
                        pendingLabel: l10n.arenaPending,
                        disabled: _isChallenging || p.userId == _currentUserId,
                        onChallenge: () => _challenge(p),
                      ),
                    ),
                    16.vSpacing,
                    Text(
                      l10n.arenaInRange.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    12.vSpacing,
                    ...inRange.map(
                      (p) => _PlayerRow(
                        player: p,
                        palette: palette,
                        challengeLabel: l10n.arenaChallenge,
                        pendingLabel: l10n.arenaPending,
                        disabled: _isChallenging || p.userId == _currentUserId,
                        onChallenge: () => _challenge(p),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StandingCard extends StatelessWidget {
  const _StandingCard({
    required this.palette,
    required this.standingLabel,
    required this.rankLabel,
    required this.rank,
    required this.ratingLabel,
    required this.userLabel,
  });

  final AppPalette palette;
  final String standingLabel;
  final String rankLabel;
  final int? rank;
  final String ratingLabel;
  final String userLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  standingLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
                6.vSpacing,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '#${rank ?? '-'} ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: rankLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                6.vSpacing,
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                    6.hSpacing,
                    Text(
                      ratingLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          12.hSpacing,
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: palette.background,
              width: 110,
              height: 130,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8),
              child: Text(
                userLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.palette,
    this.icon,
  });

  final String label;
  final bool selected;
  final AppPalette palette;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.blue : palette.accent;
    final fg = selected ? Colors.white : palette.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, color: fg, size: 16), 6.hSpacing],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchingContractRow extends StatelessWidget {
  const _MatchingContractRow({
    required this.contract,
    required this.palette,
    required this.l10n,
    required this.onOpen,
  });

  final _MatchingContract contract;
  final AppPalette palette;
  final AppLocalizations l10n;
  final VoidCallback onOpen;

  String _statusText() {
    switch (contract.statusKey) {
      case LocaleKeys.statusDraftingContract:
        return l10n.statusDraftingContract;
      case LocaleKeys.statusMatched:
        return l10n.statusMatched;
      default:
        return l10n.statusMatched;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = contract.partnerAvatarUrl.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.badge),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: palette.accent,
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl.isEmpty
                ? Icon(Icons.person, color: palette.muted)
                : null,
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contract.partnerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                4.vSpacing,
                Text(
                  contract.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
                6.vSpacing,
                Text(
                  _statusText(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          8.hSpacing,
          _ActionButton(label: l10n.viewProposal, onPressed: onOpen),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.player,
    required this.palette,
    required this.challengeLabel,
    required this.pendingLabel,
    required this.onChallenge,
    required this.disabled,
  });

  final _Player player;
  final AppPalette palette;
  final String challengeLabel;
  final String pendingLabel;
  final VoidCallback onChallenge;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final accentColor = player.delta > 0
        ? Colors.greenAccent
        : player.delta < 0
        ? Colors.redAccent
        : palette.muted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            '#${player.rank}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: palette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          12.hSpacing,
          CircleAvatar(
            backgroundImage: player.avatar.isNotEmpty
                ? NetworkImage(player.avatar)
                : null,
            radius: 20,
            child: player.avatar.isEmpty && player.name.isNotEmpty
                ? Text(player.name[0])
                : null,
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.vSpacing,
                Text(
                  'Rating ${player.rating}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          10.hSpacing,
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 96, maxWidth: 142),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (player.delta != 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${player.delta > 0 ? '+' : ''}${player.delta}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  8.vSpacing,
                ],
                _ActionButton(
                  label: player.pending || disabled
                      ? pendingLabel
                      : challengeLabel,
                  highlighted: !player.pending && !disabled,
                  onPressed: player.pending || disabled ? null : onChallenge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchingContract {
  const _MatchingContract({
    required this.gameId,
    required this.partnerName,
    required this.partnerAvatarUrl,
    required this.subtitle,
    required this.statusKey,
  });

  final String gameId;
  final String partnerName;
  final String partnerAvatarUrl;
  final String subtitle;
  final String statusKey;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    this.highlighted = true,
    this.onPressed,
  });

  final String label;
  final bool highlighted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: highlighted ? Colors.blue : Colors.grey.shade800,
        foregroundColor: highlighted ? Colors.white : Colors.grey.shade300,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Player {
  const _Player({
    required this.userId,
    required this.rank,
    required this.name,
    required this.rating,
    required this.avatar,
    required this.reliabilityScore,
    this.delta = 0,
    this.pending = false,
  });

  final String userId;
  final int rank;
  final String name;
  final int rating;
  final String avatar;
  final double reliabilityScore;
  final int delta;
  final bool pending;
}

const _mockPlayers = [
  _Player(
    userId: 'seed-1',
    rank: 1,
    name: 'Sarah Connor',
    rating: 2100,
    avatar: 'https://i.pravatar.cc/200?img=47',
    reliabilityScore: 92,
  ),
  _Player(
    userId: 'seed-2',
    rank: 2,
    name: 'Ivan Drago',
    rating: 2050,
    avatar: 'https://i.pravatar.cc/200?img=55',
    reliabilityScore: 96,
  ),
  _Player(
    userId: 'seed-3',
    rank: 3,
    name: 'Apollo Creed',
    rating: 1980,
    avatar: 'https://i.pravatar.cc/200?img=12',
    reliabilityScore: 89,
  ),
  _Player(
    userId: 'seed-4',
    rank: 40,
    name: 'Marcus F.',
    rating: 1475,
    avatar: 'https://i.pravatar.cc/200?img=61',
    reliabilityScore: 84,
    delta: 25,
  ),
  _Player(
    userId: 'seed-5',
    rank: 41,
    name: 'Julia S.',
    rating: 1460,
    avatar: 'https://i.pravatar.cc/200?img=5',
    reliabilityScore: 78,
    delta: 10,
    pending: true,
  ),
  _Player(
    userId: 'seed-6',
    rank: 43,
    name: 'Tom Hardy',
    rating: 1440,
    avatar: 'https://i.pravatar.cc/200?img=15',
    reliabilityScore: 81,
    delta: -10,
  ),
  _Player(
    userId: 'seed-7',
    rank: 44,
    name: 'Alex Chen',
    rating: 1420,
    avatar: 'https://i.pravatar.cc/200?img=30',
    reliabilityScore: 88,
  ),
];
