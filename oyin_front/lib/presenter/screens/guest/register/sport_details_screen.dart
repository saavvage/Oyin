import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../domain/export.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../../private/navbar/nav_shell.dart';
import 'onboarding_draft.dart';

class SportDetailsScreen extends StatefulWidget {
  const SportDetailsScreen({super.key, required this.draft});

  final RegistrationOnboardingDraft draft;

  @override
  State<SportDetailsScreen> createState() => _SportDetailsScreenState();
}

class _SportDetailsScreenState extends State<SportDetailsScreen> {
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final Set<String> _skills = <String>{};
  bool _isLoading = false;

  static const List<String> _suggestedSkills = [
    'Striking',
    'Cardio',
    'Endurance',
    'Defense',
    'Footwork',
    'Serve',
    'Agility',
    'Technique',
    'Speed',
  ];

  @override
  void initState() {
    super.initState();
    final exp = widget.draft.experienceYears;
    if (exp != null && exp > 0) {
      _experienceController.text = exp.toString();
    }
    _skills.addAll(widget.draft.skills);
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

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
                      value: 1.0,
                      minHeight: 6,
                      backgroundColor: palette.badge,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.primary,
                      ),
                    ),
                    24.vSpacing,
                    Text(
                      l10n.onboardingDetailsProfileTitle(
                        _levelTitle(widget.draft.level, l10n),
                      ),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Text(
                      l10n.onboardingDetailsFillSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: palette.muted),
                    ),
                    20.vSpacing,
                    Text(
                      l10n.onboardingDetailsExperienceLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    TextField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.onboardingDetailsExperienceHint,
                        suffixText: l10n.onboardingDetailsYearsSuffix,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: palette.badge),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: palette.badge),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: palette.primary),
                        ),
                      ),
                    ),
                    10.vSpacing,
                    Text(
                      l10n.onboardingDetailsExperienceDesc,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                    24.vSpacing,
                    Text(
                      l10n.onboardingDetailsSkillsLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _skillController,
                            decoration: InputDecoration(
                              hintText: l10n.onboardingDetailsAddSkillHint,
                              filled: true,
                              fillColor: palette.card,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: palette.badge),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: palette.badge),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: palette.primary),
                              ),
                            ),
                            onSubmitted: (_) => _addSkillFromInput(),
                          ),
                        ),
                        10.hSpacing,
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _addSkillFromInput,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    if (_skills.isNotEmpty) ...[
                      12.vSpacing,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _skills
                            .map(
                              (skill) => Chip(
                                label: Text(l10n.skillTag(skill)),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () {
                                  setState(() {
                                    _skills.remove(skill);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    18.vSpacing,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.onboardingDetailsSuggestionsLabel,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: palette.muted,
                                ),
                          ),
                          10.vSpacing,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _suggestedSkills
                                .map(
                                  (skill) => ActionChip(
                                    label: Text(l10n.skillTag(skill)),
                                    onPressed: () {
                                      setState(() {
                                        _skills.add(skill);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
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
                  onPressed: _isLoading ? null : _submit,
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
                    _isLoading
                        ? '${l10n.continueLabel}...'
                        : l10n.onboardingDetailsCompleteProfile,
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

  void _addSkillFromInput() {
    final value = _skillController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _skills.add(value);
      _skillController.clear();
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (widget.draft.level == null || widget.draft.selectedSports.isEmpty) {
      AppNotifier.showWarning(
        context,
        l10n.onboardingDetailsSelectSportLevelWarning,
      );
      return;
    }

    final years = int.tryParse(_experienceController.text.trim());
    final experienceYears = years == null ? 0 : years.clamp(0, 90);

    setState(() => _isLoading = true);

    try {
      final isGuest = await SessionStorage.getGuestMode();
      if (isGuest) {
        final nameParts = widget.draft.name.trim().split(' ');
        MockUserRepository.instance.save(
          UserProfileM(
            firstName: nameParts.isNotEmpty ? nameParts.first : '',
            lastName: nameParts.length > 1
                ? nameParts.sublist(1).join(' ')
                : '',
            email: widget.draft.email,
            city: widget.draft.city,
            phone: widget.draft.phone,
            birthDate: widget.draft.birthDate,
            selectedSports: widget.draft.selectedSports,
            level: widget.draft.level ?? '',
            experienceYears: experienceYears,
            skills: _skills.toList(),
          ),
        );

        if (!mounted) return;
        AppNotifier.showSuccess(
          context,
          l10n.onboardingDetailsLocalProfileCreatedSuccess,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NavShell()),
          (route) => false,
        );
        return;
      }

      await UsersApi.updateProfile(
        name: widget.draft.name.isNotEmpty ? widget.draft.name : 'New User',
        email: widget.draft.email,
        city: widget.draft.city,
        birthDate: widget.draft.birthDate,
      );

      final profiles = widget.draft.selectedSports
          .map(
            (sportCode) => UserSportProfileInput(
              sportType: sportCode,
              level: widget.draft.level!,
              skills: _skills.toList(),
              experienceYears: experienceYears,
            ),
          )
          .toList();

      await UsersApi.replaceSportProfiles(profiles: profiles);

      final nameParts = widget.draft.name.trim().split(' ');
      MockUserRepository.instance.save(
        UserProfileM(
          firstName: nameParts.isNotEmpty ? nameParts.first : '',
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          email: widget.draft.email,
          city: widget.draft.city,
          phone: widget.draft.phone,
          birthDate: widget.draft.birthDate,
          selectedSports: widget.draft.selectedSports,
          level: widget.draft.level ?? '',
          experienceYears: experienceYears,
          skills: _skills.toList(),
        ),
      );

      if (!mounted) return;
      AppNotifier.showSuccess(
        context,
        l10n.onboardingDetailsProfileCreatedSuccess,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const NavShell()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _levelTitle(String? levelCode, AppLocalizations l10n) {
    switch ((levelCode ?? '').toUpperCase()) {
      case 'AMATEUR':
        return l10n.levelAmateur;
      case 'SEMI_PRO':
        return l10n.levelSemiPro;
      case 'PRO':
        return l10n.levelProfessional;
      default:
        return l10n.onboardingDetailsLevelFallback;
    }
  }
}
