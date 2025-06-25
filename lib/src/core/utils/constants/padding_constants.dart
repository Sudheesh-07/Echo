import 'package:flutter/material.dart';


/// This class contains padding constants which will help to have constant 
/// paddings through ou the project
class PaddingConstants {
  // Original constants (immutable)
  ///This is the most small padding used for padding between 
  ///letters or small widgets
  static const EdgeInsets small = EdgeInsets.all(8);
  /// This is the most used padding used for padding between widgets
  static const EdgeInsets medium = EdgeInsets.all(16);
  /// This is padding is used for the constant padding between huge widgets
  static const EdgeInsets large = EdgeInsets.all(24);
  /// This padding is used for the default padding of the button and widgets
  static const EdgeInsets defaultPadding = EdgeInsets.only(left:24,right: 24);
}

/// Extension to add .copyWith() to EdgeInsets constants
extension EdgeInsetsCopyWith on EdgeInsets {
  /// Extension to add .copyWith() to EdgeInsets constants 
  /// This helps to customize the padding whenever needed
  EdgeInsets copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => EdgeInsets.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
}
