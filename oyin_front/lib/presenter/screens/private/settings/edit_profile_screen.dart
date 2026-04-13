import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  DateTime? _birthDate;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await UsersApi.getMe();
      if (!mounted) return;
      _nameController.text = (data['name'] ?? '').toString();
      _emailController.text = (data['email'] ?? '').toString();
      _cityController.text = (data['city'] ?? '').toString();
      final raw = data['birthDate']?.toString() ?? '';
      if (raw.isNotEmpty) {
        _birthDate = DateTime.tryParse(raw);
      }
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifier.showError(context, e);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final city = _cityController.text.trim();

    if (name.isEmpty) {
      final l10n = AppLocalizations.of(context);
      AppNotifier.showMessage(
        context,
        l10n.nameRequired,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await UsersApi.updateProfile(
        name: name,
        email: email,
        city: city,
        birthDate: _birthDate,
      );
      await UsersApi.getMe();
      if (!mounted) return;
      AppNotifier.showSuccess(
        context,
        AppLocalizations.of(context).profileUpdated,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      AppNotifier.showError(context, e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  12.hSpacing,
                  Text(
                    l10n.personalInfo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _Field(
                        controller: _nameController,
                        label: l10n.firstName,
                        icon: Icons.person_outline,
                      ),
                      14.vSpacing,
                      _Field(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      14.vSpacing,
                      _Field(
                        controller: _cityController,
                        label: l10n.city,
                        icon: Icons.location_city_outlined,
                      ),
                      14.vSpacing,
                      GestureDetector(
                        onTap: _pickBirthDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: palette.card,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.cake_outlined,
                                color: palette.muted,
                                size: 20,
                              ),
                              12.hSpacing,
                              Text(
                                _birthDate != null
                                    ? '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}'
                                    : l10n.birthDate,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: _birthDate != null
                                          ? null
                                          : palette.muted,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      28.vSpacing,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: palette.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.save),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: palette.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
