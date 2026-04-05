import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/services/network/wallet_api.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionDto> _transactions = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await WalletApi.getHistory();
      if (mounted) setState(() { _transactions = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletHistory)),
      backgroundColor: palette.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(
                  child: Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.muted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _transactions.length,
                  itemBuilder: (_, i) {
                    final tx = _transactions[i];
                    final isPositive = tx.amount > 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isPositive ? Colors.greenAccent : Colors.redAccent,
                              size: 20,
                            ),
                            10.hSpacing,
                            Expanded(
                              child: Text(
                                tx.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${isPositive ? "+" : ""}${tx.amount}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isPositive ? Colors.greenAccent : Colors.redAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
