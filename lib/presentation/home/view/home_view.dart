import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/di.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/main.dart';
import 'package:m_todo_app/presentation/components/text.dart';
import 'package:m_todo_app/presentation/home/view/pages/completed_page/page/completed_page.dart';
import 'package:m_todo_app/presentation/home/view/pages/home_page/page/home_page.dart';
import 'package:m_todo_app/presentation/home/view/widgets/app_bar.dart';
import 'package:m_todo_app/services/quick_action_services.dart';
import '../../../app/resources/value_manger.dart';
import '../../add_task/view/add_task_view.dart';
import '../../components/elevated_button.dart';
import '../../details_task/view/details_tasks_view.dart';
import 'pages/favorite_page/page/favorite_page.dart';
import 'pages/uncompleted_page/page/un_completed_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController _controller;
  void listenNotification() {
    // NotificationServices.onNotification.stream.listen(onClickedNotification);
    AwesomeNotifications().createdStream.listen((notification) {
      // context.showToast('Notification listen now');
    });
    AwesomeNotifications().actionStream.listen((notification) {
      actionListenNotification(notification);
    });
  }

  void actionListenNotification(ReceivedNotification? notification) {
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
          title: 'Update Task to completed',
          textStyle: getRegularStyle(),
          paddingTitle: const EdgeInsets.all(AppSize.ap12),
          content: [
            Column(
              children: [
                const MyText(
                    title: "Do you want to update the task as completed?"),
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
                        child: const MyText(
                          title: "Yes",
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
                        child: const MyText(
                          title: "No",
                        )),
                  ],
                )
              ],
            )
          ]);
    }
  }

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!appLoaded) {
        listenNotification();
        di<QuickAction>().init(context);
        di<QuickAction>().addItems(context);
        appLoaded = true;
      }
    });

    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllow) {
      if (!isAllow) {
        context.showAlerts(
            title: 'Allow Notification',
            textStyle: getRegularStyle(),
            paddingTitle: const EdgeInsets.all(AppSize.ap12),
            content: [
              Column(
                children: [
                  const MyText(
                      title: 'Our App would like to send you notifications.'),
                  const SizedBox(
                    height: AppSize.ap12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyElevatedButton(
                          title: 'Don\'t Allow',
                          onPressed: () {
                            context.back();
                          }),
                      MyElevatedButton(
                          title: 'Allow',
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: MyAppBar(
              controller: _controller,
            )),
        body: SizedBox(
          height: context.height,
          child: Stack(
            children: [
              SizedBox(
                height: context.height * .75,
                child: TabBarView(
                    controller: _controller,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(AppSize.ap12),
                        child: HomePage(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppSize.ap12),
                        child: CompletedPage(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppSize.ap12),
                        child: UnCompletedPage(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppSize.ap12),
                        child: FavoritePage(),
                      ),
                    ]),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: MyElevatedButton(
                    title: context.strings().addATask,
                    onPressed: () {
                      context.push(const AddTaskView());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
