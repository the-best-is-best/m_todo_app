import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../domain/model/tasks_model.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<TasksModel> tasks) {
    appointments = tasks;
  }
  TasksModel getTasks(int index) => appointments![index] as TasksModel;

  @override
  DateTime getStartTime(int index) => getTasks(index).date.toDate();

  @override
  String getSubject(int index) => getTasks(index).title;

  @override
  Color getColor(int index) => getTasks(index).color.convertToColor();
}
