import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'contract_draft_store.dart';

class ContractSetupScreen extends StatefulWidget {
  const ContractSetupScreen({
    super.key,
    required this.gameId,
    this.forceReadOnly = false,
    this.initialDateTime,
    this.initialLocation,
    this.initialReminder,
  });

  final String gameId;
  final bool forceReadOnly;
  final DateTime? initialDateTime;
  final String? initialLocation;
  final bool? initialReminder;

  @override
  State<ContractSetupScreen> createState() => _ContractSetupScreenState();
}

class _ContractSetupScreenState extends State<ContractSetupScreen> {
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _reminderEnabled = true;
  bool _acceptedCode = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  GameDetailsDto? _game;

  bool get _isReadOnly {
    if (widget.forceReadOnly) return true;
    return _game?.contractData?.date != null;
  }

  bool get _isDemoGame => widget.gameId.startsWith('demo-game-');

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onLocationChanged);
    _load();
  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationChanged);
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    final savedDraft = ContractDraftStore.get(widget.gameId);
    if (savedDraft != null) {
      _applyDraft(savedDraft);
    } else if (widget.initialDateTime != null) {
      final local = widget.initialDateTime!.toLocal();
      _selectedDate = DateTime(local.year, local.month, local.day);
      _selectedTime = TimeOfDay(hour: local.hour, minute: local.minute);
      _locationController.text = (widget.initialLocation ?? '').trim();
      _reminderEnabled = widget.initialReminder ?? true;
      _acceptedCode = true;
    }

    if (_isDemoGame) {
      try {
        final game = await GamesApi.getById(widget.gameId);
        final contract = game.contractData;
        if (contract?.date != null) {
          final local = contract!.date!.toLocal();
          _selectedDate = DateTime(local.year, local.month, local.day);
          _selectedTime = TimeOfDay(hour: local.hour, minute: local.minute);
          _locationController.text = (contract.location ?? '').trim();
          _reminderEnabled = contract.reminder;
          _acceptedCode = true;
          ContractDraftStore.clear(widget.gameId);
        } else {
          _ensureDefaults();
          _cacheDraft();
        }
        if (mounted) {
          setState(() => _game = game);
        }
      } catch (_) {
        _ensureDefaults();
        _cacheDraft();
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      final game = await GamesApi.getById(widget.gameId);
      if (!mounted) return;

      final contract = game.contractData;
      if (contract?.date != null) {
        final local = contract!.date!.toLocal();
        _selectedDate = DateTime(local.year, local.month, local.day);
        _selectedTime = TimeOfDay(hour: local.hour, minute: local.minute);
        _locationController.text = (contract.location ?? '').trim();
        _reminderEnabled = contract.reminder;
        _acceptedCode = true;
        ContractDraftStore.clear(widget.gameId);
      } else {
        _ensureDefaults();
        _cacheDraft();
      }

      setState(() => _game = game);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickDate() async {
    if (_isReadOnly || _isSaving) return;
    final current = _selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: current,
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedDate = picked);
    _cacheDraft();
  }

  Future<void> _pickTime() async {
    if (_isReadOnly || _isSaving) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedTime = picked);
    _cacheDraft();
  }

  Future<void> _submitContract() async {
    if (_isReadOnly || _isSaving) return;
    final l10n = AppLocalizations.of(context);

    if (_selectedDate == null || _selectedTime == null) {
      AppNotifier.showMessage(
        context,
        l10n.contractRequiredDate,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    final location = _locationController.text.trim();
    if (location.isEmpty) {
      AppNotifier.showMessage(
        context,
        l10n.contractRequiredLocation,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    if (!_acceptedCode) {
      AppNotifier.showMessage(
        context,
        l10n.contractAgreementRequired,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    setState(() => _isSaving = true);
    try {
      if (_isDemoGame) {
        final updated = await GamesApi.proposeContract(
          gameId: widget.gameId,
          dateTime: dateTime,
          location: location,
          reminder: _reminderEnabled,
        );
        if (!mounted) return;
        setState(() => _game = updated);
        _cacheDraft(confirmed: true);
        AppNotifier.showSuccess(context, l10n.contractSaved);
        Navigator.of(context).pop(true);
        return;
      }

      final updated = await GamesApi.proposeContract(
        gameId: widget.gameId,
        dateTime: dateTime,
        location: location,
        reminder: _reminderEnabled,
      );

      if (!mounted) return;
      setState(() => _game = updated);
      ContractDraftStore.clear(widget.gameId);
      AppNotifier.showSuccess(context, l10n.contractSaved);
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

  String _dateLabel(AppLocalizations l10n) {
    final date = _selectedDate;
    if (date == null) return l10n.contractDatePlaceholder;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  String _timeLabel(AppLocalizations l10n) {
    final time = _selectedTime;
    if (time == null) return l10n.contractTimePlaceholder;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _ensureDefaults() {
    if (_selectedDate == null) {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      _selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    }
    _selectedTime ??= const TimeOfDay(hour: 18, minute: 0);
  }

  void _applyDraft(ContractDraft draft) {
    if (draft.dateTime != null) {
      final local = draft.dateTime!.toLocal();
      _selectedDate = DateTime(local.year, local.month, local.day);
      _selectedTime = TimeOfDay(hour: local.hour, minute: local.minute);
    }
    _locationController.text = draft.location;
    _reminderEnabled = draft.reminder;
    _acceptedCode = draft.acceptedCode;
  }

  DateTime? _composeDateTime() {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  void _onLocationChanged() {
    if (_isLoading) return;
    _cacheDraft();
  }

  void _cacheDraft({bool confirmed = false}) {
    final existing = ContractDraftStore.get(widget.gameId);
    final draft = ContractDraft(
      dateTime: _composeDateTime() ?? existing?.dateTime,
      location: _locationController.text.trim(),
      reminder: _reminderEnabled,
      acceptedCode: _acceptedCode,
      confirmed: confirmed || (existing?.confirmed ?? false),
    );
    ContractDraftStore.save(widget.gameId, draft);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final progress = _isReadOnly ? 1.0 : 0.5;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        Expanded(
                          child: Text(
                            l10n.contractSetupTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    10.vSpacing,
                    Text(
                      l10n.contractProgressTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                    8.vSpacing,
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(999),
                      backgroundColor: palette.card,
                    ),
                    8.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: _StepLabel(
                            label: l10n.contractStepContract,
                            active: true,
                          ),
                        ),
                        Expanded(
                          child: _StepLabel(
                            label: l10n.contractStepResult,
                            active: _isReadOnly,
                            alignRight: true,
                          ),
                        ),
                      ],
                    ),
                    if (_isReadOnly) ...[
                      10.vSpacing,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.greenAccent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          l10n.contractLockedHint,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.greenAccent),
                        ),
                      ),
                    ],
                    18.vSpacing,
                    Text(
                      l10n.contractLogistics,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    10.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: _ValueTile(
                            label: l10n.contractDateLabel,
                            value: _dateLabel(l10n),
                            icon: Icons.calendar_month_rounded,
                            onTap: _pickDate,
                            enabled: !_isReadOnly,
                          ),
                        ),
                        10.hSpacing,
                        Expanded(
                          child: _ValueTile(
                            label: l10n.contractTimeLabel,
                            value: _timeLabel(l10n),
                            icon: Icons.schedule_rounded,
                            onTap: _pickTime,
                            enabled: !_isReadOnly,
                          ),
                        ),
                      ],
                    ),
                    14.vSpacing,
                    Text(
                      l10n.contractLocationLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.vSpacing,
                    TextField(
                      controller: _locationController,
                      enabled: !_isReadOnly && !_isSaving,
                      decoration: InputDecoration(
                        hintText: l10n.contractLocationHint,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                    10.vSpacing,
                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 34,
                        color: palette.muted,
                      ),
                    ),
                    16.vSpacing,
                    Text(
                      l10n.contractNotificationsTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SwitchListTile(
                      value: _reminderEnabled,
                      onChanged: _isReadOnly || _isSaving
                          ? null
                          : (value) {
                              setState(() => _reminderEnabled = value);
                              _cacheDraft();
                            },
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.contractReminderToggle),
                    ),
                    8.vSpacing,
                    Text(
                      l10n.contractAgreementStatusTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.vSpacing,
                    _AgreementStatusTile(
                      title: l10n.contractAgreementYou,
                      subtitle: _isReadOnly
                          ? l10n.contractAgreementYouStatusLocked
                          : l10n.contractAgreementYouStatusPending,
                      success: _isReadOnly,
                    ),
                    8.vSpacing,
                    _AgreementStatusTile(
                      title: l10n.contractAgreementOpponent,
                      subtitle: l10n.contractAgreementOpponentStatus,
                      success: false,
                    ),
                    10.vSpacing,
                    CheckboxListTile(
                      value: _acceptedCode,
                      onChanged: _isReadOnly || _isSaving
                          ? null
                          : (value) {
                              setState(() => _acceptedCode = value == true);
                              _cacheDraft();
                            },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.contractCodeOfConduct),
                    ),
                    14.vSpacing,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isReadOnly ? null : _submitContract,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              )
                            : Text(
                                l10n.contractProposeButton,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.label,
    required this.active,
    this.alignRight = false,
  });

  final String label;
  final bool active;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      label,
      textAlign: alignRight ? TextAlign.end : TextAlign.start,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: active ? Colors.white : palette.muted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: palette.muted),
        ),
        6.vSpacing,
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled
                    ? palette.badge
                    : palette.badge.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(icon, size: 18, color: palette.muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AgreementStatusTile extends StatelessWidget {
  const _AgreementStatusTile({
    required this.title,
    required this.subtitle,
    required this.success,
  });

  final String title;
  final String subtitle;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: success
                ? Colors.greenAccent.withValues(alpha: 0.18)
                : Colors.orangeAccent.withValues(alpha: 0.2),
            child: Icon(
              success ? Icons.check_rounded : Icons.more_horiz_rounded,
              size: 16,
              color: success ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ),
          10.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                2.vSpacing,
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
