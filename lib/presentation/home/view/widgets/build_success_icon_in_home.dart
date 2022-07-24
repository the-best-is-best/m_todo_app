import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/presentation/home/view/widgets/success_icon_tasks.dart';
import '../../../../domain/model/tasks_model.dart';

class BuildSuccessIconInHome extends StatelessWidget {
  const BuildSuccessIconInHome({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TasksModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: task.status == 0
              ? Border.all(
                  width: 2,
                  color: task.color.convertToColor(),
                )
              : null,
          color: task.status == 1 ? task.color.convertToColor() : null,
        ),
        child: IconSuccess(
          tasks: task,
        ));
  }
}
