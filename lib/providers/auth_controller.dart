import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final Rxn<User> userRx = Rxn<User>(); // Rxn allows null

  @override
  void onInit() {
    super.onInit();
    // Listen to Firebase auth changes and assign to userRx
    // Listen to Firebase auth state and assign to userRx
    FirebaseAuth.instance.authStateChanges().listen((user) {
      userRx.value = user; // <- THIS MUST BE PRESENT!
    });
  }
}
