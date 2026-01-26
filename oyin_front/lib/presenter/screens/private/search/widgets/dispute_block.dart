import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class DisputeBlock extends StatelessWidget {
  const DisputeBlock({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            8.hSpacing,
            Text(
              l10n.dispute,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1),
            ),
            8.hSpacing,
            const Expanded(child: Divider()),
          ],
        ),
        14.vSpacing,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(16),
            color: Colors.redAccent.withOpacity(0.08),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gavel, color: Colors.redAccent),
              10.hSpacing,
              Text(
                l10n.toCourt,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        12.vSpacing,
        Text(
          l10n.disputeNote,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
      ],
    );
  }
}
