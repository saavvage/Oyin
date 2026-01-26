import 'package:flutter/material.dart';

import '../../../../extensions/theme.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({
    super.key,
    required this.placeholder,
  });

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: palette.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
