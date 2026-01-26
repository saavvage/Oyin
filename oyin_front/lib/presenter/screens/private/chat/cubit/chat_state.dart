class ChatCard {
  const ChatCard({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.status,
    required this.timestamp,
    this.badgeCount,
    this.accent,
    this.highlight,
    this.buttonLabel,
  });

  final String name;
  final String subtitle;
  final String avatarUrl;
  final String status;
  final String timestamp;
  final int? badgeCount;
  final String? accent;
  final bool? highlight;
  final String? buttonLabel;
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
