import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransition {
  fade,
  slideFromRight,
  slideFromBottom,
  scale,
  none,
}

class NavigationService {
  NavigationService();
  NavigationService._privateConstructor();
  static final NavigationService _instance =
      NavigationService._privateConstructor();
  static NavigationService get instance => _instance;

  // ✅ Immediately initialized
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void goTo(String routeName, {Object? extra, bool replace = false}) {
    debugPrint('Navigating to $routeName');
    final context = navigatorKey.currentContext!;
    if (replace) {
      context.go(routeName, extra: extra);
    } else {
      context.push(routeName, extra: extra);
    }
  }

  void goToAndClear(String routeName, {Object? extra}) {
    final context = navigatorKey.currentContext!;
    context.go(routeName, extra: extra);
  }

  void goBack([Object? result]) {
    if (navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState?.pop(result);
    }
  }
}
