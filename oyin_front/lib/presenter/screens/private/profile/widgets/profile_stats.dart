import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import '../cubit/profile_state.dart';

class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({
    super.key,
    required this.l10n,
    required this.stats,
  });

  final AppLocalizations l10n;
  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cards = [
      _StatCard(
        label: l10n.reputation,
        value: stats.reputation.toStringAsFixed(1),
        caption: l10n.reputationExcellent,
        icon: Icons.verified_user,
      ),
      _StatCard(
        label: l10n.record,
        value: stats.record,
        icon: Icons.emoji_events,
      ),
      _StatCard(
        label: l10n.matches,
        value: stats.matches.toString(),
        caption: l10n.matchesDeltaThisMonth(stats.matchesDeltaValue),
        icon: Icons.calendar_month,
      ),
      _StatCard(
        label: l10n.reliability,
        value: '${stats.reliability}%',
        icon: Icons.shield_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.performanceStats.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: palette.muted,
              ),
        ),
        12.vSpacing,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards
              .map(
                (card) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 20 * 2 - 12) / 2,
                  child: card,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.caption,
    required this.icon,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: palette.iconMuted),
              8.hSpacing,
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
              ),
            ],
          ),
          10.vSpacing,
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (caption != null) ...[
            4.vSpacing,
            Text(
              caption!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.primary),
            ),
          ],
        ],
      ),
    );
  }
}
