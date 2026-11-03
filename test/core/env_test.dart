import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the local .env loads the same way main() loads it', () async {
    // main() calls this before runApp. It throws if .env is missing or empty,
    // which would crash the app on launch.
    await dotenv.load(fileName: '.env');

    expect(dotenv.env.containsKey('BASE_URL'), isTrue,
        reason: '.env must define BASE_URL (see .env.example)');
  });

  group('.env.example', () {
    final example = File('.env.example').readAsStringSync();

    test('defines only BASE_URL; the comment lines are ignored', () {
      dotenv.loadFromString(envString: example);

      expect(dotenv.env.keys, ['BASE_URL']);
      expect(dotenv.env['BASE_URL'], isEmpty);
    });

    test('still parses with Windows (CRLF) line endings', () {
      // Git on Windows checks text files out with CRLF, and copying the
      // example keeps them, so the parser must not leave a stray \r behind.
      dotenv.loadFromString(
        envString: example.replaceAll('\r\n', '\n').replaceAll('\n', '\r\n'),
      );

      expect(dotenv.env.keys, ['BASE_URL']);
      expect(dotenv.env['BASE_URL'], isEmpty);
    });
  });
}
