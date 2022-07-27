import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m_todo_app/app/constant.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/main.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_states.dart';

class ScheduleCubit extends Cubit<ScheduleStates> {
  ScheduleCubit() : super(ScheduleInitStates());
  static ScheduleCubit get(context) => BlocProvider.of<ScheduleCubit>(context);
  List<TasksModel> allTasks = [];

  List<TasksModel> tasksInDate = [];

  String dayName = "";
  String dateSelected = "";

  void pushAllTasks(List<TasksModel> allTasksFromAppCubit) {
    allTasks = allTasksFromAppCubit;
    getTasksByDate(allTasks.isNotEmpty
        ? allTasks[0].date.toDate().isAfter(DateTime.now())
            ? allTasks[0].date.toDate()
            : DateTime.now()
        : DateTime.now());
  }

  void getTasksByDate(DateTime date) {
    emit(ScheduleLoadTasksStates());
    dayName = DateFormat('EEEE', language).format(date);
    dateSelected = DateFormat('dd MMM, yyyy', language).format(date);
    tasksInDate = [];
    String dateFormat = Constants.inputFormat.format(date);
    for (TasksModel task in allTasks) {
      if (task.date.contains(dateFormat)) {
        tasksInDate.add(task);
      }
    }
    emit(ScheduleGetTasksStates());
  }
}
