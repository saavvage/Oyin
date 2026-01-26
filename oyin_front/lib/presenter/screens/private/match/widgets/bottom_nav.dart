import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class MatchBottomNav extends StatelessWidget {
  const MatchBottomNav({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final items = [
      _NavItem(icon: Icons.style, label: l10n.navMatch, active: true),
      _NavItem(icon: Icons.search, label: l10n.navSearch),
      _NavItem(icon: Icons.chat_bubble_outline, label: l10n.navChats),
      _NavItem(icon: Icons.person_outline, label: l10n.navProfile),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) => _BottomNavButton(item: item, palette: palette)).toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.palette,
  });

  final _NavItem item;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final color = item.active ? palette.primary : palette.muted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, color: color),
        6.vSpacing,
        Text(
          item.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
