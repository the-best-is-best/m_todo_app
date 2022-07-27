import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../domain/model/received_notification.dart';

class NotificationServices {
  Future<void> createReminderNotification(
    ReceivedNotificationModel receivedNotificationModel,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: receivedNotificationModel.id,
          channelKey: 'schedule_tasks',
          title: receivedNotificationModel.title,
          body: receivedNotificationModel.body,
          displayOnForeground: true,
          payload: receivedNotificationModel.payload),
      schedule: NotificationCalendar(
          day: receivedNotificationModel.dateTime.day,
          hour: receivedNotificationModel.dateTime.hour,
          minute: receivedNotificationModel.dateTime.minute,
          second: receivedNotificationModel.dateTime.second),
    );
  }
}
