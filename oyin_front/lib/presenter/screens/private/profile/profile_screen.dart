import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../wallet/wallet_screen.dart';
import 'cubit/_export.dart';
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
                  ),
                  24.vSpacing,
                  ProfileStatsGrid(l10n: l10n, stats: state.stats),
                  16.vSpacing,
                  WalletEntryButton(balance: 350),
                  20.vSpacing,
                  NextMatchCard(l10n: l10n, match: state.nextMatch),
                  20.vSpacing,
                  ProfileSettingsList(l10n: l10n, items: state.settingsItems),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
