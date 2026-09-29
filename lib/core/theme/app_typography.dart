import 'package:flutter/material.dart';

/// Styles de texte du design system (Nunito), rangés dans les rôles Material.
///
/// | Token       | Rôle Material                  |
/// |-------------|--------------------------------|
/// | display     | displayLarge                   |
/// | headline    | headlineLarge                  |
/// | title       | titleLarge                     |
/// | titleSmall  | titleMedium                    |
/// | bodyStrong  | titleSmall                     |
/// | button      | labelLarge (texte des boutons) |
/// | body        | bodyLarge, bodyMedium (défaut) |
/// | label       | labelMedium                    |
/// | caption     | bodySmall, labelSmall          |
///
/// Exemple :
/// ```dart
/// final text = Theme.of(context).textTheme;
/// Text('Comment te sens-tu ?', style: text.titleLarge); // token title
/// Text('Il y a 2 min', style: text.bodySmall); // token caption
/// Text('Texte courant'); // bodyMedium par défaut = token body
///
/// // Changer la couleur sans perdre la taille ni la graisse :
/// Text('Erreur', style: text.bodySmall?.copyWith(
///     color: Theme.of(context).colorScheme.error));
/// ```
abstract final class AppTypography {
  static const fontFamily = 'Nunito';

  static const display = _TextToken(34, 800, 1.1);
  static const headline = _TextToken(30, 800, 1.15);
  static const title = _TextToken(24, 800, 1.15);
  static const titleSmall = _TextToken(19, 800, 1.2);
  static const button = _TextToken(19, 800, 1);
  static const body = _TextToken(17, 400, 1.45);
  static const bodyStrong = _TextToken(16, 600, 1.4);
  static const label = _TextToken(14, 700, 1.3);
  static const caption = _TextToken(13, 600, 1.35);

  static TextTheme get textTheme => TextTheme(
    displayLarge: display.style,
    headlineLarge: headline.style,
    titleLarge: title.style,
    titleMedium: titleSmall.style,
    titleSmall: bodyStrong.style,
    labelLarge: button.style,
    bodyLarge: body.style,
    bodyMedium: body.style,
    labelMedium: label.style,
    bodySmall: caption.style,
    labelSmall: caption.style,
  );
}

class _TextToken {
  const _TextToken(this.size, this.weight, this.height);

  final double size;
  final int weight;
  final double height;

  // Nunito est une police variable : fontVariations règle l'axe de graisse,
  // fontWeight garde la bonne graisse si une police de secours est utilisée.
  TextStyle get style => TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: size,
    fontWeight: FontWeight.values[weight ~/ 100 - 1],
    fontVariations: [FontVariation.weight(weight.toDouble())],
    height: height,
    letterSpacing: 0,
  );
}
