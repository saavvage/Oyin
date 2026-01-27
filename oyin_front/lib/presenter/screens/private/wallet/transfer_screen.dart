import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.amber),
            8.hSpacing,
            Text(l10n.walletTransfer),
          ],
        ),
      ),
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  8.hSpacing,
                  Text(l10n.walletBalance('350'), style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              16.vSpacing,
              TextField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  _PhoneMaskInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: l10n.walletPhoneNumber,
                  hintText: '7 777 777 77 77',
                  filled: true,
                  fillColor: palette.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              12.vSpacing,
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.walletCoinsAmount,
                  filled: true,
                  fillColor: palette.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              16.vSpacing,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.walletSend),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneMaskInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var text = '';
    for (var i = 0; i < digits.length; i++) {
      text += digits[i];
      if (i == 0) text += ' ';
      if (i == 3) text += ' ';
      if (i == 6 || i == 8) text += ' ';
    }
    return TextEditingValue(
      text: text.trimRight(),
      selection: TextSelection.collapsed(offset: text.trimRight().length),
    );
  }
}
