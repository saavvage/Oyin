import 'package:flutter/material.dart';

import '../../../../app/navigation/app_route_observer.dart';
import '../../../../app/localization/app_localizations.dart';
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

class _NavShellState extends State<NavShell> with RouteAware {
  int _index = 0;
  bool _showNavBar = true;
  PageRoute<dynamic>? _route;

  late final pages = [
    const MatchScreen(),
    const ArenaScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is! PageRoute<dynamic>) {
      return;
    }
    if (_route == modalRoute) {
      return;
    }
    if (_route != null) {
      appRouteObserver.unsubscribe(this);
    }
    _route = modalRoute;
    appRouteObserver.subscribe(this, modalRoute);
    _showNavBar = modalRoute.isCurrent;
  }

  @override
  void dispose() {
    if (_route != null) {
      appRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPushNext() {
    if (!mounted || !_showNavBar) return;
    setState(() => _showNavBar = false);
  }

  @override
  void didPopNext() {
    if (!mounted || _showNavBar) return;
    setState(() => _showNavBar = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      NavBarItem(
        icon: Icons.style,
        label: l10n.navMatch,
        cupertinoSymbol: 'book.pages',
      ),
      NavBarItem(
        icon: Icons.search,
        label: l10n.navSearch,
        cupertinoSymbol: 'magnifyingglass',
      ),
      NavBarItem(
        icon: Icons.chat_bubble_outline,
        label: l10n.navChats,
        cupertinoSymbol: 'bubble.left',
      ),
      NavBarItem(
        icon: Icons.person_outline,
        label: l10n.navProfile,
        cupertinoSymbol: 'person',
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _showNavBar
          ? AdaptiveNavBar(
              currentIndex: _index,
              items: items,
              onTap: (value) => setState(() => _index = value),
            )
          : null,
    );
  }
}
