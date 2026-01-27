import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../chat/chat_screen.dart';
import '../match/match_screen.dart';
import '../profile/profile_screen.dart';
import '../search/arena_screen.dart';
import 'liquid_navbar.dart';
import 'nav_item.dart';

class NavShell extends StatefulWidget {
  const NavShell({super.key});

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  int _index = 0;

  late final pages = [
    const MatchScreen(),
    const ArenaScreen(), 
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      NavBarItem(icon: Icons.style, label: l10n.navMatch, cupertinoSymbol: 'book.pages'),
      NavBarItem(icon: Icons.search, label: l10n.navSearch, cupertinoSymbol: 'magnifyingglass'),
      NavBarItem(icon: Icons.chat_bubble_outline, label: l10n.navChats, cupertinoSymbol: 'bubble.left'),
      NavBarItem(icon: Icons.person_outline, label: l10n.navProfile, cupertinoSymbol: 'person'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: AdaptiveNavBar(
        currentIndex: _index,
        items: items,
        onTap: (value) => setState(() => _index = value),
      ),
    );
  }
}
