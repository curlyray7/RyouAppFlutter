import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryou_app/core/theme/app_colors.dart';
import 'package:ryou_app/core/theme/app_theme.dart';
import 'package:ryou_app/core/theme/app_typography.dart';
import 'package:ryou_app/core/theme/theme_extensions.dart';
import 'package:ryou_app/shared/models/mood.dart';

Color _hex(String hex) => Color(int.parse('FF${hex.substring(1)}', radix: 16));

void main() {
  // Le thème est recopié à la main depuis les tokens : ce test signale tout écart.
  final tokens = jsonDecode(
    File('assets/tokens/ryou_tokens.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final colorTokens = tokens['color'] as Map<String, dynamic>;

  for (final (mode, palette, moods) in [
    ('light', AppPalette.light, AppMoodPalettes.light),
    ('dark', AppPalette.dark, AppMoodPalettes.dark),
  ]) {
    group('palette $mode', () {
      final t = colorTokens[mode] as Map<String, dynamic>;

      test('correspond aux tokens', () {
        expect(palette.primary, _hex(t['primary']));
        expect(palette.onPrimary, _hex(t['onPrimary']));
        expect(palette.primaryInk, _hex(t['primaryInk']));
        expect(palette.background, _hex(t['background']));
        expect(palette.surface, _hex(t['surface']));
        expect(palette.surfaceVariant, _hex(t['surfaceVariant']));
        expect(palette.onSurface, _hex(t['onSurface']));
        expect(palette.onSurfaceVariant, _hex(t['onSurfaceVariant']));
        expect(palette.outline, _hex(t['outline']));
        expect(palette.outlineStrong, _hex(t['outlineStrong']));
        expect(palette.error, _hex(t['error']));
        expect(palette.errorContainer, _hex(t['errorContainer']));
        expect(palette.success, _hex(t['success']));
      });

      test('les 9 humeurs correspondent aux tokens', () {
        final moodTokens = colorTokens['mood'] as Map<String, dynamic>;
        expect(moodTokens.keys, Mood.values.map((m) => m.name));
        for (final mood in Mood.values) {
          final m = moodTokens[mood.name] as Map<String, dynamic>;
          final c = m[mode] as Map<String, dynamic>;
          expect(mood.family.name, m['family'], reason: mood.name);
          expect(mood.emoji, m['emoji'], reason: mood.name);
          expect(moods[mood]!.fill, _hex(c['fill']), reason: mood.name);
          expect(moods[mood]!.edge, _hex(c['edge']), reason: mood.name);
          expect(moods[mood]!.tint, _hex(c['tint']), reason: mood.name);
          expect(moods[mood]!.onTint, _hex(c['onTint']), reason: mood.name);
        }
      });
    });
  }

  test('la typographie correspond aux tokens', () {
    final typo = tokens['typography'] as Map<String, dynamic>;
    final styles = {
      'display': AppTypography.display.style,
      'headline': AppTypography.headline.style,
      'title': AppTypography.title.style,
      'titleSmall': AppTypography.titleSmall.style,
      'button': AppTypography.button.style,
      'body': AppTypography.body.style,
      'bodyStrong': AppTypography.bodyStrong.style,
      'label': AppTypography.label.style,
      'caption': AppTypography.caption.style,
    };
    expect(AppTypography.fontFamily, typo['fontFamily']);
    styles.forEach((name, style) {
      final t = typo[name] as Map<String, dynamic>;
      expect(style.fontSize, (t['size'] as num).toDouble(), reason: name);
      expect(style.fontWeight!.value, t['weight'], reason: name);
      expect(style.height, (t['lineHeight'] as num).toDouble(), reason: name);
    });
  });

  testWidgets('les deux thèmes exposent les extensions Ryou', (tester) async {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (c) {
              ctx = c;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle(); // MaterialApp anime le changement de thème
      expect(Theme.of(ctx).colorScheme.brightness, theme.brightness);
      expect(ctx.ryouColors, isNotNull);
      expect(ctx.moodColors.of(Mood.joy).fill, const Color(0xFFFFC53D));
      expect(
        Theme.of(ctx).scaffoldBackgroundColor,
        isNot(Theme.of(ctx).colorScheme.surface),
      );
    }
  });
}
