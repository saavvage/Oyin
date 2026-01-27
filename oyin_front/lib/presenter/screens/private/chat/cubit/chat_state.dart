class ChatCard {
  const ChatCard({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.statusKey,
    required this.timestamp,
    this.badgeCount,
    this.accent,
    this.highlight,
    this.buttonKey,
  });

  final String name;
  final String subtitle;
  final String avatarUrl;
  final String statusKey;
  final String timestamp;
  final int? badgeCount;
  final String? accent;
  final bool? highlight;
  final String? buttonKey;
}

class ChatState {
  const ChatState({
    required this.activeTab,
    required this.actionRequired,
    required this.upcoming,
  });

  final int activeTab; // 0 active, 1 archived
  final List<ChatCard> actionRequired;
  final List<ChatCard> upcoming;

  ChatState copyWith({
    int? activeTab,
    List<ChatCard>? actionRequired,
    List<ChatCard>? upcoming,
  }) =>
      ChatState(
        activeTab: activeTab ?? this.activeTab,
        actionRequired: actionRequired ?? this.actionRequired,
        upcoming: upcoming ?? this.upcoming,
      );
}
