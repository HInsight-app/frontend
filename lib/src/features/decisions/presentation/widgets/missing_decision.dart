import 'package:flutter/material.dart';

/// The body of a decision page while the decision loads, or when it doesn't
/// exist (deleted, or a wrong link). Without this the page would spin forever.
class MissingDecision extends StatelessWidget {
  const MissingDecision({super.key, required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading
          ? const CircularProgressIndicator()
          : Text('This decision no longer exists.',
              style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
