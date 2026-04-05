import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';
import '../../../../../infrastructure/services/network/wallet_api.dart';
import '../../../../widgets/_export.dart';

class RewardSheet extends StatelessWidget {
  const RewardSheet({
    super.key,
    required this.parentContext,
    required this.streak,
    required this.onClaimed,
  });

  final BuildContext parentContext;
  final int streak;
  final VoidCallback onClaimed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rewards = [10, 20, 30, 40, 50, 60, 500];
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
              final reward = rewards[i];
              final claimed = day <= streak;
              final tileColor = claimed ? Colors.green.withValues(alpha: 0.12) : Colors.transparent;
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
              onPressed: () => _claim(context),
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

  Future<void> _claim(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await WalletApi.claimDailyReward();
      final reward = (result['reward'] as num?)?.toInt() ?? 0;

      Navigator.of(parentContext).pop();
      onClaimed();

      if (!parentContext.mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!parentContext.mounted) return;
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
                  l10n.walletGetReward,
                  style: Theme.of(parentContext).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                6.vSpacing,
                Text(
                  '+$reward coins',
                  textAlign: TextAlign.center,
                  style: Theme.of(parentContext).textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(parentContext).pop(),
                child: Text(AppLocalizations.of(parentContext).ok),
              ),
            ],
          ),
        );
      });
    } catch (e) {
      Navigator.of(parentContext).pop();
      if (!parentContext.mounted) return;
      AppNotifier.showMessage(
        parentContext,
        e.toString(),
        title: l10n.notifTitleWarning,
        type: AppNotificationType.warning,
      );
    }
  }
}
