import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/services/network/wallet_api.dart';
import 'widgets/reward_sheet.dart';
import 'transfer_screen.dart';
import 'store_screen.dart';
import 'history_screen.dart';

class WalletEntryButton extends StatefulWidget {
  const WalletEntryButton({super.key});

  @override
  State<WalletEntryButton> createState() => _WalletEntryButtonState();
}

class _WalletEntryButtonState extends State<WalletEntryButton> {
  int _balance = 0;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final data = await WalletApi.getBalance();
      if (mounted) setState(() => _balance = data.balance);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return ElevatedButton(
      onPressed: () async {
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        );
        _loadBalance();
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
              l10n.walletBalance(_balance.toString()),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white70),
        ],
      ),
    );
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _balance = 0;
  int _streak = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await WalletApi.getBalance();
      if (mounted) {
        setState(() {
          _balance = data.balance;
          _streak = data.dailyRewardStreak;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            Text(l10n.walletBalance(_balance.toString())),
          ],
        ),
      ),
      backgroundColor: palette.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ThreeActions(onReturn: _load),
                    16.vSpacing,
                    _DailyRewardCard(streak: _streak, onClaimed: _load),
                    16.vSpacing,
                  ],
                ),
              ),
            ),
    );
  }
}

class _ThreeActions extends StatelessWidget {
  const _ThreeActions({required this.onReturn});

  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: _ActionBlock(label: l10n.walletTransfer, icon: Icons.send, onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransferScreen()));
          onReturn();
        })),
        10.hSpacing,
        Expanded(child: _ActionBlock(label: l10n.walletStore, icon: Icons.storefront, onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoreScreen()));
          onReturn();
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
  const _DailyRewardCard({required this.streak, required this.onClaimed});

  final int streak;
  final VoidCallback onClaimed;

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
      builder: (_) => RewardSheet(parentContext: context, streak: streak, onClaimed: onClaimed),
    );
  }
}
