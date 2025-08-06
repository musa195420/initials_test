import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/auth_controller.dart';
import 'package:initial_test/services/navigation_service.dart';

final NavigationService _nav = Get.find<NavigationService>();

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final AuthController _authController = Get.find<AuthController>();
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _authController.userRx.value = user; // Update observable
      _navigateBasedOnUser(user);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateBasedOnUser(_authController.userRx.value);
    });
  }

  void _navigateBasedOnUser(User? user) {
    if (user != null) {
      _nav.goToAndClear(Routes.notfound);
    } else {
      _nav.goToAndClear(Routes.login);
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Project is starting, please wait…')),
    );
  }
}
