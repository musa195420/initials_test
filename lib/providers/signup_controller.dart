import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/models/user_model.dart';

class SignUpController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var repassword = ''.obs;
  var obscureText = true.obs;

  final PrefService _prefService = Get.find();
  final IApiService _apiService = Get.find();

  final NavigationService _nav = Get.find();

  void setName(String v) => name.value = v;
  void setEmail(String v) => email.value = v;
  void setPassword(String v) => password.value = v;
  void setRePassword(String v) => repassword.value = v;

  void togglePasswordVisibility() => obscureText.value = !obscureText.value;

  Future<void> registerUser() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.value, password: password.value);

      final user = credential.user!;
      _apiService.addUser(UserModel(
        id: user.uid,
        name: name.value,
        email: user.email ?? '',
        wallet: 0,
      ));
      _prefService.setString(PrefKey.userId, user.uid);
      _nav.goToAndClear(Routes.notfound);
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'weak-password' => 'The provided password is too weak.',
        'email-already-in-use' => 'This email is already registered.',
        _ => 'Registration failed.',
      };
      Get.snackbar('Error', msg,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
