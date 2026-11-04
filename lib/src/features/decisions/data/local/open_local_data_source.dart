// Picks the on-device store for the platform: Isar on phones, memory on web.
// Isar's generated code can't even compile for web (its ids don't fit in a
// JavaScript number), so the web build must never import it.
export 'open_local_data_source_io.dart'
    if (dart.library.js_interop) 'open_local_data_source_web.dart';
