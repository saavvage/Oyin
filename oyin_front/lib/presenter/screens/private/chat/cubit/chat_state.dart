import '../../../../../infrastructure/services/network/disputes_api.dart';

class ChatCard {
  const ChatCard({
    required this.id,
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

  final String id;
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
    this.myDisputes = const [],
    this.communityDisputes = const [],
    this.isLoadingDisputes = false,
  });

  final int activeTab; // 0 active, 1 disputes
  final List<ChatCard> actionRequired;
  final List<ChatCard> upcoming;
  final List<DisputeDetailsDto> myDisputes;
  final List<DisputeDetailsDto> communityDisputes;
  final bool isLoadingDisputes;

  List<DisputeDetailsDto> get disputes => [...myDisputes, ...communityDisputes];

  ChatState copyWith({
    int? activeTab,
    List<ChatCard>? actionRequired,
    List<ChatCard>? upcoming,
    List<DisputeDetailsDto>? myDisputes,
    List<DisputeDetailsDto>? communityDisputes,
    bool? isLoadingDisputes,
  }) => ChatState(
    activeTab: activeTab ?? this.activeTab,
    actionRequired: actionRequired ?? this.actionRequired,
    upcoming: upcoming ?? this.upcoming,
    myDisputes: myDisputes ?? this.myDisputes,
    communityDisputes: communityDisputes ?? this.communityDisputes,
    isLoadingDisputes: isLoadingDisputes ?? this.isLoadingDisputes,
  );
}
