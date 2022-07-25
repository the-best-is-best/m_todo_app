import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/extension/form_state_extension.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/app/extension/time_of_day_extension.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/presentation/add_task/cubit/add_task_cubit.dart';
import 'package:m_todo_app/presentation/add_task/cubit/add_task_state.dart';
import '../../../app/functions/functions.dart';
import '../../../app/resources/font_manager.dart';
import '../../../app/resources/value_manger.dart';
import '../../components/elevated_button.dart';
import '../../components/text.dart';
import '../../components/text_form_field.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({Key? key}) : super(key: key);

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController _datelineController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings().addATask),
        elevation: 1,
      ),
      body: BlocProvider(
        create: (context) => AddTaskCubit(),
        child: BlocBuilder<AddTaskCubit, AddTaskState>(
          builder: (context, state) {
            AddTaskCubit addTaskCubit = AddTaskCubit.get(context);

            return Padding(
              padding: const EdgeInsets.all(AppSize.ap12),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: context.height * .80,
                          width: context.width,
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyTextFormField(
                                    title: context.strings().title,
                                    onSaved: (String? val) {
                                      addTaskCubit.addTitle(val ?? "");
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
                                    multiline: true,
                                    title: context.strings().description,
                                    onSaved: (String? val) {
                                      addTaskCubit.addDescription(val ?? "");
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
                                    onTap: () async {
                                      String val =
                                          await context.showMyDatePicker();
                                      _datelineController.text = val;
                                    },
                                    onSaved: (String? val) {
                                      addTaskCubit.addDate(val ?? "");
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return context.strings().required;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.all(AppSize.ap8)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyTextFormField(
                                          controller: _startTimeController,
                                          suffixIcon: const Icon(
                                              Icons.watch_later_outlined),
                                          title: context.strings().startTime,
                                          onTap: () async {
                                            String val = await context
                                                .showMyTimePicker();
                                            _startTimeController.text = val;
                                          },
                                          onSaved: (String? val) {
                                            addTaskCubit
                                                .addStartTime(val ?? "");
                                          },
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return context.strings().required;
                                            }
                                            TimeOfDay timeValue = val
                                                .convertTimeStringToTimeOfDay();
                                            if (_datelineController
                                                .text.isEmpty) {
                                              return context
                                                  .strings()
                                                  .selectDate;
                                            }
                                            if (_datelineController
                                                    .text.isNotEmpty &&
                                                isDateSelectionEqualDateNow(
                                                    _datelineController)) {
                                              if (timeValue.isBeforeTimeNow()) {
                                                return context
                                                    .strings()
                                                    .timeStartLessThanTimeNow;
                                              }
                                            }
                                            if (_endTimeController
                                                .text.isEmpty) {
                                              return context
                                                  .strings()
                                                  .selectEndTime;
                                            }
                                            TimeOfDay timeEndValue =
                                                _endTimeController.text
                                                    .convertTimeStringToTimeOfDay();
                                            if (timeValue.isAfterAnotherTime(
                                                timeEndValue)) {
                                              return context
                                                  .strings()
                                                  .timeStartAfterThanEndTime;
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.ap12),
                                      Expanded(
                                        child: MyTextFormField(
                                          controller: _endTimeController,
                                          suffixIcon: const Icon(
                                              Icons.watch_later_outlined),
                                          title: context.strings().endTime,
                                          onTap: () async {
                                            String val = await context
                                                .showMyTimePicker();
                                            _endTimeController.text = val;
                                          },
                                          onSaved: (String? val) {
                                            addTaskCubit.addEndTime(val ?? "");
                                          },
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return context.strings().required;
                                            }
                                            TimeOfDay timeValue = val
                                                .convertTimeStringToTimeOfDay();
                                            if (_datelineController
                                                .text.isEmpty) {
                                              return context
                                                  .strings()
                                                  .selectDate;
                                            }
                                            if (_datelineController
                                                    .text.isNotEmpty &&
                                                isDateSelectionEqualDateNow(
                                                    _datelineController)) {
                                              if (timeValue.isBeforeTimeNow()) {
                                                return context
                                                    .strings()
                                                    .timeEndLessThanTimeNow;
                                              }
                                            }
                                            if (_startTimeController
                                                .text.isEmpty) {
                                              return context
                                                  .strings()
                                                  .selectEndTime;
                                            }
                                            TimeOfDay timeStartValue =
                                                _startTimeController.text
                                                    .convertTimeStringToTimeOfDay();
                                            if (timeValue.isBeforeAnotherTime(
                                                timeStartValue)) {
                                              return context
                                                  .strings()
                                                  .timeEndLessThanStartTime;
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSize.ap12),
                                  MyText(
                                    title: context.strings().remind,
                                    style: getBoldStyle(fontSize: FontSize.s20),
                                  ),
                                  const SizedBox(height: AppSize.ap8),
                                  Container(
                                    color: Colors.grey[200],
                                    child: DropdownButtonFormField<int>(
                                      validator: (val) {
                                        if (val == null) {
                                          return context.strings().required;
                                        } else {
                                          return null;
                                        }
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          value: 0,
                                          child: MyText(
                                            title:
                                                context.strings().tenMinBefore,
                                            style: getRegularStyle(),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 1,
                                          child: MyText(
                                            title: context
                                                .strings()
                                                .thirtyMinBefore,
                                            style: getRegularStyle(),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: MyText(
                                            title:
                                                context.strings().oneHourBefore,
                                            style: getRegularStyle(),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 3,
                                          child: MyText(
                                            title:
                                                context.strings().oneDayBefore,
                                            style: getRegularStyle(),
                                          ),
                                        ),
                                      ],
                                      onChanged: (val) {},
                                      onSaved: (val) {
                                        addTaskCubit.addRemained(val ?? 0);
                                      },
                                    ),
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
                                        title:
                                            context.strings().selectColorTask,
                                        paddingTitle:
                                            const EdgeInsets.all(AppSize.ap8),
                                        textStyle: getRegularStyle(),
                                        content: [
                                          Column(
                                            children: [
                                              ColorPicker(
                                                pickerColor: addTaskCubit
                                                    .addTaskFreezed.color
                                                    .convertToColor(),
                                                onColorChanged: (Color value) {
                                                  //print(value.toString());
                                                  addTaskCubit.addColor(
                                                      value.toString());
                                                },
                                              ),
                                              const SizedBox(
                                                height: AppSize.ap12,
                                              ),
                                              MyElevatedButton(
                                                  title: 'Save',
                                                  onPressed: () {
                                                    context.back();
                                                  })
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        width: context.width,
                                        height: 10,
                                        color: addTaskCubit.addTaskFreezed.color
                                            .convertToColor(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          left: 5,
                          child: MyElevatedButton(
                              title: context.strings().createATask,
                              onPressed: () {
                                if (!_formKey.isValid()) {
                                  return;
                                }
                                _formKey.save();
                                addTaskCubit.addNewTask(context);
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
