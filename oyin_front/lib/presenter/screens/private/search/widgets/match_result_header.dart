import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class MatchResultHeader extends StatelessWidget {
  const MatchResultHeader({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'OYIN',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      letterSpacing: 1,
                      color: palette.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                l10n.matchResult,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: palette.muted),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}
