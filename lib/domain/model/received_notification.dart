class ReceivedNotificationModel {
  ReceivedNotificationModel({
    this.id = 0,
    required this.title,
    required this.body,
    this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationDetailsModel {
  final String channelId;
  final String channelName;
  final String channelDescription;

  NotificationDetailsModel(
      this.channelId, this.channelName, this.channelDescription);
}
