import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_todo_app/app/di.dart';
import 'package:m_todo_app/services/admob_services.dart';

import 'app/app.dart';
import 'services/my_bloc_observer.dart';

late String language;
bool appLoaded = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications()
      .initialize('resource://drawable/res_notification_app_icon', [
    NotificationChannel(
        channelKey: 'schedule_tasks',
        channelName: 'Schedule Tasks',
        channelDescription: 'Schedule Tasks',
        defaultColor: Colors.green,
        importance: NotificationImportance.Max,
        channelShowBadge: true)
  ]);
  await GetStorage.init();
  MobileAds.instance.initialize();
  AdmobServices.initInterstitial();
  await getLanguageDevice();

  await initAppModels();
  BlocOverrides.runZoned(
    () {
      runApp(Phoenix(child: const MyApp()));
    },
    blocObserver: MyBlocObserver(),
  );
}

Future getLanguageDevice() async {
  final box = GetStorage();

  if (box.read('lang') == null) {
    language = await Devicelocale.currentLocale ?? 'en';
    language = language.split('-')[0];
    box.write('lang', language);
  } else {
    language = box.read('lang');
  }
}
