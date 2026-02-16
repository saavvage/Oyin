import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../../domain/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../register/profile_info_screen.dart';
import '../../private/navbar/nav_shell.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.phone,
    this.autoSendCode = false,
  });

  final String phone;
  final bool autoSendCode;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool _isLoading = false;
  bool _isSendingCode = false;
  bool _codeRequested = false;
  final _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.autoSendCode) {
      _sendCode(showError: false);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
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
              LinearProgressIndicator(
                value: 0.66,
                minHeight: 6,
                backgroundColor: context.palette.badge,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.palette.primary,
                ),
              ),
              32.vSpacing,
              Text(
                l10n.verificationTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.weighted(FontWeight.w800),
              ),
              12.vSpacing,
              Text(
                l10n.verificationSubtitle(widget.phone),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.colored(context.palette.muted),
              ),
              28.vSpacing,
              _otpRow(context),
              16.vSpacing,
              Row(
                children: [
                  TextButton(
                    onPressed: _isSendingCode ? null : () => _sendCode(),
                    child: Text(
                      _isSendingCode
                          ? '${l10n.resendCode}...'
                          : l10n.resendCode,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.colored(context.palette.primary),
                    ),
                  ),
                  8.hSpacing,
                  Text(
                    _codeRequested ? '(ok)' : '(...)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.colored(context.palette.muted),
                  ),
                ],
              ),
              const Spacer(),
              _PrimaryActionButton(
                label: _isLoading
                    ? '${l10n.verifyIdentity}...'
                    : l10n.verifyIdentity,
                onPressed: _isLoading
                    ? null
                    : () async {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length != _controllers.length) {
                          AppNotifier.showMessage(
                            context,
                            l10n.verifyCodeIncompleteMessage,
                            title: l10n.verifyCodeIncompleteTitle,
                            type: AppNotificationType.warning,
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        try {
                          if (!_codeRequested) {
                            await _sendCode(showError: false);
                          }

                          final response = await AuthApi.verify(
                            phone: widget.phone,
                            code: code,
                          );
                          await SessionStorage.setAccessToken(
                            response.accessToken,
                          );
                          await PushNotificationsService.syncTokenWithBackend();

                          final user = response.user;
                          if (user.isNotEmpty) {
                            final name = (user['name'] ?? '').toString().trim();
                            final parts = name.isNotEmpty
                                ? name.split(' ')
                                : <String>[];
                            final firstName = parts.isNotEmpty
                                ? parts.first
                                : '';
                            final lastName = parts.length > 1
                                ? parts.sublist(1).join(' ')
                                : '';

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
                                phone: (user['phone'] ?? widget.phone)
                                    .toString(),
                                birthDate: birthDate,
                              ),
                            );
                          }

                          if (!mounted) return;
                          if (response.isNewUser) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileInfoScreen(phone: widget.phone),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const NavShell(),
                              ),
                            );
                          }
                        } catch (error) {
                          if (!mounted) return;
                          AppNotifier.showError(context, error);
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
              ),
              8.vSpacing,
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _skipForNow,
                  child: Text(
                    l10n.authSkipForNow,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.palette.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              16.vSpacing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_controllers.length, (index) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: context.palette.card,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.palette.badge),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.palette.primary),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < _controllers.length - 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }

  Future<void> _sendCode({bool showError = true}) async {
    if (_isSendingCode) return;
    setState(() => _isSendingCode = true);
    try {
      await AuthApi.login(phone: widget.phone);
      if (!mounted) return;
      setState(() {
        _codeRequested = true;
      });
    } catch (error) {
      if (!mounted) return;
      if (showError) {
        AppNotifier.showError(context, error);
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingCode = false);
      }
    }
  }

  Future<void> _skipForNow() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.authSkipDialogTitle),
          content: Text(l10n.authSkipDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.messengerDialogCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.authSkipDialogConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await SessionStorage.setGuestMode(true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileInfoScreen(phone: widget.phone)),
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
