import 'package:flutter/material.dart';

import '../presenter/extensions/theme.dart';
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
      home: const NavShell(),
    );
  }
}
