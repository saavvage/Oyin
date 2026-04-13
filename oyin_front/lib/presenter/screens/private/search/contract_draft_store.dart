class ContractDraft {
  const ContractDraft({
    required this.dateTime,
    required this.location,
    required this.reminder,
    required this.acceptedCode,
    required this.confirmed,
  });

  final DateTime? dateTime;
  final String location;
  final bool reminder;
  final bool acceptedCode;
  final bool confirmed;

  ContractDraft copyWith({
    DateTime? dateTime,
    String? location,
    bool? reminder,
    bool? acceptedCode,
    bool? confirmed,
  }) {
    return ContractDraft(
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      reminder: reminder ?? this.reminder,
      acceptedCode: acceptedCode ?? this.acceptedCode,
      confirmed: confirmed ?? this.confirmed,
    );
  }
}

class ContractDraftStore {
  ContractDraftStore._();

  static final Map<String, ContractDraft> _cache = {};

  static ContractDraft? get(String gameId) => _cache[gameId];

  static void save(String gameId, ContractDraft draft) {
    _cache[gameId] = draft;
  }

  static void clear(String gameId) {
    _cache.remove(gameId);
  }
}
