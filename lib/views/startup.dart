import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/providers/auth_controller.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    // ✅ Listen to changes
    ever<User?>(_authController.userRx, (user) {
      _navigateBasedOnUser(user);
    });

    // ✅ Also handle the initial value manually
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateBasedOnUser(_authController.userRx.value);
    });
  }

  void _navigateBasedOnUser(User? user) {
    if (user != null) {
      Get.offAllNamed(AppRoutes.notFound);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Project is starting, please wait…')),
    );
  }
}
