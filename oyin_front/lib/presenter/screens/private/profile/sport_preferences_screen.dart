import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../domain/export.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'cubit/profile_state.dart';

class SportPreferencesScreen extends StatefulWidget {
  const SportPreferencesScreen({super.key, required this.initialProfiles});

  final List<UserSportProfileView> initialProfiles;

  @override
  State<SportPreferencesScreen> createState() => _SportPreferencesScreenState();
}

class _SportPreferencesScreenState extends State<SportPreferencesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final Set<String> _selectedSports = <String>{};
  final Set<String> _skills = <String>{};
  String _selectedLevel = 'AMATEUR';
  bool _isSaving = false;

  static const List<String> _levelOptions = ['AMATEUR', 'SEMI_PRO', 'PRO'];

  @override
  void initState() {
    super.initState();
    if (widget.initialProfiles.isNotEmpty) {
      _selectedSports.addAll(
        widget.initialProfiles.map((item) => item.sportType.toUpperCase()),
      );
      _skills.addAll(
        widget.initialProfiles
            .expand((item) => item.skills)
            .where((item) => item.trim().isNotEmpty),
      );
      _selectedLevel = widget.initialProfiles.first.level.toUpperCase();
      _experienceController.text = widget.initialProfiles.first.experienceYears
          .toString();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _experienceController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final query = _searchController.text.trim().toLowerCase();
    final sports = kSportCatalog.where((item) {
      if (query.isEmpty) return true;
      final localizedName = l10n.sportName(item.code).toLowerCase();
      final fallbackName = sportLabelByCode(item.code).toLowerCase();
      return localizedName.contains(query) ||
          fallbackName.contains(query) ||
          item.code.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        title: Text(l10n.sportPreferences),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: l10n.sportPreferencesSearchHint,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: palette.badge),
                        ),
                      ),
                    ),
                    14.vSpacing,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sports.map((sport) {
                        final selected = _selectedSports.contains(sport.code);
                        return FilterChip(
                          label: Text(l10n.sportName(sport.code)),
                          selected: selected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                _selectedSports.add(sport.code);
                              } else {
                                _selectedSports.remove(sport.code);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    22.vSpacing,
                    Text(
                      l10n.sportPreferencesLevelLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _levelOptions.map((level) {
                        final selected = _selectedLevel == level;
                        return ChoiceChip(
                          label: Text(_levelLabel(level, l10n)),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _selectedLevel = level;
                          }),
                        );
                      }).toList(),
                    ),
                    20.vSpacing,
                    TextField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.sportPreferencesExperienceHint,
                        suffixText: l10n.onboardingDetailsYearsSuffix,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: palette.badge),
                        ),
                      ),
                    ),
                    20.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _skillController,
                            decoration: InputDecoration(
                              hintText: l10n.sportPreferencesAddSkillHint,
                              filled: true,
                              fillColor: palette.card,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: palette.badge),
                              ),
                            ),
                            onSubmitted: (_) => _addSkill(),
                          ),
                        ),
                        8.hSpacing,
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _addSkill,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    if (_skills.isNotEmpty) ...[
                      10.vSpacing,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _skills
                            .map(
                              (skill) => Chip(
                                label: Text(l10n.skillTag(skill)),
                                onDeleted: () {
                                  setState(() => _skills.remove(skill));
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: palette.badge,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _isSaving
                        ? l10n.sportPreferencesSaving
                        : l10n.sportPreferencesSave,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) return;
    setState(() {
      _skills.add(skill);
      _skillController.clear();
    });
  }

  String _levelLabel(String code, AppLocalizations l10n) {
    switch (code) {
      case 'SEMI_PRO':
        return l10n.levelSemiPro;
      case 'PRO':
        return l10n.levelProfessional;
      default:
        return l10n.levelAmateur;
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedSports.isEmpty) {
      AppNotifier.showWarning(context, l10n.sportPreferencesSelectAtLeastOne);
      return;
    }

    final years = int.tryParse(_experienceController.text.trim()) ?? 0;

    setState(() => _isSaving = true);
    try {
      final inputs = _selectedSports
          .map(
            (sport) => UserSportProfileInput(
              sportType: sport,
              level: _selectedLevel,
              skills: _skills.toList(),
              experienceYears: years.clamp(0, 90),
            ),
          )
          .toList();

      await UsersApi.replaceSportProfiles(profiles: inputs);
      if (!mounted) return;
      AppNotifier.showSuccess(context, l10n.sportPreferencesUpdatedSuccess);
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
