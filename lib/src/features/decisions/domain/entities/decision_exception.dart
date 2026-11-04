/// A rule of the decision flow was broken, e.g. committing twice or two
/// options with the same title. The message is safe to show the student.
class DecisionException implements Exception {
  const DecisionException(this.message);

  final String message;

  @override
  String toString() => message;
}
