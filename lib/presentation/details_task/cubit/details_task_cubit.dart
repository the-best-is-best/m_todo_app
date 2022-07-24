import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/presentation/details_task/cubit/details_task_states.dart';
import 'package:sqflite/sqflite.dart';
import '../../../app/cubit/app_cubit.dart';
import '../../../app/di.dart';
import '../../freezed/add_task_freezed.dart';

class DetailsTasksCubit extends Cubit<DetailsTasksStates> {
  DetailsTasksCubit() : super(DetailsTasksInitState());
  static DetailsTasksCubit get(context) =>
      BlocProvider.of<DetailsTasksCubit>(context);

  AddTaskFreezed updateTaskFreezed = AddTaskFreezed(
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
  void initData(
      {required int id,
      required String title,
      required String desc,
      required String date,
      required String startTime,
      required String endTime,
      required int status,
      required int fav,
      required int remind,
      required String color}) {
    addId(id);
    addTitle(title);
    addDescription(desc);
    addDate(date);
    addStartTime(startTime);
    addEndTime(endTime);
    addColor(color);
    addRemained(remind);
  }

  void addId(int id) {
    updateTaskFreezed = updateTaskFreezed.copyWith(id: id);
  }

  void addTitle(String title) {
    updateTaskFreezed = updateTaskFreezed.copyWith(title: title);
  }

  void addDescription(String desc) {
    updateTaskFreezed = updateTaskFreezed.copyWith(description: desc);
  }

  void addDate(String date) {
    updateTaskFreezed = updateTaskFreezed.copyWith(date: date);
  }

  void addStartTime(String startTime) {
    updateTaskFreezed = updateTaskFreezed.copyWith(startTime: startTime);
  }

  void addEndTime(String endTime) {
    updateTaskFreezed = updateTaskFreezed.copyWith(endTime: endTime);
  }

  void addStates(int status) {
    updateTaskFreezed = updateTaskFreezed.copyWith(status: status);
  }

  void addRemained(int remained) {
    updateTaskFreezed = updateTaskFreezed.copyWith(remind: remained);
  }

  void addColor(String color) {
    updateTaskFreezed = updateTaskFreezed.copyWith(color: color);
    emit(DetailsTaskChangeTaskColor());
  }

  void updateTask(BuildContext context) async {
    di<Database>().rawQuery(
        'UPDATE tasks SET title = "${updateTaskFreezed.title}" , description = "${updateTaskFreezed.description} ", color = "${updateTaskFreezed.color}" WHERE id = ${updateTaskFreezed.id}');

    AppCubit appCubit = AppCubit.get(context);

    appCubit.getTasks();
    context.back();
  }
}
