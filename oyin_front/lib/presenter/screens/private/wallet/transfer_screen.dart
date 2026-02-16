import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _coinsController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _coinsController.dispose();
    super.dispose();
  }

  void _send(AppLocalizations l10n) {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final coins = int.tryParse(_coinsController.text.trim()) ?? 0;

    if (phone.length < 10) {
      AppNotifier.showMessage(
        context,
        'Введите корректный номер получателя.',
        title: l10n.notifTitleWarning,
        type: AppNotificationType.warning,
      );
      return;
    }

    if (coins <= 0) {
      AppNotifier.showMessage(
        context,
        'Укажите количество монет больше 0.',
        title: l10n.notifTitleWarning,
        type: AppNotificationType.warning,
      );
      return;
    }

    AppNotifier.showMessage(
      context,
      'Перевод на +$phone отправлен: $coins монет.',
      title: l10n.notifTitleSuccess,
      type: AppNotificationType.success,
    );

    _coinsController.clear();
  }

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
                  Text(
                    l10n.walletBalance('350'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              16.vSpacing,
              TextField(
                controller: _phoneController,
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              12.vSpacing,
              TextField(
                controller: _coinsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.walletCoinsAmount,
                  filled: true,
                  fillColor: palette.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              16.vSpacing,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _send(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
