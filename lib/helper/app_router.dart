import 'package:initial_test/views/login.dart';
import 'package:initial_test/views/not_found_page.dart';
import 'package:initial_test/views/signup.dart';
import 'package:initial_test/views/startup.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String startup = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String notFound = '/notfound';

  static final List<GetPage> pages = [
    GetPage(
      name: startup,
      page: () => const StartupPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: login,
      page: () => LogIn(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: signup,
      page: () => SignUp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: notFound,
      page: () => const NotFoundPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
