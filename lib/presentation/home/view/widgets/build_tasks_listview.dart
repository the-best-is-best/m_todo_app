import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/font_manager.dart';
import 'package:m_todo_app/presentation/home/view/widgets/popup_menu.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/resources/styles_manger.dart';
import '../../../../app/resources/value_manger.dart';
import '../../../../domain/model/tasks_model.dart';
import '../../../details_task/view/details_tasks_view.dart';
import 'build_success_icon_in_home.dart';

class BuildTasksListView extends StatelessWidget {
  const BuildTasksListView({
    Key? key,
    required this.appCubit,
    required this.task,
  }) : super(key: key);

  final TasksModel task;
  final AppCubit appCubit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(const DetailsTasksView(), arguments: task);
      },
      child: Dismissible(
        key: Key(task.id.toString()),
        background: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.delete, size: FontSize.s30, color: Colors.red),
            Icon(Icons.delete, size: FontSize.s30, color: Colors.red),
          ],
        ),
        onDismissed: ((direction) {
          appCubit.deleteTask(task.id);
        }),
        child: Row(
          children: [
            BuildSuccessIconInHome(task: task),
            const SizedBox(width: AppSize.ap20),
            Text(
              task.title,
              style: getRegularStyle(),
            ),
            const Spacer(),
            BuildPopupMenu(task: task, cubit: appCubit),
          ],
        ),
      ),
    );
  }
}
