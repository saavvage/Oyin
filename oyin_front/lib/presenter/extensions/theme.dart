import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.primary,
    required this.primaryDarker,
    required this.accent,
    required this.muted,
    required this.badge,
    required this.danger,
    required this.success,
    required this.iconMuted,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color primary;
  final Color primaryDarker;
  final Color accent;
  final Color muted;
  final Color badge;
  final Color danger;
  final Color success;
  final Color iconMuted;
}

const AppPalette appPalette = AppPalette(
  background: Color(0xFF0D2219),
  surface: Color(0xFF112C22),
  card: Color(0xFF0F251D),
  primary: Color(0xFF11D16E),
  primaryDarker: Color(0xFF0FB15C),
  accent: Color(0xFF1E3B2F),
  muted: Color(0xFF9BB4A8),
  badge: Color(0xFF1A2F24),
  danger: Color(0xFFE8656A),
  success: Color(0xFF13D76C),
  iconMuted: Color(0xFF577366),
);

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: appPalette.background,
        primaryColor: appPalette.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appPalette.primary,
          brightness: Brightness.dark,
          background: appPalette.background,
          primary: appPalette.primary,
          secondary: appPalette.primaryDarker,
        ),
        textTheme: Typography.whiteMountainView.copyWith(
          titleLarge: const TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
          titleMedium: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          titleSmall: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          bodyLarge: const TextStyle(fontSize: 16),
          bodyMedium: const TextStyle(fontSize: 14),
          bodySmall: const TextStyle(fontSize: 12),
          labelLarge: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: appPalette.accent,
          selectedColor: appPalette.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}

extension PaletteContext on BuildContext {
  AppPalette get palette => appPalette;
}
