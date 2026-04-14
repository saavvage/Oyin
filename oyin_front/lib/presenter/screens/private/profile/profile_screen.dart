import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../../guest/login/phone_screen.dart';
import '../wallet/wallet_screen.dart';
import 'cubit/_export.dart';
import 'availability_screen.dart';
import 'match_history_screen.dart';
import '../search/match_result_screen.dart';
import 'sport_preferences_screen.dart';
import 'widgets/_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isActive = false});

  final bool isActive;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProfileCubit();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _cubit.refreshProfile();
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _cubit, child: const _ProfileView());
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    l10n: l10n,
                    onSettingsUpdated: () {
                      context.read<ProfileCubit>().refreshProfile();
                    },
                  ),
                  14.vSpacing,
                  ProfileAvatarSection(
                    name: state.name,
                    tagline: _localizedTagline(state, l10n),
                    email: state.email,
                    location: state.location,
                    league: _localizedLeague(state.league, l10n),
                    avatarUrl: state.avatarUrl,
                    onAvatarTap: () => _showAvatarActions(context),
                  ),
                  12.vSpacing,
                  _AccountVerificationCard(
                    shouldShow: !state.isAccountVerified,
                  ),
                  24.vSpacing,
                  ProfileStatsGrid(l10n: l10n, stats: state.stats),
                  16.vSpacing,
                  const WalletEntryButton(),
                  20.vSpacing,
                  NextMatchCard(
                    l10n: l10n,
                    match: state.nextMatch,
                    onOpenMatch: state.nextMatch == null
                        ? null
                        : () => _openNextMatchResult(context, state),
                  ),
                  20.vSpacing,
                  ProfileSettingsList(
                    l10n: l10n,
                    items: state.settingsItems,
                    onItemTap: (item) => _onSettingsTap(context, item, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showAvatarActions(BuildContext context) async {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: palette.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.profileAvatarChooseGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.profileAvatarTakePhoto),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (selected == null || !context.mounted) return;
    try {
      await context.read<ProfileCubit>().updateAvatar(selected);
    } catch (error) {
      if (!context.mounted) return;
      AppNotifier.showError(context, error);
    }
  }

  String _localizedTagline(ProfileState state, AppLocalizations l10n) {
    if (state.sportProfiles.isNotEmpty) {
      final labels = state.sportProfiles
          .map((profile) => l10n.sportName(profile.sportType))
          .where((label) => label.isNotEmpty)
          .toSet()
          .toList();
      if (labels.isNotEmpty) {
        return labels.take(3).join(' • ');
      }
    }
    return state.tagline;
  }

  String _localizedLeague(String league, AppLocalizations l10n) {
    switch (league.trim().toUpperCase()) {
      case 'BRONZE LEAGUE':
      case 'BRONZE_LEAGUE':
        return l10n.leagueBronze;
      case 'SILVER LEAGUE':
      case 'SILVER_LEAGUE':
        return l10n.leagueSilver;
      case 'GOLD LEAGUE':
      case 'GOLD_LEAGUE':
        return l10n.leagueGold;
      case 'PLATINUM LEAGUE':
      case 'PLATINUM_LEAGUE':
        return l10n.leaguePlatinum;
      case 'DIAMOND LEAGUE':
      case 'DIAMOND_LEAGUE':
        return l10n.leagueDiamond;
      default:
        return league;
    }
  }

  Future<void> _onSettingsTap(
    BuildContext context,
    ProfileSettingItem item,
    ProfileState state,
  ) async {
    switch (item.icon) {
      case 'availability':
        final updated = await Navigator.of(context, rootNavigator: true)
            .push<bool>(
              MaterialPageRoute(builder: (_) => const AvailabilityScreen()),
            );
        if (updated == true && context.mounted) {
          await context.read<ProfileCubit>().refreshProfile();
        }
        break;
      case 'sports':
        final updated = await Navigator.of(context, rootNavigator: true)
            .push<bool>(
              MaterialPageRoute(
                builder: (_) => SportPreferencesScreen(
                  initialProfiles: state.sportProfiles,
                ),
              ),
            );
        if (updated == true && context.mounted) {
          await context.read<ProfileCubit>().refreshProfile();
        }
        break;
      case 'history':
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(MaterialPageRoute(builder: (_) => const MatchHistoryScreen()));
        break;
      default:
        break;
    }
  }

  Future<void> _openNextMatchResult(
    BuildContext context,
    ProfileState state,
  ) async {
    final match = state.nextMatch;
    if (match == null) return;

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MatchResultScreen(
          gameId: match.gameId,
          challengerName: state.name.trim().isNotEmpty
              ? state.name.trim()
              : AppLocalizations.of(context).you,
          opponentName: match.opponentName,
          opponentAvatarUrl: match.opponentAvatar,
        ),
      ),
    );

    if (!context.mounted) return;
    await context.read<ProfileCubit>().refreshProfile();
  }
}

class _AccountVerificationCard extends StatelessWidget {
  const _AccountVerificationCard({required this.shouldShow});

  final bool shouldShow;

  @override
  Widget build(BuildContext context) {
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileVerifyPhoneTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          6.vSpacing,
          Text(
            l10n.profileVerifyPhoneSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          12.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => const PhoneLoginScreen(
                      openOnboardingOnSkip: false,
                      openOnboardingForNewUser: false,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.profileVerifyPhoneAction),
            ),
          ),
        ],
      ),
    );
  }
}
