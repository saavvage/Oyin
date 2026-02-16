import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';

class DisputeBlock extends StatelessWidget {
  const DisputeBlock({
    super.key,
    required this.l10n,
    required this.enabled,
    this.isLoading = false,
    this.onTap,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            8.hSpacing,
            Text(
              l10n.dispute,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(letterSpacing: 1),
            ),
            8.hSpacing,
            const Expanded(child: Divider()),
          ],
        ),
        14.vSpacing,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled ? Colors.redAccent : palette.iconMuted,
            ),
            borderRadius: BorderRadius.circular(16),
            color: enabled
                ? Colors.redAccent.withValues(alpha: 0.08)
                : palette.accent.withValues(alpha: 0.45),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: enabled && !isLoading ? onTap : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.gavel,
                  color: enabled ? Colors.redAccent : palette.muted,
                ),
                10.hSpacing,
                Text(
                  l10n.toCourt,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: enabled ? Colors.redAccent : palette.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (isLoading) ...[
                  10.hSpacing,
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
          ),
        ),
        12.vSpacing,
        Text(
          enabled
              ? l10n.disputeNote
              : 'Кнопка станет активна, если результат оспорен (CONFLICT/DISPUTED).',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
      ],
    );
  }
}
