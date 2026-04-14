import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../messanger/messanger_screen.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => MatchCubit(), child: const _MatchView());
  }
}

class _MatchView extends StatefulWidget {
  const _MatchView();

  @override
  State<_MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<_MatchView> {
  final SwipeController _swipeController = SwipeController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<MatchCubit, MatchState>(
          builder: (context, state) {
            final profile = state.currentProfile;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MatchHeader(
                        l10n: l10n,
                        onFilters: () => _openFilters(context, state.filters),
                      ),
                      20.vSpacing,
                      MatchModeSwitch(
                        l10n: l10n,
                        nearbySelected: state.nearbySelected,
                        timeMatchSelected: state.timeMatchSelected,
                        onNearby: () =>
                            context.read<MatchCubit>().selectNearby(),
                        onTimeMatch: () =>
                            context.read<MatchCubit>().selectTimeMatch(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            (!state.isLoading &&
                                !state.isFinished &&
                                profile != null)
                            ? 0
                            : 20,
                      ),
                      child: Center(
                        child: _buildBody(context, state: state, l10n: l10n),
                      ),
                    ),
                  ),
                ),
                if (state.mutualLikeMatch != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _MutualLikeCard(
                      l10n: l10n,
                      match: state.mutualLikeMatch!,
                      onDismiss: () =>
                          context.read<MatchCubit>().clearMutualLikeMatch(),
                      onOpenChat: () =>
                          _openMatchChat(context, state.mutualLikeMatch!),
                    ),
                  ),
                if (!state.isLoading && !state.isFinished && profile != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: MatchActionsRow(
                      l10n: l10n,
                      onDislike: () => _swipeController.swipeLeft(),
                      onBoost: () => _swipeController.swipeRight(),
                      onLike: () => _swipeController.swipeRight(),
                      onInfo: () => _showMatchTips(context, l10n),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMatchTips(BuildContext context, AppLocalizations l10n) {
    showFrostedInfoModal(
      context,
      title: l10n.info,
      subtitle: l10n.infoMatchSubtitle,
      tips: [l10n.infoMatchTip1, l10n.infoMatchTip2, l10n.infoMatchTip3],
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required MatchState state,
    required AppLocalizations l10n,
  }) {
    if (state.isLoading) {
      return PulsePreloader(imageUrl: state.currentUserAvatarUrl);
    }

    if (state.isFinished) {
      return MatchFinishState(
        l10n: l10n,
        onResetDislikes: () => context.read<MatchCubit>().resetDislikes(),
        onOpenFilters: () => _openFilters(context, state.filters),
      );
    }

    final profile = state.currentProfile;
    if (profile == null) {
      return MatchFinishState(
        l10n: l10n,
        onResetDislikes: () => context.read<MatchCubit>().resetDislikes(),
        onOpenFilters: () => _openFilters(context, state.filters),
      );
    }

    return SwipeableMatchCard(
      key: ValueKey(profile.id),
      controller: _swipeController,
      profile: profile,
      l10n: l10n,
      onLike: () => context.read<MatchCubit>().likeCurrent(),
      onDislike: () => context.read<MatchCubit>().dislikeCurrent(),
      onOpenDetails: () => _openProfileDetails(context, profile),
    );
  }

  Future<void> _openFilters(BuildContext context, MatchFilters filters) async {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final result = await showModalBottomSheet<MatchFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _MatchFiltersSheet(l10n: l10n, filters: filters),
    );

    if (!context.mounted) return;
    if (result != null) {
      context.read<MatchCubit>().updateFilters(result);
    }
  }

  Future<void> _openProfileDetails(
    BuildContext context,
    MatchProfile profile,
  ) async {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.matchProfileDetailsTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: palette.muted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                12.vSpacing,
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    profile.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                16.vSpacing,
                Text(
                  l10n.nameAndAge(profile.name, profile.age),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                6.vSpacing,
                if (profile.city != null && profile.city!.isNotEmpty)
                  Text(
                    '${l10n.matchProfileCityLabel}: ${profile.city}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                  ),
                12.vSpacing,
                _InfoRow(
                  label: l10n.matchProfileDistanceLabel,
                  value: l10n.formatDistanceKm(profile.distanceKm),
                ),
                _InfoRow(
                  label: l10n.matchProfileRatingLabel,
                  value: l10n.formatRating(profile.rating),
                ),
                _InfoRow(
                  label: l10n.matchProfileSportsLabel,
                  value: profile.sports.isNotEmpty
                      ? l10n.sportNames(profile.sports).join(', ')
                      : l10n.sportName(profile.sport),
                ),
                _InfoRow(
                  label: l10n.matchProfileLevelLabel,
                  value: l10n.levelName(profile.level),
                ),
                if (profile.tags.isNotEmpty) ...[
                  16.vSpacing,
                  Text(
                    l10n.skills,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  8.vSpacing,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: palette.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(l10n.skillTag(tag)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _openMatchChat(BuildContext context, MutualLikeMatch match) {
    context.read<MatchCubit>().clearMutualLikeMatch();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MessangerScreen(
          chatId: match.threadId,
          partnerName: match.partnerName,
          partnerAvatarUrl: match.partnerAvatarUrl,
        ),
      ),
    );
  }
}

class _MutualLikeCard extends StatelessWidget {
  const _MutualLikeCard({
    required this.l10n,
    required this.match,
    required this.onOpenChat,
    required this.onDismiss,
  });

  final AppLocalizations l10n;
  final MutualLikeMatch match;
  final VoidCallback onOpenChat;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: palette.accent,
            backgroundImage: match.partnerAvatarUrl.isNotEmpty
                ? NetworkImage(match.partnerAvatarUrl)
                : null,
            child: match.partnerAvatarUrl.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.statusMatched} • ${match.partnerName}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                4.vSpacing,
                Text(
                  l10n.draftingContract,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          8.hSpacing,
          ElevatedButton(
            onPressed: onOpenChat,
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: Text(
              l10n.chats,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _MatchFiltersSheet extends StatefulWidget {
  const _MatchFiltersSheet({required this.l10n, required this.filters});

  final AppLocalizations l10n;
  final MatchFilters filters;

  @override
  State<_MatchFiltersSheet> createState() => _MatchFiltersSheetState();
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MatchFiltersSheetState extends State<_MatchFiltersSheet> {
  late RangeValues _distanceRange;
  late RangeValues _ageRange;

  @override
  void initState() {
    super.initState();
    _distanceRange = RangeValues(
      widget.filters.distanceKmMin,
      widget.filters.distanceKmMax,
    );
    _ageRange = RangeValues(
      widget.filters.ageMin.toDouble(),
      widget.filters.ageMax.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.l10n.matchFiltersTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: palette.muted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            12.vSpacing,
            MatchFiltersForm(
              l10n: widget.l10n,
              distanceRange: _distanceRange,
              ageRange: _ageRange,
              onDistanceChanged: (values) =>
                  setState(() => _distanceRange = values),
              onAgeChanged: (values) => setState(() => _ageRange = values),
              showApply: true,
              onApply: () {
                Navigator.of(context).pop(
                  MatchFilters(
                    distanceKmMin: _distanceRange.start.roundToDouble(),
                    distanceKmMax: _distanceRange.end.roundToDouble(),
                    ageMin: _ageRange.start.round(),
                    ageMax: _ageRange.end.round(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
