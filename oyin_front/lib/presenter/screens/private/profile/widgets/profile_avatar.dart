import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    super.key,
    required this.name,
    required this.tagline,
    required this.location,
    required this.league,
    required this.avatarUrl,
    this.email = '',
  });

  final String name;
  final String tagline;
  final String location;
  final String league;
  final String avatarUrl;
  final String email;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.card,
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: palette.background,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.card,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 8,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.edit, size: 16),
              ),
            ),
          ],
        ),
        14.vSpacing,
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        10.vSpacing,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: palette.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            league,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: palette.primary, fontWeight: FontWeight.w700),
          ),
        ),
        8.vSpacing,
        Text(
          tagline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        if (email.isNotEmpty) ...[
          6.vSpacing,
          Text(
            email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ],
        8.vSpacing,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.place, size: 18),
            6.hSpacing,
            Text(
              location,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
          ],
        ),
      ],
    );
  }
}
