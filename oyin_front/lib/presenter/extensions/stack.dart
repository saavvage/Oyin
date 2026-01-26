import 'package:flutter/widgets.dart';

extension StackPositionedExtension on Widget {
  Positioned positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      Positioned(
        key: key,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: this,
      );

  Positioned positionedFill({
    Key? key,
    EdgeInsetsGeometry? padding,
  }) =>
      padding == null
          ? Positioned.fill(
              key: key,
              child: this,
            )
          : Positioned.fill(
              key: key,
              child: Padding(
                padding: padding,
                child: this,
              ),
            );
}

extension StackChildrenExtension on List<Widget> {
  Stack toStack({
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) =>
      Stack(
        alignment: alignment,
        fit: fit,
        clipBehavior: clipBehavior,
        children: this,
      );
}
