import 'package:flutter/material.dart';

class NavBarItem {
  const NavBarItem({
    required this.icon,
    required this.label,
    required this.cupertinoSymbol,
  });

  final IconData icon;
  final String label;
  final String cupertinoSymbol;
}
