import 'package:flutter/material.dart';

import '../../extensions/theme.dart';

class PulsePreloader extends StatefulWidget {
  const PulsePreloader({
    super.key,
    this.imageUrl,
    this.size = 72,
  });

  final String? imageUrl;
  final double size;

  @override
  State<PulsePreloader> createState() => _PulsePreloaderState();
}

class _PulsePreloaderState extends State<PulsePreloader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildPulse(palette, 0.0),
            _buildPulse(palette, 0.5),
            _buildAvatar(palette),
          ],
        );
      },
    );
  }

  Widget _buildPulse(AppPalette palette, double delay) {
    final t = (_controller.value + delay) % 1.0;
    final scale = 0.6 + (t * 1.2);
    final opacity = (1 - t) * 0.35;

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AppPalette palette) {
    final imageUrl = widget.imageUrl;
    return CircleAvatar(
      radius: widget.size / 2,
      backgroundColor: palette.surface,
      backgroundImage: imageUrl == null || imageUrl.isEmpty ? null : NetworkImage(imageUrl),
      child: imageUrl == null || imageUrl.isEmpty
          ? const Icon(Icons.person, color: Colors.white)
          : null,
    );
  }
}
