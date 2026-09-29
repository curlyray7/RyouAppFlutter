import 'package:flutter/material.dart';

import '../../shared/models/mood.dart';

/// Palette brute, recopiée de `assets/tokens/ryou_tokens.json`.
/// Les widgets ne l'utilisent pas directement : ils passent par le thème,
/// qui choisit automatiquement la version claire ou sombre.
///
/// Exemple :
/// ```dart
/// // Non : couleur figée, ignore le mode sombre.
/// Container(color: AppPalette.light.surface);
///
/// // Oui : passe par le thème.
/// final colors = Theme.of(context).colorScheme;
/// Container(color: colors.surface);
/// Text('Salut', style: TextStyle(color: colors.onSurfaceVariant));
/// ```
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryInk,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineStrong,
    required this.error,
    required this.errorContainer,
    required this.success,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryInk;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineStrong;
  final Color error;
  final Color errorContainer;
  final Color success;

  static const light = AppPalette(
    primary: Color(0xFFE8420A),
    onPrimary: Color(0xFFFFFFFF),
    primaryInk: Color(0xFFC23600),
    background: Color(0xFFFFFAF7),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFFBEEE6),
    onSurface: Color(0xFF3D1A00),
    onSurfaceVariant: Color(0xFF7A5540),
    outline: Color(0xFFF0E1D6),
    outlineStrong: Color(0xFFE6CDBD),
    error: Color(0xFFB8321B),
    errorContainer: Color(0xFFFDE4DE),
    success: Color(0xFF2E8A57),
  );

  static const dark = AppPalette(
    primary: Color(0xFFFF6B35),
    onPrimary: Color(0xFF2A0E00),
    primaryInk: Color(0xFFFF9466),
    background: Color(0xFF1A110C),
    surface: Color(0xFF271A12),
    surfaceVariant: Color(0xFF34241A),
    onSurface: Color(0xFFFFF3EA),
    onSurfaceVariant: Color(0xFFD2B9A8),
    outline: Color(0xFF3E2C20),
    outlineStrong: Color(0xFF5A4131),
    error: Color(0xFFFF8A73),
    errorContainer: Color(0xFF3D1C16),
    success: Color(0xFF4CB57B),
  );
}

/// Les 4 couleurs d'une humeur.
/// - [fill] : remplissage (calendrier, puces). Jamais de texte dessus.
/// - [edge] : contour du fill en mode clair.
/// - [tint] : fond de carte, avec [onTint] pour le texte.
///
/// Exemple :
/// ```dart
/// final zen = context.moodColors.of(Mood.zen);
/// Container(
///   color: zen.tint,
///   child: Text('Zen', style: TextStyle(color: zen.onTint)),
/// );
/// ```
@immutable
class MoodPalette {
  const MoodPalette({
    required this.fill,
    required this.edge,
    required this.tint,
    required this.onTint,
  });

  final Color fill;
  final Color edge;
  final Color tint;
  final Color onTint;

  static MoodPalette lerp(MoodPalette a, MoodPalette b, double t) =>
      MoodPalette(
        fill: Color.lerp(a.fill, b.fill, t)!,
        edge: Color.lerp(a.edge, b.edge, t)!,
        tint: Color.lerp(a.tint, b.tint, t)!,
        onTint: Color.lerp(a.onTint, b.onTint, t)!,
      );
}

abstract final class AppMoodPalettes {
  static const _onTintLight = Color(0xFF3D1A00);
  static const _onTintDark = Color(0xFFFFF3EA);

  static const light = <Mood, MoodPalette>{
    Mood.joy: MoodPalette(
      fill: Color(0xFFFFC53D),
      edge: Color(0xFFB98A04),
      tint: Color(0xFFFEEECF),
      onTint: _onTintLight,
    ),
    Mood.love: MoodPalette(
      fill: Color(0xFFFF6B8B),
      edge: Color(0xFFF15E7F),
      tint: Color(0xFFFFEAED),
      onTint: _onTintLight,
    ),
    Mood.hype: MoodPalette(
      fill: Color(0xFFFF9F45),
      edge: Color(0xFFD77A0E),
      tint: Color(0xFFFFECDE),
      onTint: _onTintLight,
    ),
    Mood.zen: MoodPalette(
      fill: Color(0xFF4CC38A),
      edge: Color(0xFF25A56E),
      tint: Color(0xFFDCF9E7),
      onTint: _onTintLight,
    ),
    Mood.hug: MoodPalette(
      fill: Color(0xFF7FD1E8),
      edge: Color(0xFF4A9CB2),
      tint: Color(0xFFDFF5FB),
      onTint: _onTintLight,
    ),
    Mood.flat: MoodPalette(
      fill: Color(0xFFA8A29E),
      edge: Color(0xFF96908C),
      tint: Color(0xFFF1F0EE),
      onTint: _onTintLight,
    ),
    Mood.sad: MoodPalette(
      fill: Color(0xFF4A7BE0),
      edge: Color(0xFF4A7BE0),
      tint: Color(0xFFE9F0FF),
      onTint: _onTintLight,
    ),
    Mood.stress: MoodPalette(
      fill: Color(0xFF8B6FE0),
      edge: Color(0xFF8B6FE0),
      tint: Color(0xFFF0EEFF),
      onTint: _onTintLight,
    ),
    Mood.mad: MoodPalette(
      fill: Color(0xFFE5484D),
      edge: Color(0xFFE5484D),
      tint: Color(0xFFFFEBE9),
      onTint: _onTintLight,
    ),
  };

  // En sombre, edge = fill.
  static const dark = <Mood, MoodPalette>{
    Mood.joy: MoodPalette(
      fill: Color(0xFFFFC53D),
      edge: Color(0xFFFFC53D),
      tint: Color(0xFF3F2D00),
      onTint: _onTintDark,
    ),
    Mood.love: MoodPalette(
      fill: Color(0xFFFF6B8B),
      edge: Color(0xFFFF6B8B),
      tint: Color(0xFF4D1F28),
      onTint: _onTintDark,
    ),
    Mood.hype: MoodPalette(
      fill: Color(0xFFFF9F45),
      edge: Color(0xFFFF9F45),
      tint: Color(0xFF492703),
      onTint: _onTintDark,
    ),
    Mood.zen: MoodPalette(
      fill: Color(0xFF4CC38A),
      edge: Color(0xFF4CC38A),
      tint: Color(0xFF0D3A25),
      onTint: _onTintDark,
    ),
    Mood.hug: MoodPalette(
      fill: Color(0xFF7FD1E8),
      edge: Color(0xFF7FD1E8),
      tint: Color(0xFF17353D),
      onTint: _onTintDark,
    ),
    Mood.flat: MoodPalette(
      fill: Color(0xFFA8A29E),
      edge: Color(0xFFA8A29E),
      tint: Color(0xFF32302E),
      onTint: _onTintDark,
    ),
    Mood.sad: MoodPalette(
      fill: Color(0xFF4A7BE0),
      edge: Color(0xFF4A7BE0),
      tint: Color(0xFF1D2F53),
      onTint: _onTintDark,
    ),
    Mood.stress: MoodPalette(
      fill: Color(0xFF8B6FE0),
      edge: Color(0xFF8B6FE0),
      tint: Color(0xFF322950),
      onTint: _onTintDark,
    ),
    Mood.mad: MoodPalette(
      fill: Color(0xFFE5484D),
      edge: Color(0xFFE5484D),
      tint: Color(0xFF4E201F),
      onTint: _onTintDark,
    ),
  };
}
