import 'package:buildcondition/buildcondition.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_cubit.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_states.dart';
import '../../../app/cubit/app_cubit.dart';
import '../../../app/cubit/app_state.dart';
import '../widgets/build_calendar.dart';
import '../widgets/build_date_picker.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final DatePickerController _datePickerController = DatePickerController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickerController.jumpToSelection();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocProvider(
      create: (context) => ScheduleCubit()..loadAd(),
      child: BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
        return BlocBuilder<ScheduleCubit, ScheduleStates>(
          builder: (context, state) {
            ScheduleCubit scheduleCubit = ScheduleCubit.get(context);
            ScheduleCubit.myBanner.load();
            if (scheduleCubit.allTasks.isEmpty) {
              scheduleCubit.pushAllTasks(appCubit.allTasks);
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    context.strings().schedule,
                    style: getMediumStyle(),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          scheduleCubit.changeSearchByCalender();
                          if (!scheduleCubit.searchByCalender) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _datePickerController.jumpToSelection();
                              scheduleCubit.getTasksByDate(
                                appCubit.allTasks.isNotEmpty
                                    ? appCubit.allTasks[0].date
                                            .toDate()
                                            .isAfter(DateTime.now())
                                        ? appCubit.allTasks[0].date.toDate()
                                        : DateTime.now()
                                    : DateTime.now(),
                              );
                            });
                          }
                        },
                        icon: Icon(scheduleCubit.searchByCalender
                            ? Icons.calendar_view_week
                            : Icons.calendar_view_month_sharp))
                  ],
                ),
                body: Stack(
                  children: [
                    SizedBox(
                      height: context.height,
                      child: BuildCondition(
                        condition: !scheduleCubit.searchByCalender,
                        builder: (context) {
                          return BuildDatePicker(
                              appCubit: appCubit,
                              scheduleCubit: scheduleCubit,
                              datePickerController: _datePickerController);
                        },
                        fallback: (_) => BuildCalendar(
                            scheduleCubit: scheduleCubit, appCubit: appCubit),
                      ),
                    ),
                    BuildCondition(
                        condition: ScheduleCubit.adLoaded,
                        builder: (context) {
                          return Positioned(
                            bottom: ScheduleCubit.adLoaded ? 10 : 0,
                            left: 10,
                            right: 10,
                            child: Container(
                              alignment: Alignment.center,
                              width:
                                  ScheduleCubit.myBanner.size.width.toDouble(),
                              height:
                                  ScheduleCubit.myBanner.size.height.toDouble(),
                              child: ScheduleCubit.adWidget,
                            ),
                          );
                        }),
                  ],
                ));
          },
        );
      }),
    );
  }
}
