import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/app/resources/font_manager.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/app/resources/value_manger.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_cubit.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_states.dart';
import '../../../app/cubit/app_cubit.dart';
import '../../home/view/widgets/success_icon_tasks.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocProvider(
      create: (context) => ScheduleCubit()..pushAllTasks(appCubit.allTasks),
      child: BlocBuilder<ScheduleCubit, ScheduleStates>(
        builder: (context, state) {
          ScheduleCubit scheduleCubit = ScheduleCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 150,
              title: Text(
                context.strings().schedule,
                style: getMediumStyle(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Column(
                  children: [
                    const Divider(),
                    DatePicker(
                      appCubit.allTasks.isNotEmpty
                          ? appCubit.allTasks[0].date.toDate()
                          : DateTime.now(),
                      daysCount: appCubit.totalDays,
                      initialSelectedDate: appCubit.allTasks.isNotEmpty
                          ? appCubit.allTasks[0].date
                                  .toDate()
                                  .isAfter(DateTime.now())
                              ? appCubit.allTasks[0].date.toDate()
                              : DateTime.now()
                          : DateTime.now(),
                      dateTextStyle: getRegularStyle(),
                      monthTextStyle: getRegularStyle(),
                      dayTextStyle: getLightStyle(fontSize: 0),
                      selectionColor: Colors.green,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        scheduleCubit.getTasksByDate(date);
                      },
                    ),
                    const SizedBox(height: AppSize.ap8),
                    Container(
                      width: context.width,
                      height: 1,
                      color: Colors.black12,
                    )
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  top: AppSize.ap12, left: AppSize.ap12, right: AppSize.ap12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        scheduleCubit.dayName,
                        style: getMediumStyle(),
                      ),
                      Text(
                        scheduleCubit.dateSelected,
                        style: getRegularStyle(),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(AppSize.ap12)),
                  SizedBox(
                    height: context.height * .7,
                    child: ListView.separated(
                      itemCount: scheduleCubit.tasksInDate.length,
                      itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: scheduleCubit.tasksInDate[index].color
                            .convertToColor(),
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
                                        scheduleCubit
                                            .tasksInDate[index].startTime,
                                        style: getMediumStyle(
                                            color: Colors.white,
                                            fontSize: FontSize.s18),
                                      ),
                                      const SizedBox(width: AppSize.ap12),
                                      Container(
                                          width: 10,
                                          height: 2,
                                          color: Colors.white70),
                                      const SizedBox(width: AppSize.ap12),
                                      Text(
                                        scheduleCubit
                                            .tasksInDate[index].endTime,
                                        style: getMediumStyle(
                                            color: Colors.white,
                                            fontSize: FontSize.s18),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: AppSize.ap12),
                                  Text(
                                    scheduleCubit.tasksInDate[index].title,
                                    style: getMediumStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s24),
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
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: AppSize.ap12);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
