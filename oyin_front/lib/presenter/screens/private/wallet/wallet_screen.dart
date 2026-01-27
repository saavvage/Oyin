import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';
import 'widgets/reward_sheet.dart';
import 'transfer_screen.dart';
import 'store_screen.dart';
import 'history_screen.dart';
import '../../../../../app/localization/app_localizations.dart';

class WalletEntryButton extends StatelessWidget {
  const WalletEntryButton({super.key, required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => WalletScreen(balance: balance)));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.card,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber),
          10.hSpacing,
          Expanded(
            child: Text(
              l10n.walletBalance(balance.toString()),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white70),
        ],
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, color: Colors.amber),
            8.hSpacing,
            Text(l10n.walletBalance(balance.toString())),
          ],
        ),
      ),
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ThreeActions(),
              16.vSpacing,
              _DailyRewardCard(),
              16.vSpacing,
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreeActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: _ActionBlock(label: l10n.walletTransfer, icon: Icons.send, onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransferScreen()));
        })),
        10.hSpacing,
        Expanded(child: _ActionBlock(label: l10n.walletStore, icon: Icons.storefront, onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoreScreen()));
        })),
        10.hSpacing,
        Expanded(child: _ActionBlock(label: l10n.walletHistory, icon: Icons.history, onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
        })),
      ],
    );
  }
}

class _ActionBlock extends StatelessWidget {
  const _ActionBlock({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.card,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber),
          6.vSpacing,
          Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DailyRewardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.greenAccent),
          10.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.walletDailyReward, style: Theme.of(context).textTheme.titleMedium),
                4.vSpacing,
                Text(l10n.walletClaimBonus,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showRewardSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l10n.walletClaim),
          ),
        ],
      ),
    );
  }

  void _showRewardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RewardSheet(parentContext: context),
    );
  }
}

class _StoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final items = ['Gym pass', 'Equipment', 'Coach session', 'Energy drink'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: palette.card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.walletStore, style: Theme.of(context).textTheme.titleMedium),
          10.vSpacing,
          ...items.map(
            (i) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(i),
              trailing: Text(l10n.walletBuy),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final history = [
      'Bought gym pass (-150)',
      'Received daily reward (+20)',
      'Transfer from Alex (+50)',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: palette.card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.walletHistory, style: Theme.of(context).textTheme.titleMedium),
          10.vSpacing,
          ...history.map(
            (h) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(h),
            ),
          ),
        ],
      ),
    );
  }
}
