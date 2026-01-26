import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import '../cubit/match_result_state.dart';

class PlayerScoreCard extends StatelessWidget {
  const PlayerScoreCard({
    super.key,
    required this.player,
    required this.onTap,
  });

  final MatchResultPlayer player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: palette.accent,
              backgroundImage: NetworkImage(player.avatarUrl),
            ),
            if (player.isYou)
              Positioned(
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: palette.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'YOU',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
        12.vSpacing,
        Text(
          player.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        12.vSpacing,
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.iconMuted, width: 1.5),
            ),
            child: Center(
              child: Text(
                player.score?.toString() ?? '-',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
