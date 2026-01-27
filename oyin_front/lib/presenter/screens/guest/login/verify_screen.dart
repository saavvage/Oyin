import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../register/profile_info_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.phone});

  final String phone;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());

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
                valueColor: AlwaysStoppedAnimation<Color>(context.palette.primary),
              ),
              32.vSpacing,
              Text(
                l10n.verificationTitle,
                style: Theme.of(context).textTheme.titleLarge?.weighted(FontWeight.w800),
              ),
              12.vSpacing,
              Text(
                l10n.verificationSubtitle(widget.phone),
                style: Theme.of(context).textTheme.bodyLarge?.colored(context.palette.muted),
              ),
              28.vSpacing,
              _otpRow(context),
              16.vSpacing,
              Row(
                children: [
                  Text(
                    l10n.resendCode,
                    style: Theme.of(context).textTheme.titleSmall?.colored(context.palette.primary),
                  ),
                  8.hSpacing,
                  Text(
                    '(0:24)',
                    style: Theme.of(context).textTheme.bodySmall?.colored(context.palette.muted),
                  ),
                ],
              ),
              const Spacer(),
              _PrimaryActionButton(
                label: l10n.verifyIdentity,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ProfileInfoScreen(phone: widget.phone),
                    ),
                  );
                },
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
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.weighted(FontWeight.w700),
        ),
      ),
    );
  }
}
