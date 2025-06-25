import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/firebase_options.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/helper/locator.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        // 2️⃣ FIRST
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await LocatorInjector.setupLocator(); // 3️⃣
      registerLoader();
      await configSettings();
      runApp(const MyApp());
    },
    (Object error, StackTrace stack) {
      debugPrint("Error in ${error.toString()} Stack ${stack.toString()}");
    },
  );
}

Future configSettings() async {
  // Init Services

  try {
    //init methods of all like init language errors locator<NotificationServices>().requestNotificationPermissions();
  } catch (e) {
    debugPrint("Error => $e");
  }
}

Future<void> registerLoader() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pulse
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.black,
            surface: Colors.white,
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
