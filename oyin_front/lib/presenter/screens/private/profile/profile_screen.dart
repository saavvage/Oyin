import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../wallet/wallet_screen.dart';
import 'cubit/_export.dart';
import 'sport_preferences_screen.dart';
import 'widgets/_export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileView(),
    );
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
                  ProfileHeader(l10n: l10n),
                  14.vSpacing,
                  ProfileAvatarSection(
                    name: state.name,
                    tagline: state.tagline,
                    email: state.email,
                    location: state.location,
                    league: state.league,
                    avatarUrl: state.avatarUrl,
                    onAvatarTap: () => _showAvatarActions(context),
                  ),
                  24.vSpacing,
                  ProfileStatsGrid(l10n: l10n, stats: state.stats),
                  16.vSpacing,
                  WalletEntryButton(balance: 350),
                  20.vSpacing,
                  NextMatchCard(l10n: l10n, match: state.nextMatch),
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

  Future<void> _onSettingsTap(
    BuildContext context,
    ProfileSettingItem item,
    ProfileState state,
  ) async {
    if (item.icon != 'sports') {
      return;
    }

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            SportPreferencesScreen(initialProfiles: state.sportProfiles),
      ),
    );

    if (updated == true && context.mounted) {
      await context.read<ProfileCubit>().refreshProfile();
    }
  }
}
