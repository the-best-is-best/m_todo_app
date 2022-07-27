class ReceivedNotificationModel {
  ReceivedNotificationModel({
    this.id = 0,
    required this.title,
    required this.body,
    this.payload,
    required this.dateTime,
  });

  final int id;
  final String? title;
  final String? body;
  final DateTime dateTime;
  final Map<String, String>? payload;
}
