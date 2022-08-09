import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:sqflite/sqflite.dart';
import '../di.dart';
import '../../domain/model/tasks_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  List<TasksModel> allTasks = [];
  List<TasksModel> completedTasks = [];
  List<TasksModel> unCompletedTasks = [];
  List<TasksModel> favCompletedTasks = [];
  int totalDays = 366 * 2;
  static bool adLoaded = false;
  static final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-7284367511062855/6466580005',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: listenerBanner,
  );
  static final BannerAdListener listenerBanner = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => adLoaded = true,
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // adLoaded = false;
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  );
  static AdWidget adWidget = AdWidget(ad: myBanner);
  void loadAd() async {
    while (adLoaded == false) {
      await Future.delayed(const Duration(seconds: 1), () => loadAd());
    }
    debugPrint(adLoaded.toString());
    adLoaded = true;
    emit(LoadADState());
  }

  void hideAd() {
    adLoaded = false;
    myBanner.dispose();
    emit(LoadADState());
  }

  void getTasks() async {
    allTasks = [];
    completedTasks = [];
    unCompletedTasks = [];
    favCompletedTasks = [];
    emit(AppLoadingTaskState());
    List<Map> list = await di<Database>().rawQuery('SELECT * FROM tasks');

    for (var value in list) {
      allTasks.add(TasksModel.fromJson(value));

      if (value['status'] == 0) {
        unCompletedTasks.add(TasksModel.fromJson(value));
      }
      if (value['status'] == 1) {
        completedTasks.add(TasksModel.fromJson(value));
      }
      if (value['fav'] == 1) {
        favCompletedTasks.add(TasksModel.fromJson(value));
      }
    }

    if (allTasks.isNotEmpty) {
      DateTime firstDate = allTasks[0].date.toDate();
      DateTime lastDate = allTasks[allTasks.length - 1].date.toDate();
      int totalDaysBetweenFistAndLastDays =
          lastDate.difference(firstDate).inDays;
      totalDays = totalDaysBetweenFistAndLastDays >= 360
          ? totalDaysBetweenFistAndLastDays + 1 + 360 * 2
          : 366 * 2;
    }
    emit(GetAllTasksState());
  }

  void newTasksAdded(TasksModel task) {
    emit(AppLoadingTaskState());

    allTasks.add(task);
    unCompletedTasks.add(task);
    emit(GetAllTasksState());
  }

  Future changeStatusTask(int taskId, int favOrCompleted) async {
    emit(AppLoadingTaskState());
    if (favOrCompleted == 1) {
      int fav = 0;
      TasksModel task = allTasks.firstWhere((e) => e.id == taskId);
      if (task.fav == 0) {
        fav = 1;
      }
      await di<Database>()
          .rawQuery('UPDATE tasks SET fav = $fav WHERE id = $taskId');
    } else {
      int completed = 0;
      TasksModel task = allTasks.firstWhere((e) => e.id == taskId);
      if (task.status == 0) {
        completed = 1;
      }
      await di<Database>()
          .rawQuery('UPDATE tasks SET status = $completed WHERE id = $taskId');
    }
    getTasks();
  }

  void updateTaskToCompleted(int taskId) {
    emit(AppLoadingTaskState());

    int completed = 1;
    TasksModel task = allTasks.firstWhere((e) => e.id == taskId);
    if (task.status == 1) {
      return;
    }
    di<Database>()
        .rawQuery('UPDATE tasks SET status = $completed WHERE id = $taskId');

    getTasks();
  }

  void deleteTask(int taskId) async {
    di<Database>().rawQuery('DELETE FROM tasks WHERE id =$taskId');
    await AwesomeNotifications().cancelSchedule(taskId);
    await AwesomeNotifications().cancelSchedule(taskId * 1000);

    getTasks();
  }
}
