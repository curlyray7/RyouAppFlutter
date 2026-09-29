import 'package:flutter/material.dart';

import '../../shared/models/mood.dart';
import 'app_colors.dart';

/// Couleurs Ryou qui n'ont pas de rôle dans le ColorScheme de Material.
///
/// Exemple :
/// ```dart
/// Text('Mot de passe oublié ?',
///     style: TextStyle(color: context.ryouColors.primaryInk));
/// Switch(value: true, onChanged: (_) {},
///     activeTrackColor: context.ryouColors.success);
/// ```
@immutable
class RyouColors extends ThemeExtension<RyouColors> {
  const RyouColors({required this.primaryInk, required this.success});

  /// Liens, onglet actif, petit texte orange.
  final Color primaryInk;

  /// Interrupteurs actifs, validations.
  final Color success;

  @override
  RyouColors copyWith({Color? primaryInk, Color? success}) => RyouColors(
    primaryInk: primaryInk ?? this.primaryInk,
    success: success ?? this.success,
  );

  @override
  RyouColors lerp(RyouColors? other, double t) {
    if (other == null) return this;
    return RyouColors(
      primaryInk: Color.lerp(primaryInk, other.primaryInk, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

/// Les couleurs des 9 humeurs, pour le mode clair ou sombre.
///
/// Exemple : une pastille d'humeur dans le calendrier.
/// ```dart
/// final joy = context.moodColors.of(Mood.joy);
/// Container(
///   width: 38,
///   height: 38,
///   decoration: BoxDecoration(
///     color: joy.fill,
///     shape: BoxShape.circle,
///     border: Border.all(color: joy.edge, width: 2),
///   ),
/// );
/// ```
@immutable
class MoodColors extends ThemeExtension<MoodColors> {
  const MoodColors(this._palettes);

  final Map<Mood, MoodPalette> _palettes;

  MoodPalette of(Mood mood) => _palettes[mood]!;

  @override
  MoodColors copyWith({Map<Mood, MoodPalette>? palettes}) =>
      MoodColors(palettes ?? _palettes);

  @override
  MoodColors lerp(MoodColors? other, double t) {
    if (other == null) return this;
    return MoodColors({
      for (final mood in Mood.values)
        mood: MoodPalette.lerp(of(mood), other.of(mood), t),
    });
  }
}

extension RyouThemeContext on BuildContext {
  RyouColors get ryouColors => Theme.of(this).extension<RyouColors>()!;
  MoodColors get moodColors => Theme.of(this).extension<MoodColors>()!;
}
