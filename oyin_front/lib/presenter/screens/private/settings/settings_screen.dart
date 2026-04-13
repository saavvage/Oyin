import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oyin_front/domain/export.dart';
import '../../../../app/app.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../match/widgets/filters_form.dart';
import 'account_overview_screen.dart';
import 'blocked_users_screen.dart';
import 'cubit/_export.dart';
import 'edit_profile_screen.dart';
import 'fair_play_rules_screen.dart';
import 'help_center_screen.dart';
import 'password_security_screen.dart';
import 'sparring_preferences_screen.dart';
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
                    name: state.userName.isEmpty
                        ? l10n.profile
                        : state.userName,
                    subtitle: _localizedUserSubtitle(state, l10n),
                    tag: _localizedUserTag(state, l10n),
                    onTap: () async {
                      final updated = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => const AccountOverviewScreen(),
                        ),
                      );
                      if (updated == true && context.mounted) {
                        context.read<SettingsCubit>().refreshUserData();
                      }
                    },
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
                        _onSettingsItemTap(context, item, state),
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
    BuildContext context,
    SettingsItem item,
    SettingsState state,
  ) async {
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
        final updated = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const PasswordSecurityScreen()),
        );
        if (updated == true && context.mounted) {
          context.read<SettingsCubit>().refreshUserData();
        }
        break;
      case 'shield':
        final result = await Navigator.of(context)
            .push<SparringPreferencesResult>(
              MaterialPageRoute(
                builder: (_) => SparringPreferencesScreen(
                  initialFilters: state.matchFilters,
                  initialPublicVisibility: state.publicVisibility,
                  initialMatchRequests: state.matchRequests,
                  initialDisputeUpdates: state.disputeUpdates,
                ),
              ),
            );
        if (result != null && context.mounted) {
          final cubit = context.read<SettingsCubit>();
          await cubit.updateMatchFilters(result.filters);
          cubit.togglePublicVisibility(result.publicVisibility);
          cubit.toggleMatchRequests(result.matchRequests);
          cubit.toggleDisputeUpdates(result.disputeUpdates);
        }
        break;
      case 'block':
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const BlockedUsersScreen()));
        break;
      case 'help':
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
        break;
      case 'rules':
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FairPlayRulesScreen()));
        break;
    }
  }

  String _localizedUserSubtitle(SettingsState state, AppLocalizations l10n) {
    final subtitle = state.userSubtitle.trim();
    if (subtitle.isEmpty) {
      return '';
    }
    return l10n.sportName(subtitle);
  }

  String _localizedUserTag(SettingsState state, AppLocalizations l10n) {
    final tag = state.userTag.trim();
    if (tag.isEmpty) {
      return '';
    }
    return l10n.levelName(tag);
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
