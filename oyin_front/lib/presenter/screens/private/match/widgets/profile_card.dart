import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../domain/entities/private/models/match_profile.dart';
import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';
import 'components.dart';

class MatchProfileCard extends StatelessWidget {
  const MatchProfileCard({
    super.key,
    required this.profile,
    required this.l10n,
  });

  final MatchProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 2 / 3.2,
            child: Ink.image(
              // Placeholder remote image; replace with CDN/asset when backend ready.
              image: NetworkImage(profile.imageUrl),
              fit: BoxFit.cover,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                MatchBadge(
                  icon: Icons.near_me,
                  text: l10n.formatDistanceKm(profile.distanceKm),
                  palette: palette,
                ),
                const Spacer(),
                MatchBadge(
                  icon: Icons.star_rounded,
                  text: l10n.formatRating(profile.rating),
                  palette: palette,
                  iconColor: Colors.amber,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.nameAndAge(profile.name, profile.age),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                    ),
                    if (profile.verified) ...[
                      8.hSpacing,
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF5AA9FF),
                        size: 20,
                      ),
                    ],
                  ],
                ),
                6.vSpacing,
                Text(
                  l10n.sportAndLevel(profile.sport, profile.level),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.muted,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                12.vSpacing,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: palette.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: CircleIconButton(
              icon: Icons.info_outline,
              palette: palette,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
