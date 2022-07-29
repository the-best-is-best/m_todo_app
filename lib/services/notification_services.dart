import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import '../app/cubit/app_cubit.dart';
import '../app/resources/styles_manger.dart';
import '../app/resources/value_manger.dart';
import '../domain/model/received_notification.dart';
import '../domain/model/tasks_model.dart';
import '../presentation/components/text.dart';
import '../presentation/details_task/view/details_tasks_view.dart';

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

  void showAlertToAllowNotification(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllow) {
      if (!isAllow) {
        context.showAlerts(
            title: context.strings().allowNotification,
            textStyle: getRegularStyle(),
            paddingTitle: const EdgeInsets.all(AppSize.ap12),
            content: [
              Column(
                children: [
                  MyText(
                      title: context
                          .strings()
                          .ourAppWouldLikeToSendYouNotifications),
                  const SizedBox(
                    height: AppSize.ap12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: MyText(
                            title: context.strings().donotAllow,
                          ),
                          onPressed: () {
                            context.back();
                          }),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: MyText(
                            title: context.strings().allow,
                          ),
                          onPressed: () {
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications()
                                .then((_) => context.back());
                          })
                    ],
                  )
                ],
              )
            ]);
      }
    });
  }

  void listenNotification(BuildContext context) {
    // NotificationServices.onNotification.stream.listen(onClickedNotification);
    AwesomeNotifications().createdStream.listen((notification) {
      // context.showToast('Notification listen now');
    });
    AwesomeNotifications().actionStream.listen((notification) {
      actionListenNotification(context, notification);
    });
  }

  void actionListenNotification(
      BuildContext context, ReceivedNotification? notification) {
    AwesomeNotifications().getGlobalBadgeCounter().then((value) =>
        AwesomeNotifications()
            .setGlobalBadgeCounter(value == 1 ? value - 1 : value));
    if (notification?.payload != null &&
        !notification!.body!.contains('Ended')) {
      Map<String, String> payloadMap = notification.payload!;
      TasksModel taskNotification = TasksModel.fromJsonString(payloadMap);
      context.push(const DetailsTasksView(), arguments: taskNotification);
    } else if (notification?.payload != null &&
        notification!.body!.contains('Ended')) {
      context.showAlerts(
          title: context.strings().updateTaskToCompleted,
          textStyle: getRegularStyle(),
          paddingTitle: const EdgeInsets.all(AppSize.ap12),
          content: [
            Column(
              children: [
                MyText(
                  title:
                      context.strings().doYouWantToMoveTheTaskToCompleteTasks,
                  style: getRegularStyle(color: Colors.black),
                ),
                const SizedBox(height: AppSize.ap12),
                MyText(
                  title: notification.title ?? "Error",
                  style: getRegularStyle(color: Colors.black),
                ),
                const SizedBox(height: AppSize.ap12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          AppCubit appCubit = AppCubit.get(context);
                          appCubit.updateTaskToCompleted(
                              int.parse(notification.payload!['id'] ?? '0'));
                          context.back();
                        },
                        child: MyText(
                          title: context.strings().yes,
                        )),
                    const SizedBox(height: AppSpacing.ap12),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          context.back();
                        },
                        child: MyText(
                          title: context.strings().no,
                        )),
                  ],
                )
              ],
            )
          ]);
    }
  }
}
