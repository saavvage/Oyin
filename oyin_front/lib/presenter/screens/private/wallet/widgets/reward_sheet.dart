import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';

class RewardSheet extends StatelessWidget {
  const RewardSheet({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
            ),
            12.vSpacing,
            const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
            10.vSpacing,
            Text(l10n.walletDailyStreak, style: Theme.of(context).textTheme.titleMedium),
            12.vSpacing,
            ...List.generate(7, (i) {
              final day = i + 1;
              final reward = day == 7 ? 500 : day * 10;
              final claimed = day <= 2; 
              final tileColor = claimed ? Colors.green.withValues(alpha:0.12) : Colors.transparent;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(10),
                  border: claimed ? Border.all(color: Colors.greenAccent, width: 1) : null,
                ),
                child: ListTile(
                  leading: claimed ? const Icon(Icons.check_circle, color: Colors.greenAccent) : null,
                  title: Text(l10n.walletDay(day.toString())),
                  trailing: Text(l10n.walletCoins(reward.toString())),
                ),
              );
            }),
            10.vSpacing,
            ElevatedButton(
              onPressed: () {
                Navigator.of(parentContext).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: parentContext,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 36),
                          12.vSpacing,
                          Text(
                            'Успешно!',
                            style: Theme.of(parentContext).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          6.vSpacing,
                          Text(
                            l10n.walletGetReward,
                            textAlign: TextAlign.center,
                            style: Theme.of(parentContext).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(parentContext).pop(),
                          child: const Text('Закрыть'),
                        ),
                      ],
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(46),
              ),
              child: Text(l10n.walletGetReward),
            ),
          ],
        ),
      ),
    );
  }
}
