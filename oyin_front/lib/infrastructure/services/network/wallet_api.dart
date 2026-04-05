import 'api_client.dart';
import 'api_endpoints.dart';

class WalletBalanceDto {
  const WalletBalanceDto({
    required this.balance,
    required this.dailyRewardStreak,
    required this.lastDailyRewardAt,
  });

  final int balance;
  final int dailyRewardStreak;
  final String? lastDailyRewardAt;

  factory WalletBalanceDto.fromMap(Map<String, dynamic> map) {
    return WalletBalanceDto(
      balance: (map['balance'] as num?)?.toInt() ?? 0,
      dailyRewardStreak: (map['dailyRewardStreak'] as num?)?.toInt() ?? 0,
      lastDailyRewardAt: map['lastDailyRewardAt']?.toString(),
    );
  }
}

class StoreItemDto {
  const StoreItemDto({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final int price;

  factory StoreItemDto.fromMap(Map<String, dynamic> map) {
    return StoreItemDto(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      price: (map['price'] as num?)?.toInt() ?? 0,
    );
  }
}

class TransactionDto {
  const TransactionDto({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String type;
  final int amount;
  final int balanceAfter;
  final String description;
  final String createdAt;

  factory TransactionDto.fromMap(Map<String, dynamic> map) {
    return TransactionDto(
      id: (map['id'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      amount: (map['amount'] as num?)?.toInt() ?? 0,
      balanceAfter: (map['balanceAfter'] as num?)?.toInt() ?? 0,
      description: (map['description'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
    );
  }
}

class WalletApi {
  static Future<WalletBalanceDto> getBalance() async {
    final data = await ApiClient.instance.get(ApiEndpoints.walletBalance);
    return WalletBalanceDto.fromMap((data as Map).cast<String, dynamic>());
  }

  static Future<Map<String, dynamic>> claimDailyReward() async {
    final data = await ApiClient.instance.post(ApiEndpoints.walletDailyReward);
    return (data as Map).cast<String, dynamic>();
  }

  static Future<Map<String, dynamic>> transfer({
    required String phone,
    required int amount,
  }) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.walletTransfer,
      data: {'phone': phone, 'amount': amount},
    );
    return (data as Map).cast<String, dynamic>();
  }

  static Future<List<StoreItemDto>> getStoreItems() async {
    final data = await ApiClient.instance.get(ApiEndpoints.walletStore);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => StoreItemDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }

  static Future<Map<String, dynamic>> buyItem(String itemId) async {
    final data = await ApiClient.instance.post(
      ApiEndpoints.walletStoreBuy,
      data: {'itemId': itemId},
    );
    return (data as Map).cast<String, dynamic>();
  }

  static Future<List<TransactionDto>> getHistory() async {
    final data = await ApiClient.instance.get(ApiEndpoints.walletHistory);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => TransactionDto.fromMap(item.cast<String, dynamic>()))
        .toList();
  }
}
