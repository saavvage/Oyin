import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../widgets/_export.dart';

class AiAssistantCard extends StatelessWidget {
  const AiAssistantCard({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.accent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.accent,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.aiAssistant,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    8.hSpacing,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.aiComingSoon,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                6.vSpacing,
                Text(
                  l10n.aiAssistantSubtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showFrostedInfoModal(
                context,
                title: l10n.aiAssistant,
                subtitle: 'Модуль готовится к запуску.',
                tips: const [
                  'Здесь будут рекомендации по подготовке к матчу и разборы споров.',
                  'На первом этапе доступны подсказки по доказательствам и fair-play.',
                ],
              );
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
