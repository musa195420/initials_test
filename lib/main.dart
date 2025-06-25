import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:initial_test/firebase_options.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/services/hive_service.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

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
      HttpOverrides.global = CustomHttpOverrides();
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
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init("${appDocumentDirectory.path}/pet_adoption");
    await locator<IHiveService<User>>().init();
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

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
