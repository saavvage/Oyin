import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/services/network/wallet_api.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<StoreItemDto> _items = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await WalletApi.getStoreItems();
      if (mounted) setState(() { _items = items; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _buy(StoreItemDto item) async {
    final l10n = AppLocalizations.of(context);
    try {
      await WalletApi.buyItem(item.id);
      if (!mounted) return;
      AppNotifier.showMessage(
        context,
        l10n.itemPurchased(item.name),
        title: l10n.notifTitleSuccess,
        type: AppNotificationType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppNotifier.showMessage(
        context,
        e.toString(),
        title: l10n.notifTitleWarning,
        type: AppNotificationType.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletStore)),
      backgroundColor: palette.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final item = _items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      title: Text(item.name),
                      subtitle: Text('${item.price} ${AppLocalizations.of(context).coinsLabel}'),
                      trailing: ElevatedButton(
                        onPressed: () => _buy(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
