import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/di.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/domain/model/received_notification.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/presentation/add_task/cubit/add_task_state.dart';
import 'package:m_todo_app/presentation/freezed/add_task_freezed.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/notification_services.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitState());
  static AddTaskCubit get(context) => BlocProvider.of<AddTaskCubit>(context);

  AddTaskFreezed addTaskFreezed = AddTaskFreezed(
    title: "",
    description: '',
    date: "",
    startTime: "",
    endTime: "",
    status: 0,
    fav: 0,
    remind: 0,
    color: Colors.red.toString(),
  );
  void addTitle(String title) {
    addTaskFreezed = addTaskFreezed.copyWith(title: title);
  }

  void addDescription(String desc) {
    addTaskFreezed = addTaskFreezed.copyWith(description: desc);
  }

  void addDate(String date) {
    addTaskFreezed = addTaskFreezed.copyWith(date: date);
  }

  void addStartTime(String startTime) {
    addTaskFreezed = addTaskFreezed.copyWith(startTime: startTime);
  }

  void addEndTime(String endTime) {
    addTaskFreezed = addTaskFreezed.copyWith(endTime: endTime);
  }

  void addStates(int status) {
    addTaskFreezed = addTaskFreezed.copyWith(status: status);
  }

  void addRemained(int remained) {
    addTaskFreezed = addTaskFreezed.copyWith(remind: remained);
  }

  void addColor(String color) {
    addTaskFreezed = addTaskFreezed.copyWith(color: color);
    emit(AddTaskChangeTaskColor());
  }

  void addNewTask(BuildContext context) async {
    String dateTimeStartScheduleString =
        "${addTaskFreezed.date} ${addTaskFreezed.startTime}";
    DateTime dateTimeStartSchedule = dateTimeStartScheduleString.toDateTime();

    String dateTimeEndScheduleString =
        "${addTaskFreezed.date} ${addTaskFreezed.endTime}";
    DateTime dateTimeEndSchedule = dateTimeEndScheduleString.toDateTime();

    switch (addTaskFreezed.status) {
      case 0:
        // ignore: prefer_const_constructors
        dateTimeStartSchedule =
            dateTimeStartSchedule.add(Duration(minutes: -10));
        break;
      case 1:
        // ignore: prefer_const_constructors
        dateTimeStartSchedule =
            dateTimeStartSchedule.add(Duration(minutes: -30));
        break;
      case 2:
        // ignore: prefer_const_constructors
        dateTimeStartSchedule = dateTimeStartSchedule.add(Duration(hours: -1));
        break;
      case 3:
        // ignore: prefer_const_constructors
        dateTimeStartSchedule = dateTimeStartSchedule.add(Duration(days: -1));
        break;
      default:
    }
    if (dateTimeStartSchedule.isBefore(DateTime.now())) {
      context.showToast(context.strings().errorRemind);
      return;
    }
    int id = await di<Database>().transaction((txn) async => await txn.rawInsert(
        """INSERT INTO tasks(title, description, date, startTime ,endTime , status , fav , remind , color) 
        VALUES("${addTaskFreezed.title}", "${addTaskFreezed.description}" ,"${addTaskFreezed.date}", "${addTaskFreezed.startTime}",
       "${addTaskFreezed.endTime}" ,  ${addTaskFreezed.status} , ${addTaskFreezed.fav} ,
         ${addTaskFreezed.remind} ,  "${addTaskFreezed.color}")"""));
    AppCubit appCubit = AppCubit.get(context);
    TasksModel newTaskData = TasksModel(
        id: id,
        title: addTaskFreezed.title,
        description: addTaskFreezed.description,
        date: addTaskFreezed.date,
        startTime: addTaskFreezed.startTime,
        endTime: addTaskFreezed.endTime,
        fav: 0,
        status: addTaskFreezed.status,
        remind: addTaskFreezed.remind,
        color: addTaskFreezed.color);
    appCubit.newTasksAdded(newTaskData);
    await di<NotificationServices>().createReminderNotification(
        ReceivedNotificationModel(
            title: addTaskFreezed.title,
            body: addTaskFreezed.description,
            dateTime: dateTimeStartSchedule,
            payload: TasksModel.toJsonString(newTaskData),
            id: id));
    await di<NotificationServices>().createReminderNotification(
        ReceivedNotificationModel(
            title: addTaskFreezed.title,
            body: "${addTaskFreezed.description} Ended",
            dateTime: dateTimeEndSchedule,
            payload: {'id': id.toString()},
            id: id * 1000));
    context.back();
  }
}
