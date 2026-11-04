import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Study participants see the app's name on their phone's home screen and in
// the recent apps list; it used to be the folder name, "frontend".
void main() {
  test('the app is called HInsight on Android, iOS and the web', () {
    expect(File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
        contains('android:label="HInsight"'));

    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(
        plist,
        matches(RegExp(
            r'<key>CFBundleDisplayName</key>\s*<string>HInsight</string>')));

    expect(File('web/index.html').readAsStringSync(),
        contains('<title>HInsight</title>'));
    expect(File('lib/main.dart').readAsStringSync(),
        contains("title: 'HInsight'"));
  });
}
