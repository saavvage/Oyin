import 'package:flutter/material.dart';

import '../../../extensions/_export.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/app.dart';
import '../../../utils/phone_mask.dart';
import '../login/phone_screen.dart';

class AuthEntryScreen extends StatelessWidget {
  const AuthEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _brandBadge(context),
                  const Spacer(),
                  _LanguageMenuButton(),
                  12.hSpacing,
                  Icon(Icons.help_outline, color: context.palette.muted),
                ],
              ),
              24.vSpacing,
              _heroCard(context, l10n),
              24.vSpacing,
              Text(
                l10n.onboardingTitle,
                style: Theme.of(context).textTheme.titleLarge?.colored(Colors.white),
              ),
              12.vSpacing,
              Text(
                l10n.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.colored(context.palette.muted),
              ),
              const Spacer(),
              _PrimaryButton(
                label: l10n.getStarted,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
                  );
                },
              ),
              12.vSpacing,
              _SecondaryButton(
                label: l10n.logIn,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
                  );
                },
              ),
              16.vSpacing,
              Text(
                l10n.termsAgree,
                style: Theme.of(context).textTheme.bodySmall?.colored(context.palette.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.palette.badge,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.sports_mma, color: context.palette.primary),
          8.hSpacing,
          Text(
            'Oyin',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.colored(Colors.white)
                .weighted(FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _heroCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF123928), Color(0xFF0C1F18)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -12,
            child: Icon(
              Icons.sports_mma,
              size: 220,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_alt_rounded, color: Colors.white),
                    8.hSpacing,
                    Text(
                      l10n.findPartners,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.colored(Colors.white)
                          .weighted(FontWeight.w800),
                    ),
                  ],
                ),
                10.vSpacing,
                Text(
                  l10n.onboardingSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.colored(Colors.white70),
                ),
                const Spacer(),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _pill(context, l10n.nearby),
                    _pill(context, l10n.skills),
                    _pill(context, l10n.timeMatch),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.palette.badge,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.colored(Colors.white),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.palette.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.weighted(FontWeight.w700),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: context.palette.primary.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

class _LanguageMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeCode = Localizations.localeOf(context).languageCode.toUpperCase();
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.badge),
      ),
      child: PopupMenuButton<Locale>(
        tooltip: 'Language',
        onSelected: (locale) => OyinApp.of(context).setLocale(locale),
        color: palette.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        itemBuilder: (context) => [
          _item(const Locale('en'), '🇬🇧', 'English', context),
          _item(const Locale('ru'), '🇷🇺', 'Русский', context),
          _item(const Locale('kk'), '🇰🇿', 'Қазақша', context),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.language, color: Colors.white),
              6.hSpacing,
              Text(
                localeCode,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<Locale> _item(Locale locale, String flag, String name, BuildContext context) {
    final isSelected = Localizations.localeOf(context).languageCode == locale.languageCode;
    final palette = context.palette;
    return PopupMenuItem(
      value: locale,
      child: Row(
        children: [
          Text(flag),
          8.hSpacing,
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
          const Spacer(),
          if (isSelected) Icon(Icons.check, color: palette.primary),
        ],
      ),
    );
  }
}
