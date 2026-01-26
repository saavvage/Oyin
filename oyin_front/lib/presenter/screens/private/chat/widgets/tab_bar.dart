import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';
import '../../../../extensions/theme.dart';

class ChatTabBar extends StatelessWidget {
  const ChatTabBar({
    super.key,
    required this.activeIndex,
    required this.onChanged,
    required this.tabs,
  });

  final int activeIndex;
  final List<String> tabs;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: i == activeIndex ? palette.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: i == activeIndex ? Colors.white : palette.muted,
                        ),
                  ),
                ),
              ),
            ),
            if (i != tabs.length - 1) 8.hSpacing,
          ],
        ],
      ),
    );
  }
}
