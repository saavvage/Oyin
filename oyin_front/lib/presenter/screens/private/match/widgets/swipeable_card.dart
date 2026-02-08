import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../domain/export.dart';
import '../../../../extensions/_export.dart';
import 'profile_card.dart';

class SwipeController {
  VoidCallback? _swipeLeft;
  VoidCallback? _swipeRight;

  void _bind({
    required VoidCallback swipeLeft,
    required VoidCallback swipeRight,
  }) {
    _swipeLeft = swipeLeft;
    _swipeRight = swipeRight;
  }

  void _unbind() {
    _swipeLeft = null;
    _swipeRight = null;
  }

  void swipeLeft() => _swipeLeft?.call();
  void swipeRight() => _swipeRight?.call();
}

class SwipeableMatchCard extends StatefulWidget {
  const SwipeableMatchCard({
    super.key,
    required this.profile,
    required this.l10n,
    required this.onLike,
    required this.onDislike,
    required this.onOpenDetails,
    required this.controller,
  });

  final MatchProfile profile;
  final AppLocalizations l10n;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onOpenDetails;
  final SwipeController controller;

  @override
  State<SwipeableMatchCard> createState() => _SwipeableMatchCardState();
}

class _SwipeableMatchCardState extends State<SwipeableMatchCard> with SingleTickerProviderStateMixin {
  static const double _swipeThreshold = 140;

  Offset _dragOffset = Offset.zero;
  Size _cardSize = Size.zero;
  late final AnimationController _controller;
  Animation<Offset>? _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(_handleTick);
    widget.controller._bind(
      swipeLeft: () => _triggerSwipe(isRight: false),
      swipeRight: () => _triggerSwipe(isRight: true),
    );
  }

  @override
  void didUpdateWidget(covariant SwipeableMatchCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._unbind();
      widget.controller._bind(
        swipeLeft: () => _triggerSwipe(isRight: false),
        swipeRight: () => _triggerSwipe(isRight: true),
      );
    }
    if (oldWidget.profile.id != widget.profile.id) {
      _dragOffset = Offset.zero;
      _animation = null;
      _isAnimating = false;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    widget.controller._unbind();
    _controller
      ..removeListener(_handleTick)
      ..dispose();
    super.dispose();
  }

  void _handleTick() {
    if (_animation == null) return;
    setState(() {
      _dragOffset = _animation!.value;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;
    if (_dragOffset.dx.abs() > _swipeThreshold) {
      _triggerSwipe(isRight: _dragOffset.dx > 0);
      return;
    }
    _animateTo(Offset.zero);
  }

  void _triggerSwipe({required bool isRight}) {
    if (_isAnimating || _cardSize == Size.zero) return;
    final distance = _cardSize.width + 200;
    final target = Offset(isRight ? distance : -distance, _dragOffset.dy);
    _animateTo(
      target,
      onCompleted: () {
        if (isRight) {
          widget.onLike();
        } else {
          widget.onDislike();
        }
      },
    );
  }

  void _animateTo(Offset target, {VoidCallback? onCompleted}) {
    _isAnimating = true;
    _animation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0).whenComplete(() {
      _isAnimating = false;
      _animation = null;
      if (onCompleted != null) {
        onCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _cardSize = Size(constraints.maxWidth, constraints.maxHeight);
        final dx = _dragOffset.dx;
        final rotation = _cardSize.width == 0 ? 0.0 : (dx / _cardSize.width) * 0.08;
        final progress = (_dragOffset.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
        final isLike = dx > 0;
        final overlayColor = isLike ? Colors.greenAccent : Colors.redAccent;
        final overlayIcon = isLike ? Icons.check_circle : Icons.cancel;

        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: _dragOffset,
            child: Transform.rotate(
              angle: rotation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MatchProfileCard(
                    profile: widget.profile,
                    l10n: widget.l10n,
                    onInfoTap: widget.onOpenDetails,
                  ),
                  if (progress > 0)
                    Icon(
                      overlayIcon,
                      size: 84,
                      color: overlayColor.withOpacity(progress),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
