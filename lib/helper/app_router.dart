import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/views/login.dart';
import 'package:initial_test/views/not_found_page.dart';
import 'package:initial_test/views/signup.dart';
import 'package:initial_test/views/startup.dart';

final router = GoRouter(
  initialLocation: Routes.startup,
  navigatorKey: NavigationService.instance.navigatorKey,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      // final product = state.extra as ProductModel;
      path: Routes.startup,
      pageBuilder: (_, __) => _buildPageWithTransition(
        const StartupPage(),
        //   HealthInfoPage(info: info),
        AppTransition.fade,
      ),
    ),
    GoRoute(
      path: Routes.login,
      pageBuilder: (_, __) => _buildPageWithTransition(
        const LogIn(),
        AppTransition.slideFromBottom,
      ),
    ),
    GoRoute(
      path: Routes.signup,
      pageBuilder: (_, __) => _buildPageWithTransition(
        const SignUp(),
        AppTransition.slideFromRight,
      ),
    ),
    GoRoute(
      path: Routes.notfound,
      pageBuilder: (_, __) => _buildPageWithTransition(
        const NotFoundPage(),
        AppTransition.slideFromRight,
      ),
    ),
  ],
);

CustomTransitionPage _buildPageWithTransition(
  Widget child,
  AppTransition transitionType,
) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case AppTransition.fade:
          return FadeTransition(opacity: animation, child: child);

        case AppTransition.slideFromRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );

        case AppTransition.slideFromBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );

        case AppTransition.scale:
          return ScaleTransition(scale: animation, child: child);

        case AppTransition.none:
          return child;
      }
    },
  );
}
