import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../settings/settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.l10n, this.onSettingsUpdated});

  final AppLocalizations l10n;
  final VoidCallback? onSettingsUpdated;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Text(
            l10n.profile,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          onPressed: () async {
            await Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            onSettingsUpdated?.call();
          },
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
    );
  }
}
