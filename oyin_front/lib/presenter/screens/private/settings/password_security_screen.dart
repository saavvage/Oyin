import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

enum _SecurityChannel { email, phone }

class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordCodeController = TextEditingController();

  final _emailController = TextEditingController();
  final _emailCodeController = TextEditingController();

  final _phoneController = TextEditingController();
  final _phoneCodeController = TextEditingController();

  bool _loading = true;
  bool _savingPassword = false;
  bool _sendingPasswordCode = false;
  bool _sendingEmailCode = false;
  bool _verifyingEmail = false;
  bool _sendingPhoneCode = false;
  bool _verifyingPhone = false;
  bool _hasChanges = false;

  String _currentEmail = '';
  String _currentPhone = '';
  bool _emailVerified = false;
  bool _phoneVerified = false;
  _SecurityChannel? _channel;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _passwordCodeController.dispose();
    _emailController.dispose();
    _emailCodeController.dispose();
    _phoneController.dispose();
    _phoneCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await UsersApi.getMe();
      if (!mounted) return;

      final email = (data['email'] ?? '').toString().trim();
      final phone = (data['phone'] ?? '').toString().trim();
      final hasValidEmail = email.contains('@');
      final hasValidPhone =
          phone.isNotEmpty &&
          phone.startsWith('+') &&
          !phone.startsWith('tmp_');

      setState(() {
        _currentEmail = email;
        _currentPhone = phone;
        _emailVerified = data['emailVerified'] == true;
        _phoneVerified = data['phoneVerified'] == true;
        _emailController.text = hasValidEmail ? email : '';
        _phoneController.text = hasValidPhone ? phone : '';
        _channel = hasValidEmail
            ? _SecurityChannel.email
            : (hasValidPhone ? _SecurityChannel.phone : null);
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppNotifier.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_hasChanges);
      },
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(_hasChanges),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    8.hSpacing,
                    Text(
                      l10n.passwordSecurity,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (_loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusCard(context, l10n),
                        16.vSpacing,
                        _buildPasswordCard(context, l10n),
                        16.vSpacing,
                        _buildEmailCard(context, l10n),
                        16.vSpacing,
                        _buildPhoneCard(context, l10n),
                        28.vSpacing,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, AppLocalizations l10n) {
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
            l10n.securityContactsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          8.vSpacing,
          _statusLine(
            context,
            icon: Icons.email_outlined,
            label: _currentEmail.isEmpty ? l10n.notSet : _currentEmail,
            verified: _emailVerified,
          ),
          6.vSpacing,
          _statusLine(
            context,
            icon: Icons.phone_outlined,
            label: _currentPhone.isEmpty || _currentPhone.startsWith('tmp_')
                ? l10n.notSet
                : _currentPhone,
            verified: _phoneVerified,
          ),
        ],
      ),
    );
  }

  Widget _statusLine(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool verified,
  }) {
    final palette = context.palette;
    return Row(
      children: [
        Icon(icon, size: 18, color: palette.muted),
        8.hSpacing,
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (verified ? palette.success : palette.danger).withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            verified
                ? AppLocalizations.of(context).verified
                : AppLocalizations.of(context).notVerified,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: verified ? palette.success : palette.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordCard(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    final canUseEmail = _currentEmail.contains('@');
    final canUsePhone =
        _currentPhone.isNotEmpty &&
        _currentPhone.startsWith('+') &&
        !_currentPhone.startsWith('tmp_');

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
            l10n.securityPasswordTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          6.vSpacing,
          Text(
            l10n.securityPasswordSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          12.vSpacing,
          _SecurityField(
            controller: _currentPasswordController,
            label: l10n.securityCurrentPasswordOptional,
            obscureText: true,
          ),
          10.vSpacing,
          _SecurityField(
            controller: _newPasswordController,
            label: l10n.securityNewPassword,
            obscureText: true,
          ),
          10.vSpacing,
          _SecurityField(
            controller: _confirmPasswordController,
            label: l10n.securityConfirmPassword,
            obscureText: true,
          ),
          12.vSpacing,
          Text(
            l10n.securityVerificationMethod,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: palette.muted),
          ),
          8.vSpacing,
          Wrap(
            spacing: 8,
            children: [
              if (canUseEmail)
                _ChannelChip(
                  label: l10n.email,
                  selected: _channel == _SecurityChannel.email,
                  onTap: () =>
                      setState(() => _channel = _SecurityChannel.email),
                ),
              if (canUsePhone)
                _ChannelChip(
                  label: l10n.phoneNumberLabel,
                  selected: _channel == _SecurityChannel.phone,
                  onTap: () =>
                      setState(() => _channel = _SecurityChannel.phone),
                ),
            ],
          ),
          if (canUseEmail || canUsePhone) ...[
            10.vSpacing,
            Row(
              children: [
                Expanded(
                  child: _SecurityField(
                    controller: _passwordCodeController,
                    label: l10n.verificationTitle,
                    keyboardType: TextInputType.number,
                  ),
                ),
                10.hSpacing,
                SizedBox(
                  width: 132,
                  child: OutlinedButton(
                    onPressed: _sendingPasswordCode ? null : _sendPasswordCode,
                    child: Text(
                      _sendingPasswordCode ? '...' : l10n.sendCode,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
          14.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savingPassword ? null : _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.black,
              ),
              child: Text(
                _savingPassword ? '...' : l10n.securityChangePasswordAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(BuildContext context, AppLocalizations l10n) {
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
            l10n.securityEmailTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          10.vSpacing,
          _SecurityField(
            controller: _emailController,
            label: l10n.email,
            keyboardType: TextInputType.emailAddress,
          ),
          10.vSpacing,
          Row(
            children: [
              Expanded(
                child: _SecurityField(
                  controller: _emailCodeController,
                  label: l10n.verificationTitle,
                  keyboardType: TextInputType.number,
                ),
              ),
              10.hSpacing,
              SizedBox(
                width: 132,
                child: OutlinedButton(
                  onPressed: _sendingEmailCode ? null : _sendEmailCode,
                  child: Text(_sendingEmailCode ? '...' : l10n.sendCode),
                ),
              ),
            ],
          ),
          12.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _verifyingEmail ? null : _verifyEmailChange,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.black,
              ),
              child: Text(
                _verifyingEmail ? '...' : l10n.securityChangeEmailAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneCard(BuildContext context, AppLocalizations l10n) {
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
            l10n.securityPhoneTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          10.vSpacing,
          _SecurityField(
            controller: _phoneController,
            label: l10n.phoneNumberLabel,
            keyboardType: TextInputType.phone,
          ),
          10.vSpacing,
          Row(
            children: [
              Expanded(
                child: _SecurityField(
                  controller: _phoneCodeController,
                  label: l10n.verificationTitle,
                  keyboardType: TextInputType.number,
                ),
              ),
              10.hSpacing,
              SizedBox(
                width: 132,
                child: OutlinedButton(
                  onPressed: _sendingPhoneCode ? null : _sendPhoneCode,
                  child: Text(_sendingPhoneCode ? '...' : l10n.sendCode),
                ),
              ),
            ],
          ),
          12.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _verifyingPhone ? null : _verifyPhoneChange,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.black,
              ),
              child: Text(
                _verifyingPhone ? '...' : l10n.securityChangePhoneAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordCode() async {
    final l10n = AppLocalizations.of(context);
    final channel = _channel;
    if (channel == null) {
      AppNotifier.showWarning(context, l10n.securityNoVerificationChannel);
      return;
    }

    setState(() => _sendingPasswordCode = true);
    try {
      if (channel == _SecurityChannel.email) {
        if (!_currentEmail.contains('@')) {
          throw Exception(l10n.enterValidEmail);
        }
        await AuthApi.loginWithEmail(email: _currentEmail);
      } else {
        if (!_currentPhone.startsWith('+') ||
            _currentPhone.startsWith('tmp_')) {
          throw Exception(l10n.securityPhoneNotSet);
        }
        await AuthApi.login(phone: _currentPhone);
      }
      if (!mounted) return;
      AppNotifier.showSuccess(context, l10n.securityCodeSent);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _sendingPasswordCode = false);
    }
  }

  Future<void> _updatePassword() async {
    final l10n = AppLocalizations.of(context);
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final code = _passwordCodeController.text.trim();

    if (newPassword.length < 6) {
      AppNotifier.showWarning(context, l10n.authCredentialPasswordTooShort);
      return;
    }
    if (newPassword != confirmPassword) {
      AppNotifier.showWarning(context, l10n.authCredentialPasswordsMismatch);
      return;
    }

    if (currentPassword.isEmpty) {
      if (code.isEmpty) {
        AppNotifier.showWarning(context, l10n.securityCodeRequired);
        return;
      }
      if (_channel == null) {
        AppNotifier.showWarning(context, l10n.securityNoVerificationChannel);
        return;
      }
    }

    setState(() => _savingPassword = true);
    try {
      await UsersApi.updatePassword(
        newPassword: newPassword,
        currentPassword: currentPassword.isEmpty ? null : currentPassword,
        code: currentPassword.isEmpty ? code : null,
        email: currentPassword.isEmpty && _channel == _SecurityChannel.email
            ? _currentEmail
            : null,
        phone: currentPassword.isEmpty && _channel == _SecurityChannel.phone
            ? _currentPhone
            : null,
      );
      if (!mounted) return;
      _hasChanges = true;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _passwordCodeController.clear();
      AppNotifier.showSuccess(context, l10n.securityPasswordChanged);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  Future<void> _sendEmailCode() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      AppNotifier.showWarning(context, l10n.enterValidEmail);
      return;
    }

    setState(() => _sendingEmailCode = true);
    try {
      await AuthApi.loginWithEmail(email: email);
      if (!mounted) return;
      AppNotifier.showSuccess(context, l10n.securityCodeSent);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _sendingEmailCode = false);
    }
  }

  Future<void> _verifyEmailChange() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final code = _emailCodeController.text.trim();
    if (!email.contains('@')) {
      AppNotifier.showWarning(context, l10n.enterValidEmail);
      return;
    }
    if (code.isEmpty) {
      AppNotifier.showWarning(context, l10n.securityCodeRequired);
      return;
    }

    setState(() => _verifyingEmail = true);
    try {
      final response = await AuthApi.verifyEmail(email: email, code: code);
      await SessionStorage.setAccessToken(response.accessToken);
      await PushNotificationsService.syncTokenWithBackend();
      if (!mounted) return;
      _hasChanges = true;
      _emailCodeController.clear();
      AppNotifier.showSuccess(context, l10n.securityEmailChanged);
      await _loadProfile();
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _verifyingEmail = false);
    }
  }

  Future<void> _sendPhoneCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AppNotifier.showWarning(context, l10n.securityPhoneNotSet);
      return;
    }

    setState(() => _sendingPhoneCode = true);
    try {
      await AuthApi.login(phone: phone);
      if (!mounted) return;
      AppNotifier.showSuccess(context, l10n.securityCodeSent);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _sendingPhoneCode = false);
    }
  }

  Future<void> _verifyPhoneChange() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    final code = _phoneCodeController.text.trim();
    if (phone.isEmpty) {
      AppNotifier.showWarning(context, l10n.securityPhoneNotSet);
      return;
    }
    if (code.isEmpty) {
      AppNotifier.showWarning(context, l10n.securityCodeRequired);
      return;
    }

    setState(() => _verifyingPhone = true);
    try {
      final response = await AuthApi.verify(phone: phone, code: code);
      await SessionStorage.setAccessToken(response.accessToken);
      await PushNotificationsService.syncTokenWithBackend();
      if (!mounted) return;
      _hasChanges = true;
      _phoneCodeController.clear();
      AppNotifier.showSuccess(context, l10n.securityPhoneChanged);
      await _loadProfile();
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _verifyingPhone = false);
    }
  }
}

class _SecurityField extends StatelessWidget {
  const _SecurityField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.accent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ChannelChip extends StatelessWidget {
  const _ChannelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? palette.primary.withValues(alpha: 0.15)
              : palette.accent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? palette.primary : palette.badge),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? palette.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
