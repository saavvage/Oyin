import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import '../../../../app/app.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../match/widgets/filters_form.dart';
import 'cubit/_export.dart';
import 'edit_profile_screen.dart';
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
                  SettingsSearchBar(
                    placeholder: l10n.searchSettingsPlaceholder,
                  ),
                  14.vSpacing,
                  SettingsUserTile(
                    name: state.userName,
                    subtitle: state.userSubtitle,
                    tag: state.userTag,
                  ),
                  16.vSpacing,
                  _MatchFiltersCard(
                    l10n: l10n,
                    filters: state.matchFilters,
                    onFiltersChanged: (filters) {
                      context.read<SettingsCubit>().updateMatchFilters(filters);
                    },
                  ),
                  16.vSpacing,
                  SettingsSectionList(
                    l10n: l10n,
                    sections: state.sections,
                    publicVisibility: state.publicVisibility,
                    matchRequests: state.matchRequests,
                    disputeUpdates: state.disputeUpdates,
                    onTogglePublicVisibility: context
                        .read<SettingsCubit>()
                        .togglePublicVisibility,
                    onToggleMatchRequests: context
                        .read<SettingsCubit>()
                        .toggleMatchRequests,
                    onToggleDisputeUpdates: context
                        .read<SettingsCubit>()
                        .toggleDisputeUpdates,
                    onLocaleSelected: (code) {
                      context.read<SettingsCubit>().setLocale(code);
                      OyinApp.of(context).setLocale(Locale(code));
                    },
                    selectedLocale: state.selectedLocale,
                    onItemTap: (item) =>
                        _onSettingsItemTap(context, item),
                  ),
                  16.vSpacing,
                  NotificationReminderCard(
                    l10n: l10n,
                    enabled: state.timedRemindersEnabled,
                    intervalMinutes: state.timedRemindersIntervalMinutes,
                    onToggle: (value) {
                      context.read<SettingsCubit>().toggleTimedReminders(value);
                    },
                    onSelectInterval: (minutes) {
                      context
                          .read<SettingsCubit>()
                          .setTimedReminderIntervalMinutes(minutes);
                    },
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

  Future<void> _onSettingsItemTap(
      BuildContext context, SettingsItem item) async {
    switch (item.icon) {
      case 'person':
        final updated = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
        );
        if (updated == true && context.mounted) {
          context.read<SettingsCubit>().refreshUserData();
        }
        break;
      case 'lock':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.passwordSecurity,
          subtitle: l10n.settingsAuthSubtitle,
          tips: [l10n.settingsAuthTip1, l10n.settingsAuthTip2],
        );
        break;
      case 'link':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.linkedAccounts,
          subtitle: l10n.settingsLinkedSubtitle,
          tips: [l10n.settingsLinkedTip],
        );
        break;
      case 'shield':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.sparringPreferences,
          subtitle: l10n.settingsMatchSubtitle,
          tips: [l10n.settingsMatchTip1, l10n.settingsMatchTip2],
        );
        break;
      case 'block':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.blockedUsers,
          subtitle: l10n.settingsBlockedSubtitle,
          tips: [l10n.settingsBlockedTip1, l10n.settingsBlockedTip2],
        );
        break;
      case 'help':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.helpCenter,
          subtitle: l10n.settingsHelpSubtitle,
          tips: [l10n.settingsHelpTip1, l10n.settingsHelpTip2],
        );
        break;
      case 'rules':
        final l10n = AppLocalizations.of(context);
        showFrostedInfoModal(
          context,
          title: l10n.fairPlayRules,
          subtitle: l10n.settingsFairPlaySubtitle,
          tips: [l10n.settingsFairPlayTip1, l10n.settingsFairPlayTip2, l10n.settingsFairPlayTip3, l10n.settingsFairPlayTip4],
        );
        break;
    }
  }
}

class _MatchFiltersCard extends StatelessWidget {
  const _MatchFiltersCard({
    required this.l10n,
    required this.filters,
    required this.onFiltersChanged,
  });

  final AppLocalizations l10n;
  final MatchFilters filters;
  final ValueChanged<MatchFilters> onFiltersChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.matchFiltersTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          12.vSpacing,
          MatchFiltersForm(
            l10n: l10n,
            distanceRange: RangeValues(
              filters.distanceKmMin,
              filters.distanceKmMax,
            ),
            ageRange: RangeValues(
              filters.ageMin.toDouble(),
              filters.ageMax.toDouble(),
            ),
            onDistanceChanged: (values) {
              onFiltersChanged(
                filters.copyWith(
                  distanceKmMin: values.start.roundToDouble(),
                  distanceKmMax: values.end.roundToDouble(),
                ),
              );
            },
            onAgeChanged: (values) {
              onFiltersChanged(
                filters.copyWith(
                  ageMin: values.start.round(),
                  ageMax: values.end.round(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
