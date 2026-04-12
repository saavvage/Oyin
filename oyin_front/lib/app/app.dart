import 'package:flutter/material.dart';

import '../infrastructure/export.dart';
import '../presenter/extensions/theme.dart';
import '../presenter/screens/guest/auth_entry/auth_entry_screen.dart';
import '../presenter/screens/private/navbar/nav_shell.dart';
import 'navigation/app_route_observer.dart';
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
  bool _isResolvingSession = false;

  @override
  void initState() {
    super.initState();
    SessionStorage.sessionVersion.addListener(_onSessionChanged);
    _resolveSession();
  }

  @override
  void dispose() {
    SessionStorage.sessionVersion.removeListener(_onSessionChanged);
    super.dispose();
  }

  Future<void> _resolveSession() async {
    if (_isResolvingSession) return;
    _isResolvingSession = true;
    try {
      final token = await SessionStorage.getAccessToken();
      final savedLocale = await SessionStorage.getLocale();
      if (token != null && token.isNotEmpty) {
        await PushNotificationsService.syncTokenWithBackend();
        LocationService.syncLocationWithBackend(); // fire and forget
      }
      if (!mounted) return;
      setState(() {
        _isAuthorized = token != null && token.isNotEmpty;
        _isSessionReady = true;
        if (savedLocale != null && savedLocale.isNotEmpty) {
          final locale = Locale(savedLocale);
          if (AppLocalizations.supportedLocales.contains(locale)) {
            _locale = locale;
          }
        }
      });
    } finally {
      _isResolvingSession = false;
    }
  }

  void _onSessionChanged() {
    _resolveSession();
  }

  void setLocale(Locale locale) {
    if (AppLocalizations.supportedLocales.contains(locale)) {
      setState(() => _locale = locale);
      SessionStorage.setLocale(locale.languageCode);
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
      navigatorObservers: [appRouteObserver],
      home: !_isSessionReady
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (_isAuthorized ? const NavShell() : const AuthEntryScreen()),
    );
  }
}
