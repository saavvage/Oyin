import 'package:flutter/material.dart';

import '../../extensions/theme.dart';

class AppPreloader extends StatelessWidget {
  const AppPreloader({
    super.key,
    this.size = 32,
    this.strokeWidth = 3,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? context.palette.primary;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      ),
    );
  }
}
