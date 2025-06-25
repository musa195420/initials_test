import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:initial_test/models/hive_models/hive_user.dart';
import 'package:initial_test/repos/user_repo.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';
import 'package:initial_test/view_models/authentication_view_model.dart';
import 'package:initial_test/view_models/login_view_model.dart';
import 'package:initial_test/view_models/signup_view_model.dart';

GetIt locator = GetIt.instance;

class LocatorInjector {
  static Future<void> setupLocator() async {
    try {
      locator.registerLazySingleton(() => NavigationService.instance);
      locator.registerLazySingleton<IFirebaseService>(() => FirebaseService());
      locator.registerLazySingleton(() =>
          PrefService()); //Usage    _prefService.setString(PrefKey.token, response.accessToken ?? "");  _prefService.getString(PrefKey.refreshToken)

      locator.registerLazySingleton(() => AuthenticationViewModel());
      locator.registerLazySingleton(() => SignUpViewModel());
      locator.registerLazySingleton(() => LogInViewModel());
      locator
          .registerLazySingleton<IHiveService<HiveUser>>(() => HiveUserRepo());
    } catch (e) {
      debugPrint("Error ==> ${e.toString()}");
    }
  }
}
