import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../utils/phone_mask.dart';
import '../../../utils/validators.dart';
import '../../../extensions/_export.dart';
import 'verify_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  PhoneCountry _country = kPhoneCountries.first;
  bool _isMasking = false;

  void _applyMask() {
    if (_isMasking) return;
    final raw = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final limited = raw.length > _country.maxDigits ? raw.substring(0, _country.maxDigits) : raw;
    final formatted = _formatByCountry(limited, _country.maxDigits);

    if (_phoneController.text != formatted) {
      _isMasking = true;
      _phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _isMasking = false;
    }
  }

  String _formatByCountry(String digits, int max) {
    final patterns = {
      10: [3, 3, 2, 2],
      9: [3, 3, 3],
      8: [2, 3, 3],
    };
    final pattern = patterns[max] ?? [3, 3, 3];
    final buf = StringBuffer();
    var index = 0;
    for (final group in pattern) {
      if (index >= digits.length) break;
      final end = (index + group).clamp(0, digits.length);
      buf.write(digits.substring(index, end));
      index = end;
      if (index < digits.length) buf.write(' ');
    }
    if (index < digits.length) buf.write(digits.substring(index));
    return buf.toString();
  }

  @override
  void dispose() {
    _phoneController.removeListener(_applyMask);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_applyMask);
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
                value: 0.33,
                minHeight: 6,
                backgroundColor: context.palette.badge,
                valueColor: AlwaysStoppedAnimation<Color>(context.palette.primary),
              ),
              28.vSpacing,
              Text(
                l10n.phoneEntryTitle,
                style: Theme.of(context).textTheme.titleLarge?.weighted(FontWeight.w800),
              ),
              12.vSpacing,
              Text(
                l10n.phoneEntrySubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.colored(context.palette.muted),
              ),
              32.vSpacing,
              Text(
                l10n.phoneNumberLabel,
                style: Theme.of(context).textTheme.titleSmall?.weighted(FontWeight.w700),
              ),
              12.vSpacing,
              Row(
                children: [
                  _CountrySelector(
                    value: _country,
                    onChanged: (value) => setState(() {
                      _country = value;
                      _applyMask();
                    }),
                  ),
                  12.hSpacing,
                  Expanded(
                    child: _RoundedField(
                      controller: _phoneController,
                      hintText: '(___) ___-____',
                      keyboardType: TextInputType.phone,
                      maxLength: _country.maxDigits,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _PrimaryActionButton(
                label: l10n.sendCode,
                onPressed: () {
                  final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
                  if (!Validators.isPhoneComplete(digitsOnly: digits, requiredLength: _country.maxDigits)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.phoneNumberLabel)),
                    );
                    return;
                  }
                  final phone = '${_country.dialCode} ${formatPhoneDigits(digits)}';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VerifyCodeScreen(phone: phone),
                    ),
                  );
                },
              ),
              12.vSpacing,
              Text(
                l10n.termsAgree,
                style: Theme.of(context).textTheme.bodySmall?.colored(context.palette.muted),
              ),
              8.vSpacing,
            ],
          ),
        ),
      ),
    );
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.value, required this.onChanged});

  final PhoneCountry value;
  final ValueChanged<PhoneCountry> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: context.palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.palette.badge),
        ),
        child: DropdownButton<PhoneCountry>(
          value: value,
          dropdownColor: context.palette.card,
          borderRadius: BorderRadius.circular(12),
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 18),
          isExpanded: true,
          selectedItemBuilder: (context) => kPhoneCountries
              .map(
                (c) => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${c.flag} ${c.dialCode}',
                        style: Theme.of(context).textTheme.titleSmall?.colored(Colors.white),
                      ),
                    ),
              )
              .toList(),
          items: kPhoneCountries
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(c.flag),
                        4.hSpacing,
                        Text(
                          c.dialCode,
                          style: Theme.of(context).textTheme.titleSmall?.colored(Colors.white),
                        ),
                        4.hSpacing,
                        Text(
                          c.code,
                          style: Theme.of(context).textTheme.bodyMedium?.colored(context.palette.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
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
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (_, {required int currentLength, required bool isFocused, int? maxLength}) => null,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: context.palette.card,
        hintStyle: TextStyle(color: context.palette.muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.palette.badge),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.palette.primary),
        ),
      ),
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
