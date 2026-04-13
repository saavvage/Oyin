import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';

class SettingsUserTile extends StatelessWidget {
  const SettingsUserTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.tag,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String tag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: palette.accent,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            12.hSpacing,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    4.vSpacing,
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    ),
                  ],
                ],
              ),
            ),
            if (tag.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.blue),
                ),
              ),
            ],
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
