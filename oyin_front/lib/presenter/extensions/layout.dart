import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

extension LayoutWidgetExtension on Widget {
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  Widget center() => Center(child: this);

  Widget aligned([Alignment alignment = Alignment.center]) => Align(
        alignment: alignment,
        child: this,
      );

  Widget expanded([int flex = 1]) => Expanded(
        flex: flex,
        child: this,
      );

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) =>
      Flexible(
        flex: flex,
        fit: fit,
        child: this,
      );

  Widget sized({
    double? width,
    double? height,
  }) =>
      SizedBox(
        width: width,
        height: height,
        child: this,
      );

  Widget withConstraints({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: this,
      );

  Widget withMargin(EdgeInsetsGeometry margin) => Container(
        margin: margin,
        child: this,
      );

  Widget withSafeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) =>
      SafeArea(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        minimum: minimum,
        maintainBottomViewPadding: maintainBottomViewPadding,
        child: this,
      );

  Widget scrollable({
    Axis axis = Axis.vertical,
    EdgeInsetsGeometry? padding,
    bool? primary,
    bool reverse = false,
    ScrollPhysics? physics,
    Clip clipBehavior = Clip.hardEdge,
    String? restorationId,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) =>
      SingleChildScrollView(
        scrollDirection: axis,
        padding: padding,
        primary: primary,
        reverse: reverse,
        physics: physics,
        clipBehavior: clipBehavior,
        restorationId: restorationId,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        child: this,
      );

  Widget opacity(
    double value, {
    bool alwaysIncludeSemantics = false,
  }) =>
      Opacity(
        opacity: value,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: this,
      );

  Widget visible(
    bool isVisible, {
    Widget replacement = const SizedBox.shrink(),
    bool maintainState = false,
    bool maintainAnimation = false,
    bool maintainSize = false,
  }) =>
      Visibility(
        visible: isVisible,
        maintainState: maintainState,
        maintainAnimation: maintainAnimation,
        maintainSize: maintainSize,
        replacement: replacement,
        child: this,
      );
}

extension LayoutSpacingExtension on num {
  SizedBox get vSpacing => SizedBox(height: toDouble());

  SizedBox get hSpacing => SizedBox(width: toDouble());

  SizedBox get squareSpacing => SizedBox.square(dimension: toDouble());
}
