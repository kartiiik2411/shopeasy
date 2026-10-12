class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
