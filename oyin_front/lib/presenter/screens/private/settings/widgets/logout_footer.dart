import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../domain/export.dart';
import '../../../../extensions/_export.dart';
import '../../../guest/auth_entry/auth_entry_screen.dart';

class SettingsLogoutFooter extends StatelessWidget {
  const SettingsLogoutFooter({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        InkWell(
          onTap: () {
            MockUserRepository.instance.clear();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
              (route) => false,
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.red),
                8.hSpacing,
                Text(
                  l10n.logout,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        10.vSpacing,
        Text(
          l10n.madeWithCare,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
      ],
    );
  }
}
