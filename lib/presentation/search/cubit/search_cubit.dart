import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_todo_app/presentation/search/cubit/search_state.dart';

import '../../../domain/model/tasks_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitState());
  static SearchCubit get(context) => BlocProvider.of<SearchCubit>(context);
  List<TasksModel> allTasks = [];
  List<TasksModel> tasksInSearch = [];

  void pushAllTasks(List<TasksModel> allTasksFromAppCubit) {
    allTasks = allTasksFromAppCubit;
  }

  void searchForTask(String taskName) {
    emit(SearchLoadTasksState());
    tasksInSearch = [];
    if (taskName.length <= 3) {
      return;
    }
    for (var task in allTasks) {
      if (task.title.contains(taskName)) {
        tasksInSearch.add(task);
      }
    }
    emit(SearchGetTasksState());
  }
}
