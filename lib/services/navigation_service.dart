import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NavigationService {
  NavigationService._privateConstructor();
  static final NavigationService _instance =
      NavigationService._privateConstructor();
  static NavigationService get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void goTo(String routeName, {Object? arguments, bool replace = false}) {
    if (replace) {
      Get.offNamed(routeName, arguments: arguments);
    } else {
      Get.toNamed(routeName, arguments: arguments);
    }
  }

  void goToAndClear(String routeName, {Object? arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  void goBack([Object? result]) {
    if (Get.key.currentState?.canPop() == true) {
      Get.back(result: result);
    }
  }
}
