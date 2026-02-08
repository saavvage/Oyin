import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import 'components.dart';

class MatchActionsRow extends StatelessWidget {
  const MatchActionsRow({
    super.key,
    required this.l10n,
    required this.onDislike,
    required this.onLike,
    this.onBoost,
    this.onInfo,
  });

  final AppLocalizations l10n;
  final VoidCallback onDislike;
  final VoidCallback onLike;
  final VoidCallback? onBoost;
  final VoidCallback? onInfo;

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
          onTap: onDislike,
        ),
        MatchActionButton(
          icon: Icons.flash_on_rounded,
          label: l10n.actionBoost,
          background: palette.surface,
          iconColor: Colors.blueAccent,
          onTap: onBoost,
        ),
        MatchActionButton(
          icon: Icons.sports_mma_rounded,
          label: l10n.actionLike,
          background: palette.primary,
          iconColor: Colors.black,
          shadowColor: palette.primary.withOpacity(0.35),
          size: 74,
          onTap: onLike,
        ),
        MatchActionButton(
          icon: Icons.info_outline,
          label: l10n.actionInfo,
          background: palette.surface,
          iconColor: Colors.white,
          onTap: onInfo,
        ),
      ],
    );
  }
}
