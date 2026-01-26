import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import 'components.dart';

class MatchActionsRow extends StatelessWidget {
  const MatchActionsRow({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MatchActionButton(
          icon: Icons.close_rounded,
          label: l10n.actionPass,
          background: palette.surface,
          iconColor: palette.danger,
        ),
        MatchActionButton(
          icon: Icons.flash_on_rounded,
          label: l10n.actionBoost,
          background: palette.surface,
          iconColor: Colors.blueAccent,
        ),
        MatchActionButton(
          icon: Icons.sports_mma_rounded,
          label: l10n.actionLike,
          background: palette.primary,
          iconColor: Colors.black,
          shadowColor: palette.primary.withOpacity(0.35),
          size: 74,
        ),
        MatchActionButton(
          icon: Icons.info_outline,
          label: l10n.actionInfo,
          background: palette.surface,
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
