import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class SubmitBlock extends StatelessWidget {
  const SubmitBlock({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Text(
          l10n.scoreConfirmNote,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        16.vSpacing,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 8,
              shadowColor: palette.primary.withOpacity(0.35),
            ),
            onPressed: () {},
            child: Text(
              l10n.submitResult,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
