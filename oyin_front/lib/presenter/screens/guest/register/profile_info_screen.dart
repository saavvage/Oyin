import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'onboarding_draft.dart';
import 'sport_selection_screen.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key, this.phone = ''});

  final String phone;

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  bool _isLoading = false;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _city = TextEditingController();
  final _birthController = TextEditingController();
  DateTime? _birthDate;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _city.dispose();
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 10, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: context.palette.primary),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthController.text =
            '${picked.day.toString().padLeft(2, '0')}.'
            '${picked.month.toString().padLeft(2, '0')}.'
            '${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                      value: 1,
                      minHeight: 6,
                      backgroundColor: context.palette.badge,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.palette.primary,
                      ),
                    ),
                    28.vSpacing,
                    Text(
                      l10n.profileInfoTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.weighted(FontWeight.w800),
                    ),
                    12.vSpacing,
                    Text(
                      l10n.profileInfoSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.colored(context.palette.muted),
                    ),
                    28.vSpacing,
                    _RoundedField(
                      controller: _firstName,
                      label: l10n.firstName,
                      hintText: 'Ivan',
                    ),
                    16.vSpacing,
                    _RoundedField(
                      controller: _lastName,
                      label: l10n.lastName,
                      hintText: 'Ivanov',
                    ),
                    16.vSpacing,
                    _RoundedField(
                      controller: _email,
                      label: l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'ivan@example.ru',
                    ),
                    16.vSpacing,
                    _RoundedField(
                      controller: _birthController,
                      label: l10n.birthDate,
                      hintText: 'dd.mm.yyyy',
                      readOnly: true,
                      onTap: () => _pickDate(context),
                    ),
                    16.vSpacing,
                    _RoundedField(
                      controller: _city,
                      label: l10n.city,
                      hintText: 'Almaty',
                    ),
                    const SizedBox(height: 24),
                    _PrimaryActionButton(
                      label: _isLoading
                          ? '${l10n.continueLabel}...'
                          : l10n.continueLabel,
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final fullName = [
                                _firstName.text.trim(),
                                _lastName.text.trim(),
                              ].where((v) => v.isNotEmpty).join(' ');

                              final draft = RegistrationOnboardingDraft(
                                phone: widget.phone,
                                name: fullName,
                                email: _email.text.trim(),
                                city: _city.text.trim(),
                                birthDate: _birthDate,
                                selectedSports: const [],
                                level: null,
                                experienceYears: null,
                                skills: const [],
                              );

                              setState(() => _isLoading = true);
                              if (!mounted) return;
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SportSelectionScreen(draft: draft),
                                ),
                              );
                              if (mounted) setState(() => _isLoading = false);
                            },
                    ),
                    12.vSpacing,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.controller,
    required this.hintText,
    required this.label,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final String label;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.weighted(FontWeight.w700),
        ),
        8.vSpacing,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: context.palette.card,
            hintStyle: TextStyle(color: context.palette.muted),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.palette.badge),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.palette.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.palette.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.weighted(FontWeight.w700),
        ),
      ),
    );
  }
}
