import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    final faq = [
      _FaqItem(question: l10n.helpFaqQ1, answer: l10n.helpFaqA1),
      _FaqItem(question: l10n.helpFaqQ2, answer: l10n.helpFaqA2),
      _FaqItem(question: l10n.helpFaqQ3, answer: l10n.helpFaqA3),
      _FaqItem(question: l10n.helpFaqQ4, answer: l10n.helpFaqA4),
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
                      l10n.helpCenter,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.helpContactTitle,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        8.vSpacing,
                        Text(
                          l10n.helpContactBody,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  14.vSpacing,
                  ...faq.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ExpansionTile(
                        collapsedIconColor: palette.muted,
                        iconColor: palette.primary,
                        title: Text(
                          item.question,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          14,
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.answer,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: palette.muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
