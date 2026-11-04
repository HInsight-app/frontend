import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:isar/isar.dart';

/// Opens a real Isar database in a temporary folder, for tests.
///
/// Isar needs its native library, which `flutter test` doesn't load. The
/// isar_flutter_libs package from pub already contains one for each desktop OS,
/// so this finds that copy instead of downloading it.
Future<Isar> openTestIsar(List<CollectionSchema<dynamic>> schemas) async {
  await Isar.initializeIsarCore(libraries: {Abi.current(): _isarLibraryPath()});
  final dir = await Directory.systemTemp.createTemp('isar_test_');
  return Isar.open(
    schemas,
    directory: dir.path,
    name: dir.uri.pathSegments.where((s) => s.isNotEmpty).last,
    inspector: false,
  );
}

/// Closes [isar] and deletes its temporary folder.
Future<void> closeTestIsar(Isar isar) async {
  final dir = Directory(isar.directory!);
  await isar.close(deleteFromDisk: true);
  if (dir.existsSync()) dir.deleteSync(recursive: true);
}

String _isarLibraryPath() {
  final config = jsonDecode(
    File('.dart_tool/package_config.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final package = (config['packages'] as List).cast<Map<String, dynamic>>()
      .firstWhere((p) => p['name'] == 'isar_flutter_libs');
  // rootUri has no trailing slash, and resolve() would drop its last folder.
  final root = Uri.parse('${package['rootUri']}/');
  final relative = switch (Abi.current()) {
    Abi.windowsX64 => 'windows/isar.dll',
    Abi.linuxX64 => 'linux/libisar.so',
    Abi.macosArm64 || Abi.macosX64 => 'macos/libisar.dylib',
    final abi => throw UnsupportedError('No Isar test library for $abi'),
  };
  return File.fromUri(root.resolve(relative)).path;
}
