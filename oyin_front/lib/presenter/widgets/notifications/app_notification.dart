import 'package:flutter/material.dart';

import '../../extensions/_export.dart';

enum AppNotificationType { info, success, warning, error }

class AppNotificationData {
  const AppNotificationData({
    required this.title,
    required this.message,
    this.type = AppNotificationType.info,
  });

  final String title;
  final String message;
  final AppNotificationType type;

  factory AppNotificationData.error(String title, String message) {
    return AppNotificationData(
      title: title,
      message: message,
      type: AppNotificationType.error,
    );
  }

  factory AppNotificationData.warning(String title, String message) {
    return AppNotificationData(
      title: title,
      message: message,
      type: AppNotificationType.warning,
    );
  }

  factory AppNotificationData.success(String title, String message) {
    return AppNotificationData(
      title: title,
      message: message,
      type: AppNotificationType.success,
    );
  }
}

class AppNotificationBanner extends StatelessWidget {
  const AppNotificationBanner({
    super.key,
    required this.data,
    this.onClose,
  });

  final AppNotificationData data;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _accentColor(palette);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForType(), color: accent, size: 18),
            ),
            12.hSpacing,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.titleSmall?.weighted(FontWeight.w700),
                  ),
                  4.vSpacing,
                  Text(
                    data.message,
                    style: Theme.of(context).textTheme.bodySmall?.colored(palette.muted),
                  ),
                ],
              ),
            ),
            if (onClose != null) ...[
              8.hSpacing,
              GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close_rounded, color: palette.iconMuted, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconForType() {
    switch (data.type) {
      case AppNotificationType.success:
        return Icons.check_circle_rounded;
      case AppNotificationType.warning:
        return Icons.warning_amber_rounded;
      case AppNotificationType.error:
        return Icons.error_outline_rounded;
      case AppNotificationType.info:
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _accentColor(AppPalette palette) {
    switch (data.type) {
      case AppNotificationType.success:
        return palette.success;
      case AppNotificationType.warning:
        return Colors.amber;
      case AppNotificationType.error:
        return palette.danger;
      case AppNotificationType.info:
      default:
        return palette.primary;
    }
  }
}
