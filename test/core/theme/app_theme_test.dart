import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';

// Reads usWeightClass from a TrueType file's OS/2 table, i.e. the weight the
// font file says it is. Used to catch a file declared under the wrong weight.
int _fontFileWeight(ByteData font) {
  final tableCount = font.getUint16(4);
  for (var i = 0; i < tableCount; i++) {
    final record = 12 + 16 * i;
    final tag = String.fromCharCodes(
      List.generate(4, (j) => font.getUint8(record + j)),
    );
    if (tag == 'OS/2') {
      final tableOffset = font.getUint32(record + 8);
      return font.getUint16(tableOffset + 4);
    }
  }
  throw StateError('Font has no OS/2 table');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final theme = AppTheme.darkTheme;

  test('colour scheme uses the style guide colours', () {
    final colors = theme.colorScheme;

    expect(colors.brightness, Brightness.dark);
    expect(colors.surface, AppColors.background);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(colors.onSurface, AppColors.foreground);
    expect(colors.surfaceContainer, AppColors.card);
    expect(colors.primary, AppColors.primary);
    expect(colors.primaryContainer, AppColors.cta);
    expect(colors.secondary, AppColors.secondary);
    expect(colors.tertiary, AppColors.accent);
    expect(colors.outline, AppColors.border);
    expect(colors.onSurfaceVariant, AppColors.mutedForeground);
    expect(colors.error, AppColors.error);
  });

  test('type scale matches the style guide', () {
    final text = theme.textTheme;

    // Title: Extrabold 32
    expect(text.headlineLarge!.fontSize, 32);
    expect(text.headlineLarge!.fontWeight, FontWeight.w800);
    // Heading 2: Bold 24
    expect(text.headlineSmall!.fontSize, 24);
    expect(text.headlineSmall!.fontWeight, FontWeight.w700);
    // Paragraph: Normal 16 (bodyMedium is the default for Text)
    expect(text.bodyMedium!.fontSize, 16);
    expect(text.bodyMedium!.fontWeight, FontWeight.w400);
    // Sub-text: Light 14
    expect(text.bodySmall!.fontSize, 14);
    expect(text.bodySmall!.fontWeight, FontWeight.w300);
  });

  test('every text style and button label uses Plus Jakarta Sans', () {
    final text = theme.textTheme;
    final styles = <String, TextStyle?>{
      'displayLarge': text.displayLarge,
      'displayMedium': text.displayMedium,
      'displaySmall': text.displaySmall,
      'headlineLarge': text.headlineLarge,
      'headlineMedium': text.headlineMedium,
      'headlineSmall': text.headlineSmall,
      'titleLarge': text.titleLarge,
      'titleMedium': text.titleMedium,
      'titleSmall': text.titleSmall,
      'bodyLarge': text.bodyLarge,
      'bodyMedium': text.bodyMedium,
      'bodySmall': text.bodySmall,
      'labelLarge': text.labelLarge,
      'labelMedium': text.labelMedium,
      'labelSmall': text.labelSmall,
      // Button text styles don't inherit ThemeData.fontFamily, so check them too.
      'elevatedButton': theme.elevatedButtonTheme.style!.textStyle!.resolve({}),
      'filledButton': theme.filledButtonTheme.style!.textStyle!.resolve({}),
      'outlinedButton': theme.outlinedButtonTheme.style!.textStyle!.resolve({}),
      'textButton': theme.textButtonTheme.style!.textStyle!.resolve({}),
      'fab': theme.floatingActionButtonTheme.extendedTextStyle,
      'hint': theme.inputDecorationTheme.hintStyle,
    };

    for (final MapEntry(key: name, value: style) in styles.entries) {
      expect(style?.fontFamily, AppTheme.fontFamily, reason: name);
    }
  });

  test('each bundled font file is declared under its real weight', () async {
    final manifest = jsonDecode(
      await rootBundle.loadString('FontManifest.json'),
    ) as List<dynamic>;
    final family = manifest.firstWhere(
      (entry) => entry['family'] == AppTheme.fontFamily,
      orElse: () => fail('${AppTheme.fontFamily} is not in pubspec.yaml fonts'),
    );
    final fonts = (family['fonts'] as List).cast<Map<String, dynamic>>();

    final declared = <int, int>{};
    for (final font in fonts) {
      final asset = font['asset'] as String;
      final fileWeight = _fontFileWeight(await rootBundle.load(asset));
      declared[font['weight'] as int] = fileWeight;
    }

    // The four design weights plus Medium/SemiBold used by Material defaults.
    expect(declared, {300: 300, 400: 400, 500: 500, 600: 600, 700: 700, 800: 800});
  });

  test('the font licence is bundled', () async {
    final licence =
        await rootBundle.loadString('assets/fonts/PlusJakartaSans/OFL.txt');
    expect(licence, contains('SIL Open Font License'));
  });
}
