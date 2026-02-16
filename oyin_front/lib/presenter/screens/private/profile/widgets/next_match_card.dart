import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import '../../../../widgets/_export.dart';
import '../cubit/profile_state.dart';

class NextMatchCard extends StatelessWidget {
  const NextMatchCard({super.key, required this.l10n, required this.match});

  final AppLocalizations l10n;
  final NextMatch match;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.nextMatch.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: palette.muted,
              ),
            ),
            Text(
              l10n.viewCalendar,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        12.vSpacing,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(match.opponentAvatar),
                    radius: 22,
                  ),
                  12.hSpacing,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.opponent.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        match.opponentName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.statusConfirmed,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              14.vSpacing,
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  8.hSpacing,
                  Text(
                    match.dateLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              8.vSpacing,
              Row(
                children: [
                  const Icon(Icons.place, size: 18),
                  8.hSpacing,
                  Text(
                    match.locationLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                  ),
                ],
              ),
              12.vSpacing,
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showFrostedInfoModal(
                      context,
                      title: '${l10n.nextMatch}: ${match.opponentName}',
                      subtitle: '${match.dateLabel} • ${match.locationLabel}',
                      tips: const [
                        'Проверьте место и время встречи заранее.',
                        'Если планы изменились, предупредите соперника в чате.',
                        'После матча не забудьте отправить итоговый результат.',
                      ],
                    );
                  },
                  child: Text(
                    l10n.details,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
