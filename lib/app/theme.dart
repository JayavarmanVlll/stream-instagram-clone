import 'package:flutter/material.dart';

/// Global reference to application colors.
abstract class AppColors {
  /// Background color.
  static const backgroundColor = Colors.black;

  /// Primary text color
  static const primaryTextColor = Colors.white;

  /// Accent Color.
  static const accentColor = Colors.blue;

  /// Color to use for favorite icons (indicating a like).
  static const likeColor = Colors.red;

  /// Color of secondary/faded text.
  static const fadedTextColor = Colors.grey;

  /// Top gradient color used in various UI components.
  static const topGradient = Color(0xFFE60064);

  /// Bottom gradient color used in various UI components.
  static const bottomGradient = Color(0xFFFFB344);
}

/// Global reference to application [TextStyle]s.
abstract class AppTextStyle {
  /// A bold text style.
  static const textStyleBold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  /// A faded text style. Uses [AppColors.fadedTextColor].
  static const textStyleFaded = TextStyle(color: AppColors.fadedTextColor);

  /// Light text style.
  static const textStyleLight = TextStyle(fontWeight: FontWeight.w300);

  /// Action text
  static const textStyleAction = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.accentColor,
  );
}

/// Global reference to the application theme.
abstract class AppTheme {
  /// Dark theme and its settings.
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: AppColors.backgroundColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    brightness: Brightness.dark,
    accentColor: AppColors.accentColor,
  );
}
