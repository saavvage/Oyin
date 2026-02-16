import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/localization/locale_keys.dart';
import '../../../../extensions/_export.dart';
import '../cubit/profile_state.dart';

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({
    super.key,
    required this.l10n,
    required this.items,
    this.onItemTap,
  });

  final AppLocalizations l10n;
  final List<ProfileSettingItem> items;
  final ValueChanged<ProfileSettingItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsHistory.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: palette.muted,
          ),
        ),
        12.vSpacing,
        ...items.map(
          (item) => _SettingTile(
            item: item,
            l10n: l10n,
            onTap: onItemTap == null ? null : () => onItemTap!(item),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.item, required this.l10n, this.onTap});

  final ProfileSettingItem item;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconData = _iconFor(item.icon);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: palette.primary),
            ),
            12.hSpacing,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _translateTitle(l10n, item.title),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.vSpacing,
                  Text(
                    _translateSubtitle(l10n, item.subtitle),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

IconData _iconFor(String key) {
  switch (key) {
    case 'availability':
      return Icons.access_time_filled;
    case 'sports':
      return Icons.sports_mma_rounded;
    case 'history':
      return Icons.history;
    default:
      return Icons.settings;
  }
}

String _translateTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case LocaleKeys.availability:
      return l10n.availability;
    case LocaleKeys.sportPreferences:
      return l10n.sportPreferences;
    case LocaleKeys.matchHistory:
      return l10n.matchHistory;
    default:
      return key;
  }
}

String _translateSubtitle(AppLocalizations l10n, String key) {
  switch (key) {
    case LocaleKeys.availabilityDesc:
      return l10n.availabilityDesc;
    case LocaleKeys.sportPreferencesDesc:
      return l10n.sportPreferencesDesc;
    case LocaleKeys.matchHistoryDesc:
      return l10n.matchHistoryDesc;
    default:
      return key;
  }
}
