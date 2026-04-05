import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'match_result_screen.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait<dynamic>([
        ArenaApi.getLeaderboard(sport: 'TENNIS'),
        UsersApi.getMe(),
      ]);

      final leaderboard = results[0] as List<ArenaPlayerDto>;
      final me = (results[1] as Map<String, dynamic>);

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

      if (!mounted) return;
      setState(() {
        _currentUserId = userId;
        _currentUserName = userName.isEmpty ? 'You' : userName;
        _currentUserRating =
            (me['sportProfiles'] is List &&
                (me['sportProfiles'] as List).isNotEmpty)
            ? ((me['sportProfiles'] as List).first['eloRating'] as num?)
                      ?.toInt() ??
                  0
            : 0;
        _currentUserRank = rank?.rank;
        _players = mapped.isEmpty ? _mockPlayers : mapped;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _currentUserId = 'me-local';
        _currentUserName = 'You';
        _currentUserRating = 1450;
        _currentUserRank = 42;
        _players = _mockPlayers;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _challenge(_Player player) async {
    if (_isChallenging) return;

    // For demo/seed players, open MatchResultScreen directly without API call
    if (player.userId.startsWith('seed-')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MatchResultScreen(
            gameId: 'demo-game-${player.userId}',
            challengerName: _currentUserName,
            opponentName: player.name,
            opponentAvatarUrl: player.avatar,
          ),
        ),
      );
      return;
    }

    setState(() => _isChallenging = true);
    try {
      final response = await ArenaApi.challenge(targetId: player.userId);
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MatchResultScreen(
            gameId: response.gameId,
            challengerName: _currentUserName,
            opponentName: player.name,
            opponentAvatarUrl: player.avatar,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isChallenging = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final topPlayers = _players.take(3).toList();
    final inRange = _players.skip(3).take(8).toList();

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.vSpacing,
                Text(
                  'Rating: ${player.rating}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          if (player.delta != 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${player.delta > 0 ? '+' : ''}${player.delta}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            10.hSpacing,
          ],
          _ActionButton(
            label: player.pending || disabled ? pendingLabel : challengeLabel,
            highlighted: !player.pending && !disabled,
            onPressed: player.pending || disabled ? null : onChallenge,
          ),
        ],
      ),
    );
  }
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
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
