import 'dart:io';

import 'package:cupertino_native/cupertino_native.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'frosted_navbar.dart';
import 'nav_item.dart';

enum _NavPresentation { cupertino, frosted }

class AdaptiveNavBar extends StatefulWidget {
  const AdaptiveNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItem> items;

  @override
  State<AdaptiveNavBar> createState() => _AdaptiveNavBarState();
}

class _AdaptiveNavBarState extends State<AdaptiveNavBar> {
  // Keep native CNTabBar only for iOS 26+, fallback to Flutter bar below that.
  static const int _liquidGlassSupportedIOSMajorVersion = 26;

  late final Future<_NavPresentation> _navPresentationFuture =
      _detectPresentation();

  Future<_NavPresentation> _detectPresentation() async {
    if (kIsWeb || !Platform.isIOS) {
      return _NavPresentation.frosted;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final info = await deviceInfo.iosInfo;
      final version = info.systemVersion.split('.').first;
      final majorVersion = int.tryParse(version) ?? 0;

      if (majorVersion >= _liquidGlassSupportedIOSMajorVersion) {
        return _NavPresentation.cupertino;
      }
    } catch (_) {
      // Fall back to frosted bar if iOS version detection fails.
    }

    return _NavPresentation.frosted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_NavPresentation>(
      future: _navPresentationFuture,
      builder: (context, snapshot) {
        final navType = snapshot.data ?? _NavPresentation.frosted;

        if (navType == _NavPresentation.cupertino) {
          return SafeArea(
            top: false,
            bottom: false,
            minimum: EdgeInsets.zero,
            child: CNTabBar(
              currentIndex: widget.currentIndex,
              onTap: widget.onTap,
              backgroundColor: Colors.transparent,
              items: [
                for (final item in widget.items)
                  CNTabBarItem(
                    label: item.label,
                    icon: CNSymbol(item.cupertinoSymbol),
                  ),
              ],
            ),
          );
        }

        return FrostedNavBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          items: widget.items,
        );
      },
    );
  }
}
