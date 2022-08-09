import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../app/cubit/app_cubit.dart';
import '../../../app/resources/font_manager.dart';
import '../../../app/resources/styles_manger.dart';
import '../../../app/resources/value_manger.dart';
import '../../../services/events_services.dart';
import '../../details_task/view/details_tasks_view.dart';
import '../../home/view/widgets/success_icon_tasks.dart';
import '../cubit/schedule_cubit.dart';

class BuildCalendar extends StatelessWidget {
  const BuildCalendar({
    Key? key,
    required this.scheduleCubit,
    required this.appCubit,
  }) : super(key: key);

  final ScheduleCubit scheduleCubit;
  final AppCubit appCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.ap8) +
          EdgeInsets.only(
              bottom: ScheduleCubit.myBanner.size.height.toDouble()),
      child: SfCalendar(
        todayHighlightColor: Colors.green,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            appointmentDisplayCount: 3,
            agendaItemHeight: 100,
            agendaViewHeight: context.height * .45,
            monthCellStyle: MonthCellStyle(
              textStyle: getMediumStyle(color: Colors.black87),
              leadingDatesTextStyle: getLightStyle(),
              trailingDatesTextStyle: getLightStyle(),
            ),
            agendaStyle: AgendaStyle(
              dayTextStyle: getRegularStyle(color: Colors.black87),
              dateTextStyle: getRegularStyle(color: Colors.black87),
              appointmentTextStyle: getRegularStyle(color: Colors.white),
            ),
            showAgenda: true),
        appointmentBuilder:
            (BuildContext buildContext, CalendarAppointmentDetails details) =>
                Column(
          children: details.appointments.map((dynamicItem) {
            TasksModel item = dynamicItem as TasksModel;
            return InkWell(
              onTap: () {
                context.push(
                  DetailsTasksView(task: item),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: item.color.convertToColor(),
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
                                item.startTime,
                                style: getMediumStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s18),
                              ),
                              const SizedBox(width: AppSize.ap12),
                              Container(
                                  width: 10, height: 2, color: Colors.white70),
                              const SizedBox(width: AppSize.ap12),
                              Text(
                                item.endTime,
                                style: getMediumStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s18),
                              )
                            ],
                          ),
                          const SizedBox(height: AppSize.ap12),
                          Text(
                            item.title,
                            style: getMediumStyle(
                                color: Colors.white, fontSize: FontSize.s24),
                          )
                        ],
                      ),
                      IconSuccess(
                        tasks: item,
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        showDatePickerButton: true,
        todayTextStyle: getMediumStyle(color: Colors.white),
        initialSelectedDate: appCubit.allTasks.isNotEmpty
            ? appCubit.allTasks[0].date.toDate()
            : DateTime.now(),
        appointmentTextStyle: getMediumStyle(),
        viewHeaderStyle: ViewHeaderStyle(
            dayTextStyle: getRegularStyle(), dateTextStyle: getRegularStyle()),
        headerStyle: CalendarHeaderStyle(textStyle: getRegularStyle()),
        minDate: appCubit.allTasks.isNotEmpty
            ? appCubit.allTasks[0].date.toDate().add(const Duration(days: -180))
            : DateTime.now(),
        maxDate: DateTime.now().add(const Duration(days: 180)),
        view: CalendarView.month,
        dataSource: EventDataSource(appCubit.allTasks),
      ),
    );
  }
}
