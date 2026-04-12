import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../domain/export.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  static const List<String> _dayKeys = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];
  static const List<String> _slotKeys = ['morning', 'day', 'evening'];

  final TextEditingController _cityController = TextEditingController();
  late Map<String, Map<String, bool>> _schedule;
  bool _isLoading = true;
  bool _isSaving = false;
  int _profilesCount = 0;

  @override
  void initState() {
    super.initState();
    _schedule = _createEmptySchedule();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _load();
      }
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(context, l10n.availabilityLocation),
                          10.vSpacing,
                          _buildLocationField(context, l10n),
                          18.vSpacing,
                          _sectionTitle(
                            context,
                            l10n.availabilityWeeklySchedule,
                          ),
                          10.vSpacing,
                          _buildPresets(context, l10n),
                          12.vSpacing,
                          _buildSlotsHeader(context, l10n),
                          8.vSpacing,
                          _buildScheduleGrid(context, l10n),
                          22.vSpacing,
                          _sectionTitle(context, l10n.availabilitySupportInfo),
                          10.vSpacing,
                          _buildSupportTile(
                            context,
                            title: l10n.availabilityHelpFaq,
                            icon: Icons.help_outline_rounded,
                            onTap: () => showFrostedInfoModal(
                              context,
                              title: l10n.availabilityHelpFaq,
                              subtitle: l10n.helpCenter,
                              tips: [
                                l10n.settingsHelpTip1,
                                l10n.settingsHelpTip2,
                              ],
                              actionLabel: l10n.ok,
                            ),
                          ),
                          10.vSpacing,
                          _buildSupportTile(
                            context,
                            title: l10n.aboutUs,
                            icon: Icons.info_outline_rounded,
                            onTap: () => showFrostedInfoModal(
                              context,
                              title: l10n.aboutUs,
                              subtitle: 'Oyin',
                              tips: [l10n.madeWithCare],
                              actionLabel: l10n.ok,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSaving
                            ? '${l10n.save}...'
                            : l10n.availabilityFindPartners,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      8.hSpacing,
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              l10n.availability,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              l10n.save,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        hintText: l10n.availabilityLocationHint,
        prefixIcon: const Icon(Icons.location_on_outlined),
        filled: true,
        fillColor: palette.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.badge),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.badge),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.primary),
        ),
      ),
    );
  }

  Widget _buildPresets(BuildContext context, AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PresetChip(
          label: l10n.availabilitySelectAll,
          onTap: () => _applyPreset(_AvailabilityPreset.selectAll),
        ),
        _PresetChip(
          label: l10n.availabilityWeekdays,
          onTap: () => _applyPreset(_AvailabilityPreset.weekdays),
        ),
        _PresetChip(
          label: l10n.availabilityWeekends,
          onTap: () => _applyPreset(_AvailabilityPreset.weekends),
        ),
      ],
    );
  }

  Widget _buildSlotsHeader(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    return Row(
      children: [
        const SizedBox(width: 34),
        8.hSpacing,
        ...[
          (
            key: 'morning',
            title: l10n.availabilityTimeMorning,
            time: '06-12',
            icon: Icons.wb_sunny_outlined,
          ),
          (
            key: 'day',
            title: l10n.availabilityTimeDay,
            time: '12-17',
            icon: Icons.wb_sunny_rounded,
          ),
          (
            key: 'evening',
            title: l10n.availabilityTimeEvening,
            time: '17-23',
            icon: Icons.dark_mode_outlined,
          ),
        ].map(
          (slot) => Expanded(
            child: Column(
              children: [
                Icon(slot.icon, size: 16, color: palette.muted),
                2.vSpacing,
                Text(
                  slot.time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleGrid(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        for (var dayIndex = 0; dayIndex < _dayKeys.length; dayIndex++) ...[
          Row(
            children: [
              SizedBox(
                width: 34,
                child: Text(
                  _dayLabel(_dayKeys[dayIndex], l10n),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: dayIndex >= 5
                        ? context.palette.primary
                        : context.palette.muted,
                  ),
                ),
              ),
              8.hSpacing,
              ..._slotKeys.map(
                (slotKey) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: _ScheduleCell(
                      selected: _isSelected(_dayKeys[dayIndex], slotKey),
                      onTap: () => _toggleSlot(_dayKeys[dayIndex], slotKey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSupportTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final palette = context.palette;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: palette.muted),
            ),
            10.hSpacing,
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: palette.muted),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String value) {
    return Text(
      value.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: context.palette.muted,
      ),
    );
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final isGuest = await SessionStorage.getGuestMode();
      if (isGuest) {
        final local = MockUserRepository.instance.getOrDefault();
        _cityController.text = local.city;
        if (!mounted) return;
        setState(() {
          _profilesCount = 0;
          _schedule = _createEmptySchedule();
          _isLoading = false;
        });
        return;
      }

      final availability = await UsersApi.getAvailabilitySettings();
      if (!mounted) return;
      setState(() {
        _cityController.text = availability.city;
        _profilesCount = availability.profilesCount;
        _schedule = _parseSchedule(availability.schedule);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final l10n = AppLocalizations.of(context);
      AppNotifier.showWarning(context, l10n.availabilityLoadFailed);
      AppNotifier.showError(context, error);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_isSaving) return;

    final isGuest = await SessionStorage.getGuestMode();
    if (!mounted) return;
    if (isGuest) {
      AppNotifier.showWarning(context, l10n.profileVerifyPhoneSubtitle);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await UsersApi.updateAvailabilitySettings(
        city: _cityController.text.trim(),
        schedule: _buildSchedulePayload(),
      );

      if (!mounted) return;
      if (response.profilesCount == 0 && _profilesCount == 0) {
        AppNotifier.showWarning(context, l10n.availabilityProfileRequired);
      } else {
        AppNotifier.showSuccess(context, l10n.availabilitySaved);
      }
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

  Map<String, Map<String, bool>> _createEmptySchedule() {
    return {
      for (final day in _dayKeys)
        day: {for (final slot in _slotKeys) slot: false},
    };
  }

  Map<String, Map<String, bool>> _parseSchedule(Map<String, dynamic> raw) {
    final schedule = _createEmptySchedule();
    final daysRaw = raw['days'];
    final source = daysRaw is Map ? daysRaw.cast<String, dynamic>() : raw;

    for (final day in _dayKeys) {
      final dayValue =
          source[day] ??
          source[day.toUpperCase()] ??
          source[_capitalize(day)] ??
          const {};
      if (dayValue is Map) {
        final dayMap = dayValue.cast<String, dynamic>();
        for (final slot in _slotKeys) {
          schedule[day]![slot] = _asBool(
            dayMap[slot] ?? dayMap[slot.toUpperCase()],
          );
        }
      } else if (dayValue is List) {
        final normalized = dayValue
            .whereType<String>()
            .map((item) => item.trim().toLowerCase())
            .toSet();
        for (final slot in _slotKeys) {
          schedule[day]![slot] = normalized.contains(slot);
        }
      }
    }

    return schedule;
  }

  Map<String, dynamic> _buildSchedulePayload() {
    return {
      'timezone': DateTime.now().timeZoneName,
      'days': {
        for (final day in _dayKeys)
          day: {for (final slot in _slotKeys) slot: _isSelected(day, slot)},
      },
      'slots': const {'morning': '06-12', 'day': '12-17', 'evening': '17-23'},
    };
  }

  String _dayLabel(String dayKey, AppLocalizations l10n) {
    switch (dayKey) {
      case 'mon':
        return l10n.availabilityDayMon;
      case 'tue':
        return l10n.availabilityDayTue;
      case 'wed':
        return l10n.availabilityDayWed;
      case 'thu':
        return l10n.availabilityDayThu;
      case 'fri':
        return l10n.availabilityDayFri;
      case 'sat':
        return l10n.availabilityDaySat;
      case 'sun':
        return l10n.availabilityDaySun;
      default:
        return dayKey;
    }
  }

  bool _isSelected(String dayKey, String slotKey) {
    return _schedule[dayKey]?[slotKey] ?? false;
  }

  void _toggleSlot(String dayKey, String slotKey) {
    setState(() {
      final current = _schedule[dayKey]?[slotKey] ?? false;
      _schedule[dayKey]?[slotKey] = !current;
    });
  }

  void _applyPreset(_AvailabilityPreset preset) {
    setState(() {
      for (final day in _dayKeys) {
        final isWeekday = day != 'sat' && day != 'sun';
        final shouldSelect = switch (preset) {
          _AvailabilityPreset.selectAll => true,
          _AvailabilityPreset.weekdays => isWeekday,
          _AvailabilityPreset.weekends => !isWeekday,
        };
        for (final slot in _slotKeys) {
          _schedule[day]?[slot] = shouldSelect;
        }
      }
    });
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value > 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

enum _AvailabilityPreset { selectAll, weekdays, weekends }

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: palette.badge),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: selected ? palette.primary : palette.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? palette.primary.withValues(alpha: 0.45)
                : palette.badge,
          ),
        ),
        alignment: Alignment.center,
        child: selected
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.black)
            : const SizedBox.shrink(),
      ),
    );
  }
}
