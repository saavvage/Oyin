import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension StringTextExtension on String {
  Text text({
    Key? key,
    TextStyle? style,
    TextAlign? align,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    StrutStyle? strutStyle,
  }) =>
      Text(
        this,
        key: key,
        style: style,
        textAlign: align,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        strutStyle: strutStyle,
      );

  SelectableText selectableText({
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    StrutStyle? strutStyle,
    TextSelectionControls? selectionControls,
  }) =>
      SelectableText(
        this,
        key: key,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        strutStyle: strutStyle,
        selectionControls: selectionControls,
      );

  TextSpan span({
    TextStyle? style,
    List<InlineSpan> children = const [],
    GestureRecognizer? recognizer,
  }) =>
      TextSpan(
        text: this,
        style: style,
        children: children,
        recognizer: recognizer,
      );
}

extension InlineSpanListExtension on List<InlineSpan> {
  RichText rich({
    Key? key,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    int? maxLines,
    StrutStyle? strutStyle,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior? textHeightBehavior,
  }) =>
      RichText(
        key: key,
        textAlign: textAlign,
        textDirection: textDirection,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        text: TextSpan(children: this),
      );
}

extension TextStyleTweaks on TextStyle {
  TextStyle colored(Color color) => copyWith(color: color);

  TextStyle weighted(FontWeight fontWeight) => copyWith(fontWeight: fontWeight);

  TextStyle sized(double size) => copyWith(fontSize: size);

  TextStyle spaced(double letterSpacing) =>
      copyWith(letterSpacing: letterSpacing);

  TextStyle withHeight(double height) => copyWith(height: height);
}
