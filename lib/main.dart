import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_todo_app/app/di.dart';
import 'package:m_todo_app/services/notification_services.dart';

import 'app/app.dart';
import 'services/my_bloc_observer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

late String language;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  await GetStorage.init();

  await getLanguageDevice();

  await initAppModels();
  await di<NotificationServices>().init();

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

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
