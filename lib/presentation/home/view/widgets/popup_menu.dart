import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/font_manager.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';

import '../../../../app/resources/styles_manger.dart';

class BuildPopupMenu extends StatelessWidget {
  const BuildPopupMenu({
    Key? key,
    required this.task,
    required this.cubit,
  }) : super(key: key);

  final TasksModel task;
  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu<int>(
      icon: Icon(Icons.more_horiz_rounded, size: FontSize.s30),
      menuItems: [
        PopupMenuItem<int>(
          value: 0,
          enabled: task.status == 0 ? false : true,
          child: Text(
            context.strings().unCompleted,
            style: task.status == 0 ? getLightStyle() : getRegularStyle(),
          ),
        ),
        PopupMenuItem<int>(
          enabled: task.status == 1 ? false : true,
          value: 1,
          child: Text(
            context.strings().completed,
            style: task.status == 1 ? getLightStyle() : getRegularStyle(),
          ),
        ),
        PopupMenuItem<int>(
          enabled: task.status == 2 ? false : true,
          value: 2,
          child: Text(
            task.fav == 0
                ? context.strings().favorite
                : context.strings().unFavorite,
            style: getRegularStyle(),
          ),
        ),
      ],
      onSelected: (int value) {
        cubit.changeStatusTask(task.id, value);
      },
      tooltip: "Here's a tip for you.",
      elevation: 12,
      offset: const Offset(0, 45),
    );
  }
}
