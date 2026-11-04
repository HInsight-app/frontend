const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// e.g. "Nov 4, 2026". Written here to avoid adding the intl package.
String formatDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

/// Whether [date] falls on or before today (ignoring the time of day).
bool isOnOrBeforeToday(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final day = DateTime(date.year, date.month, date.day);
  return !day.isAfter(DateTime(today.year, today.month, today.day));
}
