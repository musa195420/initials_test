import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/services/pref_service.dart';

class LoginController extends GetxController {
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool obscureText = true.obs;
  final RxBool isLoggedIn = false.obs;

  final PrefService _prefService = Get.find<PrefService>();

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void togglePasswordVisibility() => obscureText.value = !obscureText.value;

  Future<void> userLogin() async {
    try {
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );

      if (res.user != null) {
        await _prefService.setString(PrefKey.userId, res.user!.uid);
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.notFound);
        _showPopup('Welcome back!', 15);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'user-not-found') {
        _showPopup('No user registered for that e-mail address.', 12);
      } else {
        _showPopup('Login failed. Please try again.', 12);
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _showPopup('An unexpected error occurred.', 12);
    }
  }

  void _showPopup(String message, double size) {
    Get.snackbar(
      'Alert',
      message,
      backgroundColor: const Color(0xFFE50914),
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      duration: const Duration(seconds: 3),
      messageText: Text(
        message,
        style: TextStyle(fontSize: size, color: Colors.white),
      ),
    );
  }
}
