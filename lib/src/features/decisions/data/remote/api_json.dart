// How values look in the API's JSON (paper III-E): enums in snake_case
// (lossAversion <-> loss_aversion), timestamps in ISO 8601 UTC, and DATE
// columns as yyyy-MM-dd.

/// lossAversion -> loss_aversion.
String toSnakeCase(String camelCase) => camelCase.replaceAllMapped(
    RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

String enumToApi(Enum value) => toSnakeCase(value.name);

/// The enum value for an API string, or null for null, "none" (the prompt's
/// value for "no bias found") and values this app version doesn't know.
T? enumFromApi<T extends Enum>(List<T> values, Object? json) {
  if (json is! String) return null;
  for (final value in values) {
    if (enumToApi(value) == json) return value;
  }
  return null;
}

String timestampToApi(DateTime time) => time.toUtc().toIso8601String();

DateTime timestampFromApi(Object? json) => DateTime.parse(json as String).toLocal();

DateTime? optionalTimestampFromApi(Object? json) =>
    json == null ? null : timestampFromApi(json);

/// A calendar date, e.g. the scheduled review date.
String dateToApi(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Accepts "2026-11-20" and also "2026-11-20T00:00:00Z" (how Go encodes a
/// DATE), keeping the written day in every time zone.
DateTime? dateFromApi(Object? json) {
  if (json == null) return null;
  final parsed = DateTime.parse(json as String);
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// OPTIONS.pros / cons are single TEXT columns: one item per line.
String? linesToApi(List<String> items) => items.isEmpty ? null : items.join('\n');

List<String> linesFromApi(Object? json) => json is String
    ? json.split('\n').where((line) => line.trim().isNotEmpty).toList()
    : const [];
