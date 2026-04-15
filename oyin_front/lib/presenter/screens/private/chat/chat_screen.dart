import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../messanger/messanger_screen.dart';
import '../search/dispute_screen.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.isActive = false});

  final bool isActive;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit()..loadThreads();
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _cubit.loadThreads();
      if (_cubit.state.activeTab == 1) {
        _cubit.loadDisputes();
      }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _cubit, child: const _ChatView());
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  void _openChat(BuildContext context, ChatCard card) {
    if (card.buttonKey == 'resolve') {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => const DisputeScreen(preferJuryDuty: true),
        ),
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MessangerScreen(
          chatId: card.id,
          partnerName: card.name,
          partnerAvatarUrl: card.avatarUrl,
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteChat(BuildContext context, ChatCard card) async {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final cubit = context.read<ChatCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: palette.card,
        title: Text(l10n.messengerDialogDeleteTitle),
        content: Text(l10n.messengerDialogDeleteDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonYes),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return false;

    final deleted = await cubit.deleteThread(card.id);
    if (!deleted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.messengerSomethingWrong)),
      );
    }
    return deleted;
  }

  Widget _buildDeleteBackground(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildSwipeCard(
    BuildContext context,
    ChatCard card, {
    required String scope,
  }) {
    return Dismissible(
      key: ValueKey('${scope}_${card.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(context),
      confirmDismiss: (_) => _confirmDeleteChat(context, card),
      child: ChatListCard(card: card, onTap: () => _openChat(context, card)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatHeader(l10n: l10n),
                  14.vSpacing,
                  ChatSearchBar(placeholder: l10n.searchMatches),
                  12.vSpacing,
                  ChatTabBar(
                    activeIndex: state.activeTab,
                    tabs: [l10n.tabActiveMatches, l10n.tabDisputes],
                    onChanged: (i) => context.read<ChatCubit>().selectTab(i),
                  ),
                  16.vSpacing,
                  if (state.activeTab == 0) ...[
                    AiAssistantCard(l10n: l10n),
                    16.vSpacing,
                    Text(
                      l10n.actionRequired.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: palette.muted,
                      ),
                    ),
                    10.vSpacing,
                    ...state.actionRequired.map(
                      (card) => _buildSwipeCard(context, card, scope: 'action'),
                    ),
                    14.vSpacing,
                    Text(
                      l10n.upcoming.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: palette.muted,
                      ),
                    ),
                    10.vSpacing,
                    ...state.upcoming.map(
                      (card) =>
                          _buildSwipeCard(context, card, scope: 'upcoming'),
                    ),
                  ] else ...[
                    _DisputesTab(
                      myDisputes: state.myDisputes,
                      communityDisputes: state.communityDisputes,
                      isLoading: state.isLoadingDisputes,
                      noDisputesLabel: l10n.noDisputes,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DisputesTab extends StatelessWidget {
  const _DisputesTab({
    required this.myDisputes,
    required this.communityDisputes,
    required this.isLoading,
    required this.noDisputesLabel,
  });

  final List<DisputeDetailsDto> myDisputes;
  final List<DisputeDetailsDto> communityDisputes;
  final bool isLoading;
  final String noDisputesLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (myDisputes.isEmpty && communityDisputes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.gavel_rounded, size: 48, color: palette.muted),
              const SizedBox(height: 12),
              Text(
                noDisputesLabel,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: palette.muted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (myDisputes.isNotEmpty) ...[
          Text(
            AppLocalizations.of(context).myDisputes.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: palette.muted,
            ),
          ),
          const SizedBox(height: 10),
          ...myDisputes.map((d) => _DisputeCard(dispute: d)),
          const SizedBox(height: 8),
        ],
        if (communityDisputes.isNotEmpty) ...[
          Text(
            AppLocalizations.of(context).communityDisputes.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: palette.muted,
            ),
          ),
          const SizedBox(height: 10),
          ...communityDisputes.map((d) => _DisputeCard(dispute: d)),
        ],
      ],
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.dispute});

  final DisputeDetailsDto dispute;

  Color _statusColor(BuildContext context) {
    final palette = context.palette;
    switch (dispute.status) {
      case 'OPEN':
      case 'VOTING':
        return Colors.orangeAccent;
      case 'RESOLVED':
        return Colors.greenAccent;
      case 'CANCELLED':
        return palette.muted;
      default:
        return palette.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final statusColor = _statusColor(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => DisputeScreen(disputeId: dispute.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.badge),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.gavel_rounded, color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dispute.subject.isNotEmpty
                        ? dispute.subject
                        : 'Dispute #${dispute.displayId}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dispute.sport} • ${dispute.locationLabel}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusText(l10n),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(AppLocalizations l10n) {
    switch (dispute.status) {
      case 'OPEN':
      case 'VOTING':
        return l10n.statusDisputeOpen;
      case 'RESOLVED':
        return l10n.statusConfirmed;
      case 'CANCELLED':
        return l10n.statusPendingResult;
      default:
        return l10n.pending;
    }
  }
}
