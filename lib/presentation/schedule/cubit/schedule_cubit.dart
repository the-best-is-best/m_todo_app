import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:m_todo_app/app/constant.dart';
import 'package:m_todo_app/app/extension/string_extensions.dart';
import 'package:m_todo_app/domain/model/tasks_model.dart';
import 'package:m_todo_app/main.dart';
import 'package:m_todo_app/presentation/schedule/cubit/schedule_states.dart';

class ScheduleCubit extends Cubit<ScheduleStates> {
  ScheduleCubit() : super(ScheduleInitStates());
  static ScheduleCubit get(context) => BlocProvider.of<ScheduleCubit>(context);

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
      adLoaded = false;
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
    emit(LoadADState());
  }

  void hideAd() {
    adLoaded = false;
    emit(LoadADState());
  }

  List<TasksModel> allTasks = [];

  List<TasksModel> tasksInDate = [];

  String dayName = "";
  String dateSelected = "";
  DateTime dateTimeSelected = DateTime.now();
  bool searchByCalender = false;
  void removeTasks() {
    allTasks.clear();
    emit(ScheduleGetTasksStates());
  }

  void changeSearchByCalender() {
    searchByCalender = !searchByCalender;
    emit(ScheduleSearchByStates());
  }

  void pushAllTasks(List<TasksModel> allTasksFromAppCubit) {
    allTasks = allTasksFromAppCubit;
    getTasksByDate(allTasks.isNotEmpty
        ? allTasks[0].date.toDate().isAfter(DateTime.now())
            ? allTasks[0].date.toDate()
            : DateTime.now()
        : DateTime.now());
  }

  void getTasksByDate(DateTime date) {
    emit(ScheduleLoadTasksStates());
    dayName = DateFormat('EEEE', language).format(date);
    dateSelected = DateFormat('dd MMM, yyyy', language).format(date);
    dateTimeSelected = date;
    tasksInDate = [];
    String dateFormat = Constants.inputFormat.format(date);
    for (TasksModel task in allTasks) {
      if (task.date.contains(dateFormat)) {
        tasksInDate.add(task);
      }
    }
    emit(ScheduleGetTasksStates());
  }
}
