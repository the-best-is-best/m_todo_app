import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/cubit/app_state.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/value_manger.dart';
import 'package:m_todo_app/presentation/search/cubit/search_cubit.dart';
import 'package:m_todo_app/presentation/search/cubit/search_state.dart';

import '../../home/view/widgets/build_tasks_listview.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocProvider(
          create: (context) => SearchCubit()..pushAllTasks(appCubit.allTasks),
          child: BlocBuilder<SearchCubit, SearchStates>(
            builder: (context, state) {
              SearchCubit searchCubit = SearchCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: AppSize.ap12),
                      labelText: context.strings().search,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      searchCubit.searchForTask(value);
                    },
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(AppSize.ap12),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: searchCubit.tasksInSearch.length,
                    itemBuilder: (context, index) => BuildTasksListView(
                        appCubit: appCubit,
                        task: searchCubit.tasksInSearch[index]),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: AppSize.ap20,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
