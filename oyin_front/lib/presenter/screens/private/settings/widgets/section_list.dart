import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/localization/locale_keys.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import '../cubit/settings_state.dart';

class SettingsSectionList extends StatelessWidget {
  const SettingsSectionList({
    super.key,
    required this.l10n,
    required this.sections,
    required this.publicVisibility,
    required this.matchRequests,
    required this.disputeUpdates,
    required this.onTogglePublicVisibility,
    required this.onToggleMatchRequests,
    required this.onToggleDisputeUpdates,
    required this.onLocaleSelected,
    required this.selectedLocale,
  });

  final AppLocalizations l10n;
  final List<SettingsSection> sections;
  final bool publicVisibility;
  final bool matchRequests;
  final bool disputeUpdates;
  final ValueChanged<bool> onTogglePublicVisibility;
  final ValueChanged<bool> onToggleMatchRequests;
  final ValueChanged<bool> onToggleDisputeUpdates;
  final ValueChanged<String> onLocaleSelected;
  final String selectedLocale;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: sections
          .map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _translateSectionTitle(l10n, section.title).toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: palette.muted,
                        ),
                  ),
                  8.vSpacing,
                  ...section.items.map(
                    (item) {
                      if (item.icon == 'language_selector') {
                        return _LanguageTile(
                          l10n: l10n,
                          selectedLocale: selectedLocale,
                          onSelected: onLocaleSelected,
                        );
                      }
                      return _SettingsTile(
                        l10n: l10n,
                        item: item,
                        publicVisibility: publicVisibility,
                        matchRequests: matchRequests,
                        disputeUpdates: disputeUpdates,
                        onTogglePublicVisibility: onTogglePublicVisibility,
                        onToggleMatchRequests: onToggleMatchRequests,
                        onToggleDisputeUpdates: onToggleDisputeUpdates,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.l10n,
    required this.item,
    required this.publicVisibility,
    required this.matchRequests,
    required this.disputeUpdates,
    required this.onTogglePublicVisibility,
    required this.onToggleMatchRequests,
    required this.onToggleDisputeUpdates,
  });

  final AppLocalizations l10n;
  final SettingsItem item;
  final bool publicVisibility;
  final bool matchRequests;
  final bool disputeUpdates;
  final ValueChanged<bool> onTogglePublicVisibility;
  final ValueChanged<bool> onToggleMatchRequests;
  final ValueChanged<bool> onToggleDisputeUpdates;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final icon = _iconFor(item.icon);

    Widget trailing = const Icon(Icons.chevron_right);
    if (item.toggleKey != null) {
      final value = _toggleValue(item.toggleKey!, publicVisibility, matchRequests, disputeUpdates);
      trailing = Switch(
        value: value,
        onChanged: (val) => _handleToggle(item.toggleKey!, val),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
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
            child: Icon(icon, color: Colors.blueAccent),
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translateTitle(l10n, item.title),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (item.subtitle.isNotEmpty) ...[
                  4.vSpacing,
                  Text(
                    _translateSubtitle(l10n, item.subtitle),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  bool _toggleValue(String key, bool publicVisibility, bool matchRequests, bool disputeUpdates) {
    switch (key) {
      case 'public_visibility':
        return publicVisibility;
      case 'match_requests':
        return matchRequests;
      case 'dispute_updates':
        return disputeUpdates;
      default:
        return false;
    }
  }

  void _handleToggle(String key, bool value) {
    switch (key) {
      case 'public_visibility':
        onTogglePublicVisibility(value);
        break;
      case 'match_requests':
        onToggleMatchRequests(value);
        break;
      case 'dispute_updates':
        onToggleDisputeUpdates(value);
        break;
    }
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.l10n,
    required this.selectedLocale,
    required this.onSelected,
  });

  final AppLocalizations l10n;
  final String selectedLocale;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          10.vSpacing,
          Row(
            children: [
              _LangChip(
                label: 'ENG',
                emoji: '🇬🇧',
                selected: selectedLocale == 'en',
                onTap: () => onSelected('en'),
              ),
              8.hSpacing,
              _LangChip(
                label: 'РУС',
                emoji: '🇷🇺',
                selected: selectedLocale == 'ru',
                onTap: () => onSelected('ru'),
              ),
              8.hSpacing,
              _LangChip(
                label: 'ҚАЗ',
                emoji: '🇰🇿',
                selected: selectedLocale == 'kk',
                onTap: () => onSelected('kk'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bg = selected ? palette.primary.withOpacity(0.18) : palette.accent;
    final color = selected ? palette.primary : palette.muted;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? palette.primary : palette.accent),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            6.hSpacing,
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconFor(String key) {
  switch (key) {
    case 'person':
      return Icons.person;
    case 'lock':
      return Icons.lock;
    case 'link':
      return Icons.link;
    case 'visibility':
      return Icons.public;
    case 'shield':
      return Icons.shield_outlined;
    case 'block':
      return Icons.block;
    case 'bell':
      return Icons.notifications;
    case 'hammer':
      return Icons.gavel;
    case 'help':
      return Icons.help_outline;
    case 'rules':
      return Icons.rule;
    default:
      return Icons.settings;
  }
}

String _translateSectionTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case LocaleKeys.account:
      return l10n.account;
    case LocaleKeys.sparringPrivacy:
      return l10n.sparringPrivacy;
    case LocaleKeys.notifications:
      return l10n.notifications;
    case LocaleKeys.support:
      return l10n.support;
    case LocaleKeys.language:
      return l10n.language;
    default:
      return key;
  }
}

String _translateTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case LocaleKeys.personalInfo:
      return l10n.personalInfo;
    case LocaleKeys.passwordSecurity:
      return l10n.passwordSecurity;
    case LocaleKeys.linkedAccounts:
      return l10n.linkedAccounts;
    case LocaleKeys.publicVisibility:
      return l10n.publicVisibility;
    case LocaleKeys.sparringPreferences:
      return l10n.sparringPreferences;
    case LocaleKeys.blockedUsers:
      return l10n.blockedUsers;
    case LocaleKeys.matchRequests:
      return l10n.matchRequests;
    case LocaleKeys.disputeUpdates:
      return l10n.disputeUpdates;
    case LocaleKeys.helpCenter:
      return l10n.helpCenter;
    case LocaleKeys.fairPlayRules:
      return l10n.fairPlayRules;
    default:
      return key;
  }
}

String _translateSubtitle(AppLocalizations l10n, String key) {
  switch (key) {
    case LocaleKeys.publicVisibilityDesc:
      return l10n.publicVisibilityDesc;
    default:
      return key;
  }
}
