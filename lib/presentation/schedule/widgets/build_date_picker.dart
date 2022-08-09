import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';

import '../../../app/cubit/app_cubit.dart';
import '../../../app/resources/styles_manger.dart';
import '../../../app/resources/value_manger.dart';
import '../../../main.dart';
import '../cubit/schedule_cubit.dart';
import 'build_task.dart';

class BuildDatePicker extends StatelessWidget {
  const BuildDatePicker({
    Key? key,
    required this.appCubit,
    required this.scheduleCubit,
    required DatePickerController datePickerController,
  })  : _datePickerController = datePickerController,
        super(key: key);

  final AppCubit appCubit;
  final ScheduleCubit scheduleCubit;
  final DatePickerController _datePickerController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        DatePicker(
          locale: language,
          appCubit.allTasks.isNotEmpty
              ? appCubit.allTasks[0].date
                  .toDate()
                  .add(const Duration(days: -360))
              : DateTime.now(),
          daysCount: appCubit.totalDays,
          initialSelectedDate: appCubit.allTasks.isNotEmpty
              ? appCubit.allTasks[0].date.toDate().isAfter(DateTime.now())
                  ? appCubit.allTasks[0].date.toDate()
                  : DateTime.now()
              : DateTime.now(),
          dateTextStyle: getRegularStyle(),
          monthTextStyle: getRegularStyle(fontSize: 0),
          dayTextStyle: getRegularStyle(),
          selectionColor: Colors.green,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            scheduleCubit.getTasksByDate(date);
          },
          controller: _datePickerController,
        ),
        const SizedBox(height: AppSize.ap8),
        Container(
          width: context.width,
          height: 1,
          color: Colors.black12,
        ),
        Padding(
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
                height: ScheduleCubit.adLoaded
                    ? context.height * .65 - ScheduleCubit.myBanner.size.height
                    : context.height * .65,
                child: BuildTasks(scheduleCubit: scheduleCubit),
              ),
            ],
          ),
        )
      ],
    );
  }
}
