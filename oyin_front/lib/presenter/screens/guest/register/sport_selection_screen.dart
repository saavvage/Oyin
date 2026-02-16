import 'package:flutter/material.dart';

import '../../../../domain/export.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'level_selection_screen.dart';
import 'onboarding_draft.dart';

class SportSelectionScreen extends StatefulWidget {
  const SportSelectionScreen({super.key, required this.draft});

  final RegistrationOnboardingDraft draft;

  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final Set<String> _selectedSports;

  @override
  void initState() {
    super.initState();
    _selectedSports = widget.draft.selectedSports.toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final query = _searchController.text.trim().toLowerCase();
    final entries = kSportCatalog.where((item) {
      if (query.isEmpty) return true;
      final code = item.code.toLowerCase();
      final label = item.label.toLowerCase();
      return code.contains(query) || label.contains(query);
    }).toList();

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
                      value: 0.34,
                      minHeight: 6,
                      backgroundColor: palette.badge,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.primary,
                      ),
                    ),
                    24.vSpacing,
                    Text(
                      l10n.onboardingSportSelectionTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Text(
                      l10n.onboardingSportSelectionSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: palette.muted),
                    ),
                    20.vSpacing,
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: l10n.onboardingSportSelectionSearchHint,
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
                    14.vSpacing,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: palette.primary.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Text(
                        l10n.onboardingSportSelectionInfo,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                      ),
                    ),
                    16.vSpacing,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.92,
                          ),
                      itemBuilder: (context, index) {
                        final item = entries[index];
                        final selected = _selectedSports.contains(item.code);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedSports.remove(item.code);
                              } else {
                                _selectedSports.add(item.code);
                              }
                            });
                          },
                          child: _SportTile(
                            label: item.label,
                            icon: _iconForSport(item.code),
                            selected: selected,
                          ),
                        );
                      },
                    ),
                    20.vSpacing,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSports.isEmpty
                      ? null
                      : () {
                          final updatedDraft = widget.draft.copyWith(
                            selectedSports: _selectedSports.toList(),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  LevelSelectionScreen(draft: updatedDraft),
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
                    _selectedSports.isEmpty
                        ? l10n.continueLabel
                        : l10n.onboardingSportSelectionCreateProfiles(
                            _selectedSports.length,
                          ),
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

  IconData _iconForSport(String code) {
    switch (code) {
      case 'BOXING':
        return Icons.sports_mma_rounded;
      case 'MUAY_THAI':
      case 'MMA':
      case 'KICKBOXING':
        return Icons.sports_kabaddi_rounded;
      case 'BJJ':
      case 'WRESTLING':
        return Icons.groups_rounded;
      case 'TENNIS':
      case 'TABLE_TENNIS':
      case 'PADEL':
        return Icons.sports_tennis_rounded;
      case 'BASKETBALL':
        return Icons.sports_basketball_rounded;
      case 'FOOTBALL':
        return Icons.sports_soccer_rounded;
      case 'SWIMMING':
        return Icons.pool_rounded;
      case 'RUNNING':
        return Icons.directions_run_rounded;
      case 'VOLLEYBALL':
        return Icons.sports_volleyball_rounded;
      default:
        return Icons.sports;
    }
  }
}

class _SportTile extends StatelessWidget {
  const _SportTile({
    required this.label,
    required this.icon,
    required this.selected,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? palette.primary
              : palette.badge.withValues(alpha: 0.65),
          width: selected ? 2 : 1.2,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? palette.primary : palette.muted,
            ),
          ),
          const Spacer(),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected
                  ? palette.primary.withValues(alpha: 0.18)
                  : palette.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: selected ? palette.primary : palette.muted,
              size: 28,
            ),
          ),
          14.vSpacing,
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
