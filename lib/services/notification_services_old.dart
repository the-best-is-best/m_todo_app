// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:m_todo_app/domain/model/received_notification.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationServices {
//   final FlutterLocalNotificationsPlugin _notification =
//       FlutterLocalNotificationsPlugin();

//   static BehaviorSubject<String?> onNotification = BehaviorSubject<String?>();

//   Future init({bool initScheduled = false}) async {
//     const AndroidInitializationSettings androidSetting =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const IOSInitializationSettings iosSetting = IOSInitializationSettings();
//     const InitializationSettings setting =
//         InitializationSettings(android: androidSetting, iOS: iosSetting);
//     await _notification.initialize(setting,
//         onSelectNotification: (payload) async {
//       onNotification.add(payload);
//     });
//     final NotificationAppLaunchDetails? details =
//         await _notification.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       onNotification.add(details.payload);
//     }
//   }

//   FlutterLocalNotificationsPlugin getFlutterLocalNotificationsPlugin() {
//     return _notification;
//   }

//   Future _notificationDetails(
//       NotificationDetailsModel notificationDetailsModel) async {
//     return NotificationDetails(
//         android: AndroidNotificationDetails(
//           notificationDetailsModel.channelId,
//           notificationDetailsModel.channelName,
//           channelDescription: notificationDetailsModel.channelDescription,
//           importance: Importance.max,
//         ),
//         iOS: const IOSNotificationDetails());
//   }

//   Future showNotification(ReceivedNotificationModel receivedNotification,
//       NotificationDetailsModel notificationDetailsModel) async {
//     await _notification.show(
//         receivedNotification.id,
//         receivedNotification.title,
//         receivedNotification.body,
//         await _notificationDetails(notificationDetailsModel));
//   }

//   Future showScheduleNotification(
//       ReceivedNotificationModel receivedNotification,
//       NotificationDetailsModel notificationDetailsModel,
//       DateTime scheduleDate) async {
//     await _notification.zonedSchedule(
//         receivedNotification.id,
//         receivedNotification.title,
//         receivedNotification.body,
//         tz.TZDateTime.from(scheduleDate, tz.local),
//         await _notificationDetails(notificationDetailsModel),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: receivedNotification.payload);
//   }
// }
