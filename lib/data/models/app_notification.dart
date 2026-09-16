enum NotificationKind { session, system, promo }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationKind kind;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.kind,
    this.isRead = false,
  });
}
