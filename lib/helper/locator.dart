import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';

GetIt locator = GetIt.instance;

class LocatorInjector {
  static Future<void> setupLocator() async {
    try {
      locator.registerLazySingleton(() => NavigationService.instance);
      locator.registerLazySingleton<IFirebaseService>(() => FirebaseService());
    } catch (e) {
      debugPrint("Error ==> ${e.toString()}");
    }
  }
}
