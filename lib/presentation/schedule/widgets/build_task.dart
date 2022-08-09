import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/presentation/details_task/view/details_tasks_view.dart';

import '../../../app/cubit/app_cubit.dart';
import '../../../app/cubit/app_state.dart';
import '../../../app/resources/font_manager.dart';
import '../../../app/resources/styles_manger.dart';
import '../../../app/resources/value_manger.dart';
import '../../home/view/widgets/success_icon_tasks.dart';
import '../cubit/schedule_cubit.dart';

class BuildTasks extends StatelessWidget {
  const BuildTasks({
    Key? key,
    required this.scheduleCubit,
  }) : super(key: key);

  final ScheduleCubit scheduleCubit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: scheduleCubit.tasksInDate.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          context.push(DetailsTasksView(
            task: scheduleCubit.tasksInDate[index],
            scheduleCubit: scheduleCubit,
          ));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: scheduleCubit.tasksInDate[index].color.convertToColor(),
          child: Padding(
            padding: const EdgeInsets.all(AppSize.ap12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          scheduleCubit.tasksInDate[index].startTime,
                          style: getMediumStyle(
                              color: Colors.white, fontSize: FontSize.s18),
                        ),
                        const SizedBox(width: AppSize.ap12),
                        Container(width: 10, height: 2, color: Colors.white70),
                        const SizedBox(width: AppSize.ap12),
                        Text(
                          scheduleCubit.tasksInDate[index].endTime,
                          style: getMediumStyle(
                              color: Colors.white, fontSize: FontSize.s18),
                        )
                      ],
                    ),
                    const SizedBox(height: AppSize.ap12),
                    Text(
                      scheduleCubit.tasksInDate[index].title,
                      style: getMediumStyle(
                          color: Colors.white, fontSize: FontSize.s24),
                    )
                  ],
                ),
                IconSuccess(
                  tasks: scheduleCubit.tasksInDate[index],
                )
              ],
            ),
          ),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: AppSize.ap12);
      },
    );
  }
}
