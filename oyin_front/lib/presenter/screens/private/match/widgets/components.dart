import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class MatchPillButton extends StatelessWidget {
  const MatchPillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected ? palette.primary : palette.surface;
    final foreground = selected ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: palette.primary.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: foreground),
            8.hSpacing,
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchBadge extends StatelessWidget {
  const MatchBadge({
    super.key,
    required this.icon,
    required this.text,
    required this.palette,
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final AppPalette palette;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.badge.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.white),
          6.hSpacing,
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}

class MatchActionButton extends StatelessWidget {
  const MatchActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.iconColor,
    this.shadowColor,
    this.size = 64,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color iconColor;
  final Color? shadowColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            boxShadow: shadowColor == null
                ? null
                : [
                    BoxShadow(
                      color: shadowColor!,
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    )
                  ],
          ),
          child: Icon(icon, color: iconColor, size: size / 2),
        ),
        8.vSpacing,
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.palette,
    this.onTap,
  });

  final IconData icon;
  final AppPalette palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: palette.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
