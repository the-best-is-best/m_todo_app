import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../app/cubit/app_cubit.dart';
import '../../../../../../app/cubit/app_state.dart';
import '../../../../../../app/resources/value_manger.dart';
import '../../../widgets/build_tasks_listview.dart';
import '../../../widgets/no_tasks_available.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      return BuildCondition(
        condition: appCubit.favCompletedTasks.isNotEmpty,
        builder: (context) => ListView.separated(
          shrinkWrap: true,
          itemCount: appCubit.favCompletedTasks.length,
          itemBuilder: (context, index) => BuildTasksListView(
              appCubit: appCubit, task: appCubit.favCompletedTasks[index]),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: AppSize.ap20,
            );
          },
        ),
        fallback: (context) => const NoTasksAvailable(),
      );
    });
  }
}
