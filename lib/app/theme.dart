import 'package:flutter/material.dart';

/// Global reference to application colors.
abstract class AppColors {
  /// Background color.
  static const background = Colors.black;

  /// Grey background accent.
  static const grey = Color(0xFF262626);

  /// Primary text color
  static const primaryText = Colors.white;

  /// Accent Color.
  static const accent = Color(0xFF0094F5);

  /// Color to use for favorite icons (indicating a like).
  static const like = Colors.red;

  /// Color of secondary/faded text.
  static const fadedText = Colors.grey;

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

  /// A faded text style. Uses [AppColors.fadedText].
  static const textStyleFaded = TextStyle(color: AppColors.fadedText);

  /// Light text style.
  static const textStyleLight = TextStyle(fontWeight: FontWeight.w300);

  /// Action text
  static const textStyleAction = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
}

/// Global reference to the application theme.
abstract class AppTheme {
  /// Dark theme and its settings.
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.accent,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          AppColors.primaryText,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          AppColors.accent,
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: AppColors.accent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    brightness: Brightness.dark,
    accentColor: AppColors.accent,
  );
}
