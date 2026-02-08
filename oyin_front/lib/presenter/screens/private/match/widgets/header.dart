import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import 'components.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({
    super.key,
    required this.l10n,
    this.onFilters,
  });

  final AppLocalizations l10n;
  final VoidCallback? onFilters;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: palette.card,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        12.hSpacing,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.discovery.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.5,
                    color: palette.muted,
                  ),
            ),
            Text(
              l10n.findPartners,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
        const Spacer(),
        CircleIconButton(
          icon: Icons.tune_rounded,
          palette: palette,
          onTap: onFilters,
        ),
      ],
    );
  }
}
