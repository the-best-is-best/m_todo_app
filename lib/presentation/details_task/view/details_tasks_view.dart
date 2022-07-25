import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/form_state_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/app/resources/value_manger.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/presentation/components/text.dart';
import 'package:m_todo_app/presentation/details_task/cubit/details_task_cubit.dart';
import 'package:m_todo_app/presentation/details_task/cubit/details_task_states.dart';
import '../../../app/resources/font_manager.dart';
import '../../components/elevated_button.dart';
import '../../components/text_form_field.dart';

class DetailsTasksView extends StatefulWidget {
  const DetailsTasksView({Key? key}) : super(key: key);

  @override
  State<DetailsTasksView> createState() => _DetailsTasksViewState();
}

class _DetailsTasksViewState extends State<DetailsTasksView> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  final TextEditingController _datelineController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TasksModel task =
        ModalRoute.of(context)!.settings.arguments as TasksModel;
    _taskTitleController.text = task.title;
    _taskDescriptionController.text = task.description;
    _datelineController.text = task.date;
    _startTimeController.text = task.startTime;
    _endTimeController.text = task.endTime;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings().detailsTask),
      ),
      body: BlocProvider(
        create: (context) => DetailsTasksCubit()
          ..initData(
              id: task.id,
              title: task.title,
              desc: task.description,
              date: task.date,
              startTime: task.startTime,
              endTime: task.endTime,
              status: task.status,
              fav: task.fav,
              color: task.color,
              remind: task.remind),
        child: BlocBuilder<DetailsTasksCubit, DetailsTasksStates>(
          builder: (context, state) {
            DetailsTasksCubit detailsTasksCubit =
                DetailsTasksCubit.get(context);

            return Padding(
              padding: const EdgeInsets.all(AppSize.ap12),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextFormField(
                                  controller: _taskTitleController,
                                  title: context.strings().title,
                                  onSaved: (String? val) {
                                    detailsTasksCubit.addTitle(val ?? "");
                                  },
                                  keyboardType: TextInputType.text,
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return context.strings().required;
                                    } else if (val.length < 5) {
                                      return "Title length less than 5";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(AppSize.ap8)),
                                MyTextFormField(
                                  controller: _taskDescriptionController,
                                  multiline: true,
                                  title: context.strings().description,
                                  onSaved: (String? val) {
                                    detailsTasksCubit.addDescription(val ?? "");
                                  },
                                  keyboardType: TextInputType.multiline,
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return context.strings().required;
                                    } else if (val.length < 5) {
                                      return "Title length less than 5";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(AppSize.ap8)),
                                MyTextFormField(
                                  controller: _datelineController,
                                  title: context.strings().date,
                                  enable: false,
                                  onTap: () async {
                                    String val =
                                        await context.showMyDatePicker();
                                    _datelineController.text = val;
                                  },
                                  onSaved: (String? val) {
                                    detailsTasksCubit.addDate(val ?? "");
                                  },
                                  validator: (val) {
                                    return null;
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(AppSize.ap8)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyTextFormField(
                                        enable: false,
                                        controller: _startTimeController,
                                        suffixIcon: const Icon(
                                            Icons.watch_later_outlined),
                                        title: context.strings().startTime,
                                        onTap: () async {
                                          String val =
                                              await context.showMyTimePicker();
                                          _startTimeController.text = val;
                                        },
                                        onSaved: (String? val) {
                                          detailsTasksCubit
                                              .addStartTime(val ?? "");
                                        },
                                        validator: (val) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.ap12),
                                    Expanded(
                                      child: MyTextFormField(
                                        enable: false,
                                        controller: _endTimeController,
                                        suffixIcon: const Icon(
                                            Icons.watch_later_outlined),
                                        title: context.strings().endTime,
                                        onTap: () async {
                                          String val =
                                              await context.showMyTimePicker();
                                          _endTimeController.text = val;
                                        },
                                        onSaved: (String? val) {
                                          detailsTasksCubit
                                              .addEndTime(val ?? "");
                                        },
                                        validator: (val) {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSize.ap12),
                                MyText(
                                  title: context.strings().selectColorTask,
                                  style: getBoldStyle(fontSize: FontSize.s20),
                                ),
                                const SizedBox(height: AppSize.ap8),
                                InkWell(
                                  onTap: () {
                                    context.showAlerts(
                                      barrierDismissible: true,
                                      title: context.strings().selectColorTask,
                                      paddingTitle:
                                          const EdgeInsets.all(AppSize.ap8),
                                      textStyle: getRegularStyle(),
                                      content: [
                                        Column(
                                          children: [
                                            ColorPicker(
                                              pickerColor: detailsTasksCubit
                                                  .updateTaskFreezed.color
                                                  .convertToColor(),
                                              onColorChanged: (Color value) {
                                                //print(value.toString());
                                                detailsTasksCubit
                                                    .addColor(value.toString());
                                              },
                                            ),
                                            const SizedBox(
                                              height: AppSize.ap12,
                                            ),
                                            MyElevatedButton(
                                                title: context.strings().save,
                                                onPressed: () {
                                                  context.back();
                                                })
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      width: context.width,
                                      height: 10,
                                      color: detailsTasksCubit
                                          .updateTaskFreezed.color
                                          .convertToColor(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          left: 5,
                          child: MyElevatedButton(
                              title: context.strings().updateATask,
                              onPressed: () {
                                if (!_formKey.isValid()) {
                                  return;
                                }
                                _formKey.save();
                                detailsTasksCubit.updateTask(context);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
