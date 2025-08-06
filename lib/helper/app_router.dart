import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/views/login.dart';
import 'package:initial_test/views/not_found_page.dart';
import 'package:initial_test/views/signup.dart';
import 'package:initial_test/views/startup.dart';
import 'package:get/get.dart';
import 'package:initial_test/views/user_page.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.startup,
      page: () => const StartupPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.login,
      page: () => LogIn(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignUp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.notfound,
      page: () => const NotFoundPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.userpage,
      page: () => const UserListPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
