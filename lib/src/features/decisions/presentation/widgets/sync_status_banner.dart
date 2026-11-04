import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../sync_controller.dart';

/// Tells the student when their changes haven't reached the server yet, and
/// why (offline, still sending, or refused), with a way to try again. Also
/// says when a newer copy from the server replaced one on the phone. Shows
/// nothing when everything is synced.
class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  static String changes(int n) => n == 1 ? '1 change' : '$n changes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);
    final report = sync.lastReport;
    final pending = sync.pending;

    if (pending == 0) {
      final kept = report?.serverVersionsKept ?? const <String>[];
      if (kept.isEmpty) return const SizedBox.shrink();
      return _Banner(
        icon: Icons.sync_alt,
        color: AppColors.info,
        title: 'Updated from the server',
        message: kept.length == 1
            ? '"${kept.first}" was changed somewhere else more recently, so '
                'that newer version is the one kept.'
            : '${kept.length} decisions were changed somewhere else more '
                'recently, so those newer versions are the ones kept.',
        actionLabel: 'OK',
        onAction: controller.dismissReport,
      );
    }

    final waiting = changes(pending);
    if (sync.syncing) {
      return _Banner(
        icon: Icons.cloud_upload_outlined,
        color: AppColors.info,
        title: 'Syncing',
        message: 'Sending $waiting to the server…',
        busy: true,
      );
    }
    if (sync.offline) {
      return _Banner(
        icon: Icons.cloud_off_outlined,
        color: AppColors.warning,
        title: "You're offline",
        message: '$waiting saved on this phone will be sent to the server '
            "when you're back online.",
        actionLabel: 'Try again',
        onAction: controller.syncNow,
      );
    }
    final problem = report?.stopMessage ??
        report?.failures.firstOrNull ??
        sync.error;
    if (problem != null) {
      return _Banner(
        icon: Icons.error_outline,
        color: AppColors.error,
        title: "Some changes couldn't be synced",
        message: '$waiting saved on this phone. $problem',
        actionLabel: 'Try again',
        onAction: controller.syncNow,
      );
    }
    return _Banner(
      icon: Icons.cloud_upload_outlined,
      color: AppColors.info,
      title: 'Waiting to sync',
      message: '$waiting saved on this phone will be sent to the server soon.',
      actionLabel: 'Sync now',
      onAction: controller.syncNow,
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.busy = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: busy
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: color),
                  )
                : Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleSmall?.copyWith(color: color)),
                const SizedBox(height: 2),
                Text(message, style: textTheme.bodySmall),
              ],
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
