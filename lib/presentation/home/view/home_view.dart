import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_todo_app/app/di.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/presentation/home/view/pages/complated_page/page/completed_page.dart';
import 'package:m_todo_app/presentation/home/view/pages/home_page/page/home_page.dart';
import 'package:m_todo_app/presentation/home/view/widgets/app_bar.dart';
import 'package:m_todo_app/services/quick_action_services.dart';
import '../../../app/resources/value_manger.dart';
import '../../../services/notification_services.dart';
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
    NotificationServices.onNotification.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {
    if (payload != null) {
      Map taskNotificationMap = jsonDecode(payload) as Map;
      TasksModel taskNotification = TasksModel.fromJson(taskNotificationMap);
      context.push(const DetailsTasksView(), arguments: taskNotification);
      NotificationServices.onNotification.add(null);
    }
  }

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenNotification();
      di<QuickAction>().init(context);
      di<QuickAction>().addItems(context);
    });
    super.initState();
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
