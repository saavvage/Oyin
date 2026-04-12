import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../domain/export.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../../private/navbar/nav_shell.dart';
import 'phone_screen.dart';
import '../register/profile_info_screen.dart';

class CredentialAuthScreen extends StatefulWidget {
  const CredentialAuthScreen({super.key, required this.isRegistration});

  final bool isRegistration;

  @override
  State<CredentialAuthScreen> createState() => _CredentialAuthScreenState();
}

class _CredentialAuthScreenState extends State<CredentialAuthScreen> {
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  bool get _isRegistration => widget.isRegistration;

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
                onPressed: Navigator.of(context).maybePop,
              ),
              12.vSpacing,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: palette.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.badge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRegistration ? l10n.getStarted : l10n.logIn,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    8.vSpacing,
                    Text(
                      _isRegistration
                          ? l10n.authCredentialRegisterSubtitle
                          : l10n.authCredentialLoginSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                    16.vSpacing,
                    if (_isRegistration) ...[
                      _LabeledField(
                        label: l10n.email,
                        child: _InputField(
                          controller: _emailController,
                          hintText: 'your@email.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      12.vSpacing,
                      _LabeledField(
                        label:
                            '${l10n.phoneNumberLabel} ${l10n.authCredentialOptional}',
                        child: _InputField(
                          controller: _phoneController,
                          hintText: '+7 777 123 45 67',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      12.vSpacing,
                    ] else ...[
                      _LabeledField(
                        label: l10n.authCredentialLoginLabel,
                        child: _InputField(
                          controller: _loginController,
                          hintText: l10n.authCredentialLoginHint,
                        ),
                      ),
                      12.vSpacing,
                    ],
                    _LabeledField(
                      label: l10n.authCredentialPasswordLabel,
                      child: _InputField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        obscureText: _hidePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: palette.muted,
                          ),
                          onPressed: () {
                            setState(() => _hidePassword = !_hidePassword);
                          },
                        ),
                      ),
                    ),
                    if (_isRegistration) ...[
                      12.vSpacing,
                      _LabeledField(
                        label: l10n.authCredentialConfirmPasswordLabel,
                        child: _InputField(
                          controller: _confirmPasswordController,
                          hintText: '••••••••',
                          obscureText: _hideConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              _hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: palette.muted,
                            ),
                            onPressed: () {
                              setState(
                                () => _hideConfirmPassword =
                                    !_hideConfirmPassword,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    18.vSpacing,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
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
                          _isLoading
                              ? '${l10n.continueLabel}...'
                              : (_isRegistration
                                    ? l10n.getStarted
                                    : l10n.logIn),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              14.vSpacing,
              Center(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => CredentialAuthScreen(
                                isRegistration: !_isRegistration,
                              ),
                            ),
                          );
                        },
                  child: Text(
                    _isRegistration
                        ? l10n.authCredentialSwitchToLogin
                        : l10n.authCredentialSwitchToRegister,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (!_isRegistration) ...[
                4.vSpacing,
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PhoneLoginScreen(
                            openOnboardingOnSkip: false,
                            openOnboardingForNewUser: false,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      l10n.authCredentialUseOtp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_isRegistration) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirm = _confirmPasswordController.text.trim();

      if (email.isEmpty || !email.contains('@')) {
        AppNotifier.showMessage(
          context,
          l10n.enterValidEmail,
          title: l10n.email,
          type: AppNotificationType.warning,
        );
        return;
      }
      if (password.length < 6) {
        AppNotifier.showMessage(
          context,
          l10n.authCredentialPasswordTooShort,
          title: l10n.authCredentialPasswordLabel,
          type: AppNotificationType.warning,
        );
        return;
      }
      if (password != confirm) {
        AppNotifier.showMessage(
          context,
          l10n.authCredentialPasswordsMismatch,
          title: l10n.authCredentialPasswordLabel,
          type: AppNotificationType.warning,
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final response = await AuthApi.register(
          email: email,
          password: password,
          phone: _phoneController.text.trim(),
        );
        await SessionStorage.setAccessToken(response.accessToken);
        await PushNotificationsService.syncTokenWithBackend();
        _saveProfileLocally(response.user);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProfileInfoScreen(
              phone: (response.user['phone'] ?? '').toString(),
              initialEmail: email,
            ),
          ),
        );
      } catch (error) {
        if (!mounted) return;
        if (_isAlreadyRegisteredError(error)) {
          AppNotifier.showWarning(context, l10n.authCredentialEmailRegistered);
          return;
        }
        AppNotifier.showError(context, error);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();
    if (login.isEmpty || password.isEmpty) {
      AppNotifier.showWarning(context, l10n.authCredentialLoginRequired);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await AuthApi.loginWithPassword(
        login: login,
        password: password,
      );
      await SessionStorage.setAccessToken(response.accessToken);
      await PushNotificationsService.syncTokenWithBackend();
      _saveProfileLocally(response.user);

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const NavShell()));
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isAlreadyRegisteredError(Object error) {
    if (error is! DioException) return false;
    final body = error.response?.data;
    if (body is Map && body['message'] != null) {
      final message = body['message'].toString().toLowerCase();
      if (message.contains('already registered')) {
        return true;
      }
    }
    return false;
  }

  void _saveProfileLocally(Map<String, dynamic> user) {
    final name = (user['name'] ?? '').toString().trim();
    final parts = name.isNotEmpty ? name.split(' ') : <String>[];
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    DateTime? birthDate;
    final rawBirth = user['birthDate'];
    if (rawBirth is String) {
      birthDate = DateTime.tryParse(rawBirth);
    }

    MockUserRepository.instance.save(
      UserProfileM(
        firstName: firstName,
        lastName: lastName,
        email: (user['email'] ?? '').toString(),
        city: (user['city'] ?? '').toString(),
        phone: (user['phone'] ?? '').toString(),
        birthDate: birthDate,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        8.vSpacing,
        child,
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: palette.muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: palette.accent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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
}
