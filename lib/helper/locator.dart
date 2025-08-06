import 'package:get/get.dart';
import 'package:initial_test/models/hive_models/hive_user.dart';
import 'package:initial_test/repos/user_repo.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/firebase_database.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';

import 'package:initial_test/helper/error_debugger.dart' as d;

class LocatorInjector {
  static Future<void> setupLocator() async {
    try {
      Get.lazyPut(() => NavigationService.instance);
      Get.lazyPut<IFirebaseService>(() => FirebaseService());
      Get.lazyPut(() =>
          PrefService()); // Usage: Get.find<PrefService>().setString(...);

      Get.lazyPut<IFirebaseDatabase>(() => FirebaseDatabaseImpl());
      Get.lazyPut<IDialogService>(() => DialogService());
      Get.lazyPut<IApiService>(() => ApiServiceImpl());
      Get.lazyPut<IHiveService<HiveUser>>(() => HiveUserRepo());
    } catch (e, s) {
      d.printError(error: e.toString(), stack: s.toString(), tag: "locator");
    }
  }
}
