import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';

class MatchFinishState extends StatelessWidget {
  const MatchFinishState({
    super.key,
    required this.l10n,
    required this.onResetDislikes,
    required this.onOpenFilters,
  });

  final AppLocalizations l10n;
  final VoidCallback onResetDislikes;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: palette.primary, size: 48),
        12.vSpacing,
        Text(
          l10n.matchFinishTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        8.vSpacing,
        Text(
          l10n.matchFinishSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        20.vSpacing,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onResetDislikes,
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.matchResetDislikes),
          ),
        ),
        12.vSpacing,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onOpenFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: palette.surface),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.matchTryChangeFilters),
          ),
        ),
      ],
    );
  }
}
