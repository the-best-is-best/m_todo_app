import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/cubit/app_state.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/value_manger.dart';
import '../../../../../add_task/view/add_task_view.dart';
import '../../../../../components/elevated_button.dart';
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
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Stack(
          children: [
            SizedBox(
              height: context.height * .75,
              child: ListView.separated(
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
            ),
            Positioned(
              bottom: 0,
              left: 10,
              right: 10,
              child: MyElevatedButton(
                  title: context.strings().addATask,
                  onPressed: () {
                    context.push(const AddTaskView());
                  }),
            ),
          ],
        );
      },
    );
  }
}
