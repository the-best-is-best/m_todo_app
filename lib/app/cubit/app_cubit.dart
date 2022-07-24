import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/services/notification_services.dart';
import 'package:sqflite/sqflite.dart';
import '../di.dart';
import '../../domain/model/tasks_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  List<TasksModel> allTasks = [];
  List<TasksModel> completedTasks = [];
  List<TasksModel> unCompletedTasks = [];
  List<TasksModel> favCompletedTasks = [];
  int totalDays = 30;

  void getTasks() async {
    allTasks = [];
    completedTasks = [];
    unCompletedTasks = [];
    favCompletedTasks = [];
    emit(AppLoadingTaskState());
    List<Map> list = await di<Database>().rawQuery('SELECT * FROM tasks');

    for (var value in list) {
      allTasks.add(TasksModel.fromJson(value));

      if (value['status'] == 0) {
        unCompletedTasks.add(TasksModel.fromJson(value));
      }
      if (value['status'] == 1) {
        completedTasks.add(TasksModel.fromJson(value));
      }
      if (value['fav'] == 1) {
        favCompletedTasks.add(TasksModel.fromJson(value));
      }
    }
    if (allTasks.isNotEmpty) {
      DateTime firstDate = allTasks[0].date.toDate();
      DateTime lastDate = allTasks[allTasks.length - 1].date.toDate();
      int totalDaysBetweenFistAndLastDays =
          lastDate.difference(firstDate).inDays;
      totalDays = totalDaysBetweenFistAndLastDays > 30
          ? totalDaysBetweenFistAndLastDays
          : 30;
    }
    emit(GetAllTasksState());
  }

  void newTasksAdded(TasksModel task) {
    emit(AppLoadingTaskState());

    allTasks.add(task);
    unCompletedTasks.add(task);
    emit(GetAllTasksState());
  }

  void changeStatusTask(int taskId, int newStatus) {
    emit(AppLoadingTaskState());
    if (newStatus == 2) {
      int fav = 0;
      TasksModel task = allTasks.firstWhere((e) => e.id == taskId);
      if (task.fav == 0) {
        fav = 1;
      }
      di<Database>().rawQuery('UPDATE tasks SET fav = $fav WHERE id = $taskId');
    } else {
      di<Database>()
          .rawQuery('UPDATE tasks SET status = $newStatus WHERE id = $taskId');
    }
    getTasks();
  }

  void deleteTask(int taskId) {
    di<Database>().rawQuery('DELETE FROM tasks WHERE id =$taskId');
    di<NotificationServices>()
        .getFlutterLocalNotificationsPlugin()
        .cancel(taskId);
    getTasks();
  }
}
