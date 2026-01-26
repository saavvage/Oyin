import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

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
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsHeader(l10n: l10n),
                  12.vSpacing,
                  SettingsSearchBar(placeholder: l10n.searchSettingsPlaceholder),
                  14.vSpacing,
                  SettingsUserTile(
                    name: state.userName,
                    subtitle: state.userSubtitle,
                    tag: state.userTag,
                  ),
                  16.vSpacing,
                  SettingsSectionList(
                    l10n: l10n,
                    sections: state.sections,
                    publicVisibility: state.publicVisibility,
                    matchRequests: state.matchRequests,
                    disputeUpdates: state.disputeUpdates,
                    onTogglePublicVisibility: context.read<SettingsCubit>().togglePublicVisibility,
                    onToggleMatchRequests: context.read<SettingsCubit>().toggleMatchRequests,
                    onToggleDisputeUpdates: context.read<SettingsCubit>().toggleDisputeUpdates,
                    onLocaleSelected: (code) {
                      context.read<SettingsCubit>().setLocale(code);
                      AppLocalizations.delegate.load(Locale(code));
                      OyinApp.of(context).setLocale(Locale(code));
                    },
                    selectedLocale: state.selectedLocale,
                  ),
                  16.vSpacing,
                  SettingsLogoutFooter(l10n: l10n),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
