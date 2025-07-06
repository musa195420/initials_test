import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/repos/user_repo.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/http_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';

GetIt locator = GetIt.instance;

class LocatorInjector {
  static Future<void> setupLocator() async {
    try {
      locator.registerLazySingleton(() => NavigationService.instance);

      locator.registerLazySingleton<IDialogService>(() => DialogService());

      locator.registerLazySingleton<IApiService>(() => ApiServiceImpl());
      locator.registerLazySingleton<PrefService>(() => PrefService());
      locator.registerLazySingleton<GlobalService>(() => GlobalService());
      locator.registerLazySingleton<HttpService>(() => HttpService());
      locator.registerLazySingleton<IHiveService<UserProfile>>(
          () => UserProfileRepo());
    } catch (e) {
      debugPrint("Error ==> ${e.toString()}");
    }
  }
}
