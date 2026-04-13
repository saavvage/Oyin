import 'package:flutter/material.dart';

import 'package:oyin_front/domain/export.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../match/widgets/filters_form.dart';

class SparringPreferencesResult {
  const SparringPreferencesResult({
    required this.filters,
    required this.publicVisibility,
    required this.matchRequests,
    required this.disputeUpdates,
  });

  final MatchFilters filters;
  final bool publicVisibility;
  final bool matchRequests;
  final bool disputeUpdates;
}

class SparringPreferencesScreen extends StatefulWidget {
  const SparringPreferencesScreen({
    super.key,
    required this.initialFilters,
    required this.initialPublicVisibility,
    required this.initialMatchRequests,
    required this.initialDisputeUpdates,
  });

  final MatchFilters initialFilters;
  final bool initialPublicVisibility;
  final bool initialMatchRequests;
  final bool initialDisputeUpdates;

  @override
  State<SparringPreferencesScreen> createState() =>
      _SparringPreferencesScreenState();
}

class _SparringPreferencesScreenState extends State<SparringPreferencesScreen> {
  late MatchFilters _filters;
  late bool _publicVisibility;
  late bool _matchRequests;
  late bool _disputeUpdates;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _publicVisibility = widget.initialPublicVisibility;
    _matchRequests = widget.initialMatchRequests;
    _disputeUpdates = widget.initialDisputeUpdates;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  8.hSpacing,
                  Expanded(
                    child: Text(
                      l10n.sparringPreferences,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: l10n.matchFiltersTitle,
                      child: MatchFiltersForm(
                        l10n: l10n,
                        distanceRange: RangeValues(
                          _filters.distanceKmMin,
                          _filters.distanceKmMax,
                        ),
                        ageRange: RangeValues(
                          _filters.ageMin.toDouble(),
                          _filters.ageMax.toDouble(),
                        ),
                        onDistanceChanged: (values) {
                          setState(() {
                            _filters = _filters.copyWith(
                              distanceKmMin: values.start.roundToDouble(),
                              distanceKmMax: values.end.roundToDouble(),
                            );
                          });
                        },
                        onAgeChanged: (values) {
                          setState(() {
                            _filters = _filters.copyWith(
                              ageMin: values.start.round(),
                              ageMax: values.end.round(),
                            );
                          });
                        },
                      ),
                    ),
                    14.vSpacing,
                    _SectionCard(
                      title: l10n.notifications,
                      child: Column(
                        children: [
                          _SwitchTile(
                            title: l10n.publicVisibility,
                            subtitle: l10n.publicVisibilityDesc,
                            value: _publicVisibility,
                            onChanged: (value) {
                              setState(() => _publicVisibility = value);
                            },
                          ),
                          8.vSpacing,
                          _SwitchTile(
                            title: l10n.matchRequests,
                            subtitle: l10n.settingsMatchTip1,
                            value: _matchRequests,
                            onChanged: (value) {
                              setState(() => _matchRequests = value);
                            },
                          ),
                          8.vSpacing,
                          _SwitchTile(
                            title: l10n.disputeUpdates,
                            subtitle: l10n.settingsMatchTip2,
                            value: _disputeUpdates,
                            onChanged: (value) {
                              setState(() => _disputeUpdates = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    16.vSpacing,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        l10n.settingsMatchSubtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                      ),
                    ),
                    24.vSpacing,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(l10n.save),
                      ),
                    ),
                    20.vSpacing,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(
      SparringPreferencesResult(
        filters: _filters,
        publicVisibility: _publicVisibility,
        matchRequests: _matchRequests,
        disputeUpdates: _disputeUpdates,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          10.vSpacing,
          child,
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                4.vSpacing,
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
