import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/cubit/app_state.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/value_manger.dart';
import 'package:m_todo_app/presentation/components/text.dart';
import '../../../widgets/build_tasks_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      return BuildCondition(
        condition: state is! AppLoadingTaskState,
        builder: (context) {
          return BuildCondition(
            condition: appCubit.allTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              itemCount: appCubit.allTasks.length,
              itemBuilder: (context, index) => BuildTasksListView(
                  appCubit: appCubit, task: appCubit.allTasks[index]),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: AppSize.ap20,
                );
              },
            ),
            fallback: (context) => Center(
              child: MyText(title: context.strings().noTasksAvailable),
            ),
          );
        },
        fallback: (context) => Center(child: CircularProgressIndicator()),
      );
    });
  }
}
