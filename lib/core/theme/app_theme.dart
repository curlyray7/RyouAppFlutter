import 'package:flutter/material.dart';

import '../../shared/models/mood.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(
    Brightness.light,
    AppPalette.light,
    AppMoodPalettes.light,
    onError: const Color(0xFFFFFFFF),
  );

  static ThemeData dark() => _build(
    Brightness.dark,
    AppPalette.dark,
    AppMoodPalettes.dark,
    onError: AppPalette.dark.onPrimary,
  );

  static ThemeData _build(
    Brightness brightness,
    AppPalette p,
    Map<Mood, MoodPalette> moods, {
    required Color onError,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      error: p.error,
      onError: onError,
      errorContainer: p.errorContainer,
      surface: p.surface,
      onSurface: p.onSurface,
      onSurfaceVariant: p.onSurfaceVariant,
      // Cartes, champs, tab bar : Surface. Boutons secondaires : Surface variant.
      surfaceContainerLowest: p.surface,
      surfaceContainerLow: p.surface,
      surfaceContainer: p.surface,
      surfaceContainerHigh: p.surfaceVariant,
      surfaceContainerHighest: p.surfaceVariant,
      // Material : outline pour les contours de champs, outlineVariant pour les séparateurs.
      outline: p.outlineStrong,
      outlineVariant: p.outline,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      // Champs de formulaire : blancs sur fond crème, rayon md (18).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: _fieldBorder(p.outlineStrong),
        enabledBorder: _fieldBorder(p.outlineStrong),
        focusedBorder: _fieldBorder(p.primary, width: 2),
        errorBorder: _fieldBorder(p.error),
        focusedErrorBorder: _fieldBorder(p.error, width: 2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
      ),
      extensions: [
        RyouColors(primaryInk: p.primaryInk, success: p.success),
        MoodColors(moods),
      ],
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
}


