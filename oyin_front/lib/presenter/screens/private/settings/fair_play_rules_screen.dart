import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';

class FairPlayRulesScreen extends StatelessWidget {
  const FairPlayRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    final rules = [
      l10n.fairPlayRule1,
      l10n.fairPlayRule2,
      l10n.fairPlayRule3,
      l10n.fairPlayRule4,
      l10n.fairPlayRule5,
    ];

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  8.hSpacing,
                  Expanded(
                    child: Text(
                      l10n.fairPlayRules,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      l10n.settingsFairPlaySubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                  ),
                  12.vSpacing,
                  ...List.generate(rules.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: palette.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: palette.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          10.hSpacing,
                          Expanded(
                            child: Text(
                              rules[index],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: palette.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      l10n.fairPlayPenaltyNote,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    ),
                  ),
                  16.vSpacing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
