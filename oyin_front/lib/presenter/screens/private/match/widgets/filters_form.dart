import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../extensions/_export.dart';

class MatchFiltersForm extends StatelessWidget {
  const MatchFiltersForm({
    super.key,
    required this.l10n,
    required this.distanceRange,
    required this.ageRange,
    required this.onDistanceChanged,
    required this.onAgeChanged,
    this.onApply,
    this.showApply = false,
  });

  final AppLocalizations l10n;
  final RangeValues distanceRange;
  final RangeValues ageRange;
  final ValueChanged<RangeValues> onDistanceChanged;
  final ValueChanged<RangeValues> onAgeChanged;
  final VoidCallback? onApply;
  final bool showApply;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.matchFiltersDistance,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        6.vSpacing,
        Text(
          l10n.matchFiltersDistanceValue(
            distanceRange.start.round(),
            distanceRange.end.round(),
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        8.vSpacing,
        RangeSlider(
          values: distanceRange,
          min: 0,
          max: 500,
          divisions: 50,
          activeColor: palette.primary,
          inactiveColor: palette.surface,
          labels: RangeLabels(
            distanceRange.start.round().toString(),
            distanceRange.end.round().toString(),
          ),
          onChanged: onDistanceChanged,
        ),
        18.vSpacing,
        Text(
          l10n.matchFiltersAge,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        6.vSpacing,
        Text(
          l10n.matchFiltersAgeValue(
            ageRange.start.round(),
            ageRange.end.round(),
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        8.vSpacing,
        RangeSlider(
          values: ageRange,
          min: 14,
          max: 100,
          divisions: 86,
          activeColor: palette.primary,
          inactiveColor: palette.surface,
          labels: RangeLabels(
            ageRange.start.round().toString(),
            ageRange.end.round().toString(),
          ),
          onChanged: onAgeChanged,
        ),
        if (showApply) ...[
          16.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.matchFiltersApply),
            ),
          ),
        ],
      ],
    );
  }
}
