import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import 'components.dart';

class MatchModeSwitch extends StatelessWidget {
  const MatchModeSwitch({
    super.key,
    required this.l10n,
    required this.nearbySelected,
    required this.timeMatchSelected,
    required this.onNearby,
    required this.onTimeMatch,
  });

  final AppLocalizations l10n;
  final bool nearbySelected;
  final bool timeMatchSelected;
  final VoidCallback onNearby;
  final VoidCallback onTimeMatch;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Expanded(
          child: MatchPillButton(
            icon: Icons.place_rounded,
            label: l10n.nearby,
            selected: nearbySelected,
            palette: palette,
            onTap: onNearby,
          ),
        ),
        12.hSpacing,
        Expanded(
          child: MatchPillButton(
            icon: Icons.access_time_filled_rounded,
            label: l10n.timeMatch,
            selected: timeMatchSelected,
            palette: palette,
            onTap: onTimeMatch,
          ),
        ),
      ],
    );
  }
}
