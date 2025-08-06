import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/user_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';

class LogoutController {
  final IApiService _apiService = Get.find<IApiService>();
  final IDialogService _dialogService = Get.find<IDialogService>();
  final PrefService _prefService = Get.find<PrefService>();
  final IFirebaseService _firebase = Get.find<IFirebaseService>();
  final NavigationService _nav = Get.find<NavigationService>();

  Future<void> logout() async {
    final result = await _firebase.signOut();

    switch (result) {
      case AuthSuccess():
        Future.microtask(() => _nav.goToAndClear(Routes.login));
        break;
      case AuthFailure(message: final msg):
        Get.snackbar('Logout Failed', msg,
            backgroundColor: Colors.red, colorText: Colors.white);
        break;
    }
  }

  Future<void> getUser() async {
    var userId = await _prefService.getString(PrefKey.userId);
    UserModel? user = await _apiService.getUserById(userId);
    if (user != null) {
      await _dialogService.showSuccess(text: user.email);
      debugPrint(user.id);
    }
  }
}
