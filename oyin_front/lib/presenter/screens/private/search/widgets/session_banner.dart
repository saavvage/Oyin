import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class SessionBanner extends StatelessWidget {
  const SessionBanner({
    super.key,
    required this.l10n,
    required this.title,
    required this.dateLabel,
    required this.locationLabel,
    required this.statusLabel,
  });

  final AppLocalizations l10n;
  final String title;
  final String dateLabel;
  final String locationLabel;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sports_mma_rounded),
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sparringSession,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                4.vSpacing,
                Text(
                  '$dateLabel · $locationLabel',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l10n.pending,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.orange, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
