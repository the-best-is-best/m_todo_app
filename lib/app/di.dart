import 'package:get_it/get_it.dart';
import 'package:m_todo_app/services/init_sqlite.dart';

import '../services/notification_services.dart';
import '../services/quick_action_services.dart';

final di = GetIt.instance;

Future initAppModels() async {
  di.registerFactory(() => SqfliteInit());
  await di<SqfliteInit>().initDatabase();

  await di.unregister<SqfliteInit>();
  di.registerFactory(() => NotificationServices());
  di.registerFactory(() => QuickAction());
}
