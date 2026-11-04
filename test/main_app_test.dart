import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/main.dart';
import 'package:hinsight/src/features/auth/presentation/pages/login_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';

// Runs the real app wiring; only the device's secure storage is faked.
void main() {
  setUp(() => dotenv.loadFromString(envString: 'BASE_URL=http://localhost:8080'));

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('with no saved session, MainApp opens the login page',
      (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    await pumpApp(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a remembered session opens the dashboard with AppTheme',
      (tester) async {
    FlutterSecureStorage.setMockInitialValues({
      TokenStorage.tokenKey: 'saved-token',
      'auth_user': jsonEncode(
        {'id': 'u1', 'email': 'owen@binus.ac.id', 'display_name': 'Owen'},
      ),
    });
    await pumpApp(tester);

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
