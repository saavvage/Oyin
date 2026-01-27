import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final items = [
      l10n.storeItemGym,
      l10n.storeItemEquipment,
      l10n.storeItemCoach,
      l10n.storeItemEnergy,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletStore)),
      backgroundColor: palette.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                title: Text(item),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(l10n.walletBuy),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
