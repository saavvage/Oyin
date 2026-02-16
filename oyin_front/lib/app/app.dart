import 'package:flutter/material.dart';

import '../infrastructure/export.dart';
import '../presenter/extensions/theme.dart';
import '../presenter/screens/guest/auth_entry/auth_entry_screen.dart';
import '../presenter/screens/private/navbar/nav_shell.dart';
import 'localization/app_localizations.dart';

class OyinApp extends StatefulWidget {
  const OyinApp({super.key});

  static _OyinAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_OyinAppState>()!;

  @override
  State<OyinApp> createState() => _OyinAppState();
}

class _OyinAppState extends State<OyinApp> {
  Locale _locale = AppLocalizations.supportedLocales.first;
  bool _isSessionReady = false;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _resolveSession();
  }

  Future<void> _resolveSession() async {
    final token = await SessionStorage.getAccessToken();
    final isGuest = await SessionStorage.getGuestMode();
    if (token != null && token.isNotEmpty) {
      await PushNotificationsService.syncTokenWithBackend();
    }
    if (!mounted) return;
    setState(() {
      _isAuthorized = isGuest || (token != null && token.isNotEmpty);
      _isSessionReady = true;
    });
  }

  void setLocale(Locale locale) {
    if (AppLocalizations.supportedLocales.contains(locale)) {
      setState(() => _locale = locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oyin',
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.dark,
      home: !_isSessionReady
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (_isAuthorized ? const NavShell() : const AuthEntryScreen()),
    );
  }
}
