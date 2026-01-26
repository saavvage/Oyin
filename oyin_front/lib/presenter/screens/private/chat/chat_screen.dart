import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
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
                    tabs: [l10n.tabActiveMatches, l10n.tabArchived],
                    onChanged: (i) => context.read<ChatCubit>().selectTab(i),
                  ),
                  16.vSpacing,
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
                    (card) => ChatListCard(
                      card: card,
                      onTap: () {},
                    ),
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
                    (card) => ChatListCard(
                      card: card,
                      onTap: () {},
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
