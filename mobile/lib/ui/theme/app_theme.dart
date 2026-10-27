import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    scaffoldBackground: const Color(0xff15112b),
    appBarBackground: const Color(0xff15112b),
    // Playground built-in scheme made with FlexSchemeColor.from() API.
    colors: FlexSchemeColor.from(
      primary: const Color(0xFF1145A4),
      secondary: const Color(0xFFB61D1D),
      tertiary: Colors.deepPurpleAccent,
      brightness: Brightness.light,
      swapOnMaterial3: true,
    ),
    // Component theme configurations for light mode.
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      textButtonRadius: 4,
      filledButtonRadius: 4,
      elevatedButtonRadius: 4,
      outlinedButtonRadius: 4,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabUseShape: true,
      fabAlwaysCircular: true,
      alignedDropdown: true,
      dialogRadius: 8,
      appBarCenterTitle: true,
      drawerIndicatorRadius: 4,
      drawerIndicatorSchemeColor: SchemeColor.primaryContainer,
      navigationRailUseIndicator: true,
      filledButtonSchemeColor: SchemeColor.tertiary,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Playground built-in scheme made with FlexSchemeColor.from() API
    // The input FlexSchemeColor is identical to light mode, but uses
    // default Error and toDark() methods to convert it to a dark theme.
    colors: FlexSchemeColor.from(
      primary: const Color(0xFF1145A4),
      secondary: const Color(0xFFB61D1D),
      tertiary: Colors.deepPurpleAccent,
      brightness: Brightness.light,
      swapOnMaterial3: true,
    ).defaultError.toDark(30, true),
    // Component theme configurations for dark mode.
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      textButtonRadius: 4,
      filledButtonRadius: 4,
      elevatedButtonRadius: 4,
      outlinedButtonRadius: 4,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabUseShape: true,
      fabAlwaysCircular: true,
      alignedDropdown: true,
      dialogRadius: 8,
      appBarCenterTitle: true,
      drawerIndicatorRadius: 4,
      drawerIndicatorSchemeColor: SchemeColor.primaryContainer,
      navigationRailUseIndicator: true,
      filledButtonSchemeColor: SchemeColor.tertiary,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
