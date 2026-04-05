import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../widgets/_export.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Oyin',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              l10n.myGames,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showFrostedInfoModal(
              context,
              title: l10n.myGames,
              subtitle: l10n.infoChatSubtitle,
              tips: [
                l10n.infoChatTip1,
                l10n.infoChatTip2,
                l10n.infoChatTip3,
              ],
            );
          },
          icon: const Icon(Icons.person_add_alt_1),
        ),
      ],
    );
  }
}
