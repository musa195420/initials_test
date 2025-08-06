import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:initial_test/firebase_options.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/helper/error_debugger.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/providers/auth_controller.dart';
import 'package:initial_test/providers/login_controller.dart';
import 'package:initial_test/providers/no_provider.dart';
import 'package:initial_test/providers/signup_provider.dart';
import 'package:initial_test/services/pref_service.dart';
import 'package:initial_test/views/not_found_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

String tag = "main.dart";

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await LocatorInjector.setupLocator(); // Retain your DI setup
      registerLoader();
      await configSettings();
      HttpOverrides.global = CustomHttpOverrides();
      runApp(const MyApp());
    },
    (Object error, StackTrace stack) {
      printStackDebug(
          error: error.toString(), stack: stack.toString(), tag: tag);
    },
  );
}

Future configSettings() async {
  try {
    //await locator<PrefService>().init();

    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init("${appDocumentDirectory.path}/pet_adoption");
    final PrefService prefService = Get.find<PrefService>();
    await prefService.init(); // Must await before first usage
    Get.put(AuthController());
    Get.put(LoginController());
    Get.put(SignUpController());
    Get.put(LogoutController());
    // Example of using Get.put if you want to inject services this way
    //
    // Get.put(locator<IHiveService<HiveUser>>());
  } catch (e, s) {
    printStackDebug(tag: tag, error: e.toString(), stack: s.toString());
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
    ..maskColor = Colors.blue.withAlpha(128)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.startup,
      getPages: AppRoutes.pages,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const NotFoundPage(),
        transition: Transition.rightToLeft,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
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
