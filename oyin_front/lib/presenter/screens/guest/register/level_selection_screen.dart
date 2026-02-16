import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'onboarding_draft.dart';
import 'sport_details_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key, required this.draft});

  final RegistrationOnboardingDraft draft;

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.draft.level;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final options = <_LevelOption>[
      _LevelOption(
        code: 'AMATEUR',
        title: l10n.levelAmateur,
        subtitle: l10n.onboardingLevelAmateurSubtitle,
        details: [
          l10n.onboardingLevelAmateurDetail1,
          l10n.onboardingLevelAmateurDetail2,
        ],
      ),
      _LevelOption(
        code: 'SEMI_PRO',
        title: l10n.levelSemiPro,
        subtitle: l10n.onboardingLevelSemiProSubtitle,
        details: [
          l10n.onboardingLevelSemiProDetail1,
          l10n.onboardingLevelSemiProDetail2,
        ],
      ),
      _LevelOption(
        code: 'PRO',
        title: l10n.levelProfessional,
        subtitle: l10n.onboardingLevelProfessionalSubtitle,
        details: [
          l10n.onboardingLevelProfessionalDetail1,
          l10n.onboardingLevelProfessionalDetail2,
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                      onPressed: Navigator.of(context).maybePop,
                    ),
                    12.vSpacing,
                    LinearProgressIndicator(
                      value: 0.67,
                      minHeight: 6,
                      backgroundColor: palette.badge,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.primary,
                      ),
                    ),
                    24.vSpacing,
                    Text(
                      l10n.onboardingLevelChoosePathTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Text(
                      l10n.onboardingLevelChoosePathSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: palette.muted),
                    ),
                    18.vSpacing,
                    ...options.map((item) {
                      final selected = _selectedLevel == item.code;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? palette.primary
                                : palette.badge.withValues(alpha: 0.6),
                            width: selected ? 2 : 1.2,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () =>
                              setState(() => _selectedLevel = item.code),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          4.vSpacing,
                                          Text(
                                            item.subtitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: selected
                                                      ? palette.primary
                                                      : palette.muted,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      selected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: selected
                                          ? palette.primary
                                          : palette.muted,
                                    ),
                                  ],
                                ),
                                10.vSpacing,
                                ...item.details.map(
                                  (line) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      '• $line',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: palette.muted),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    10.vSpacing,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        l10n.onboardingLevelWhyItMatters,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedLevel == null
                      ? null
                      : () {
                          final updated = widget.draft.copyWith(
                            level: _selectedLevel,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SportDetailsScreen(draft: updated),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: palette.badge,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    l10n.continueLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelOption {
  const _LevelOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  final String code;
  final String title;
  final String subtitle;
  final List<String> details;
}
