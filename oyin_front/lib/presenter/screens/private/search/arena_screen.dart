import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../search/match_result_screen.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final topPlayers = _mockPlayers.take(3).toList();
    final inRange = _mockPlayers.skip(3).take(4).toList();

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(title: const Text('Arena')),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StandingCard(palette: palette),
              16.vSpacing,
              Row(
                children: [
                  _FilterChip(label: 'All Players', selected: true, palette: palette),
                  10.hSpacing,
                  _FilterChip(
                    label: 'Fair Fight (+/- 200)',
                    selected: false,
                    palette: palette,
                    icon: Icons.scale,
                  ),
                ],
              ),
              16.vSpacing,
              ...topPlayers.map((p) => _PlayerRow(player: p, palette: palette)),
              16.vSpacing,
              Text(
                'IN YOUR RANGE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.muted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              12.vSpacing,
              ...inRange.map((p) => _PlayerRow(player: p, palette: palette)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StandingCard extends StatelessWidget {
  const _StandingCard({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: palette.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR STANDING',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
                6.vSpacing,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '#42 ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'Rank',
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
                    const Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
                    6.hSpacing,
                    Text(
                      'Rating: 1,450',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
                'You',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
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
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, color: fg, size: 16), 6.hSpacing],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player, required this.palette});

  final _Player player;
  final AppPalette palette;

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
      decoration: BoxDecoration(color: palette.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Text(
            '#${player.rank}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: palette.muted, fontWeight: FontWeight.w700),
          ),
          12.hSpacing,
          CircleAvatar(backgroundImage: NetworkImage(player.avatar), radius: 20),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                4.vSpacing,
                Text(
                  'Rating: ${player.rating}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          if (player.delta != 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${player.delta > 0 ? '+' : ''}${player.delta}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: accentColor, fontWeight: FontWeight.w700),
              ),
            ),
            10.hSpacing,
          ],
          _ActionButton(
            label: player.pending ? 'Pending' : 'Challenge',
            highlighted: !player.pending,
            onPressed: () {
              if (!player.pending) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const MatchResultScreen()));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, this.highlighted = true, this.onPressed});

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
    required this.rank,
    required this.name,
    required this.rating,
    required this.avatar,
    this.delta = 0,
    this.pending = false,
  });

  final int rank;
  final String name;
  final int rating;
  final String avatar;
  final int delta;
  final bool pending;
}

const _mockPlayers = [
  _Player(rank: 1, name: 'Sarah Connor', rating: 2100, avatar: 'https://i.pravatar.cc/200?img=47'),
  _Player(rank: 2, name: 'Ivan Drago', rating: 2050, avatar: 'https://i.pravatar.cc/200?img=55'),
  _Player(rank: 3, name: 'Apollo Creed', rating: 1980, avatar: 'https://i.pravatar.cc/200?img=12'),
  _Player(
    rank: 40,
    name: 'Marcus F.',
    rating: 1475,
    avatar: 'https://i.pravatar.cc/200?img=61',
    delta: 25,
  ),
  _Player(
    rank: 41,
    name: 'Julia S.',
    rating: 1460,
    avatar: 'https://i.pravatar.cc/200?img=5',
    delta: 10,
    pending: true,
  ),
  _Player(
    rank: 43,
    name: 'Tom Hardy',
    rating: 1440,
    avatar: 'https://i.pravatar.cc/200?img=15',
    delta: -10,
  ),
  _Player(
    rank: 44,
    name: 'Alex Chen',
    rating: 1420,
    avatar: 'https://i.pravatar.cc/200?img=30',
    delta: -30,
  ),
];
