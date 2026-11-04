import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/main.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('MainApp starts on the home page with AppTheme', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);

    final theme = Theme.of(tester.element(find.byType(HomePage)));
    expect(theme.colorScheme, AppTheme.colorScheme);
    expect(theme.textTheme.bodyMedium!.fontFamily, AppTheme.fontFamily);
  });

  testWidgets('the font licence shows on the licences page', (tester) async {
    // Start from an empty registry so only our licence is read, not Flutter's
    // own NOTICES file.
    LicenseRegistry.reset();
    addTearDown(LicenseRegistry.reset);
    addFontLicenses();

    // Read the licences inside runAsync: they load the licence file from assets.
    final licences = await tester.runAsync(
      () => LicenseRegistry.licenses.toList(),
    );

    final fontLicence = licences!.singleWhere(
      (licence) => licence.packages.contains('Plus Jakarta Sans'),
    );
    expect(
      fontLicence.paragraphs.map((p) => p.text).join('\n'),
      contains('SIL Open Font License'),
    );
  });
}
