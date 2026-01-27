import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final history = [
      'Bought gym pass (-150)', 
      'Received daily reward (+20)',
      'Transfer from Alex (+50)',
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletHistory)),
      backgroundColor: palette.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(history[i]),
          ),
        ),
      ),
    );
  }
}
