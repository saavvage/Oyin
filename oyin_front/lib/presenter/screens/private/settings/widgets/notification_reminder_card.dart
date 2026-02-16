import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';

class NotificationReminderCard extends StatelessWidget {
  const NotificationReminderCard({
    super.key,
    required this.l10n,
    required this.enabled,
    required this.intervalMinutes,
    required this.onToggle,
    required this.onSelectInterval,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final int intervalMinutes;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onSelectInterval;

  static const List<int> _intervalOptionsMinutes = <int>[
    15,
    30,
    60,
    180,
    360,
    720,
    1440,
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    4.vSpacing,
                    Text(
                      _subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    ),
                  ],
                ),
              ),
              Switch(value: enabled, onChanged: onToggle),
            ],
          ),
          if (enabled) ...[
            12.vSpacing,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _intervalOptionsMinutes
                  .map(
                    (minutes) => ChoiceChip(
                      label: Text(_intervalLabel(minutes)),
                      selected: intervalMinutes == minutes,
                      onSelected: (_) => onSelectInterval(minutes),
                    ),
                  )
                  .toList(),
            ),
            10.vSpacing,
            Text(
              '$_selectedLabel: ${_intervalLabel(intervalMinutes)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.muted),
            ),
          ],
        ],
      ),
    );
  }

  String get _title {
    switch (l10n.locale.languageCode) {
      case 'ru':
        return 'Напоминания';
      case 'kk':
        return 'Еске салғыштар';
      default:
        return 'Timed Reminders';
    }
  }

  String get _subtitle {
    switch (l10n.locale.languageCode) {
      case 'ru':
        return 'Локальные уведомления будут приходить по выбранному интервалу.';
      case 'kk':
        return 'Жергілікті хабарламалар таңдалған аралықпен келеді.';
      default:
        return 'Local notifications will arrive at the selected interval.';
    }
  }

  String get _selectedLabel {
    switch (l10n.locale.languageCode) {
      case 'ru':
        return 'Сейчас';
      case 'kk':
        return 'Қазір';
      default:
        return 'Current';
    }
  }

  String _intervalLabel(int minutes) {
    if (minutes < 60) {
      switch (l10n.locale.languageCode) {
        case 'ru':
          return '$minutes мин';
        case 'kk':
          return '$minutes мин';
        default:
          return '$minutes min';
      }
    }

    if (minutes % 1440 == 0) {
      final days = minutes ~/ 1440;
      switch (l10n.locale.languageCode) {
        case 'ru':
          return '$days д';
        case 'kk':
          return '$days к';
        default:
          return '$days d';
      }
    }

    final hours = minutes ~/ 60;
    switch (l10n.locale.languageCode) {
      case 'ru':
        return '$hours ч';
      case 'kk':
        return '$hours с';
      default:
        return '$hours h';
    }
  }
}
