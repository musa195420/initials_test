// lib/providers/logout_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';

import '../models/user_model.dart';
import '../services/pref_service.dart';

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final _apiService = locator<IApiService>();
  final _dialogService = locator<IDialogService>();
  final PrefService _prefService = locator<PrefService>();
  final _firebase = locator<IFirebaseService>();
  final _nav = locator<NavigationService>();

  LogoutNotifier() : super(const AsyncData(null));

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await _firebase.signOut();

    switch (result) {
      case AuthSuccess():
        state = const AsyncData(null);
        Future.microtask(() => _nav
            .goTo(Routes.login)); // Use pushTo or replaceAll depending on flow
        break;
      case AuthFailure(message: final msg):
        state = AsyncError(msg, StackTrace.current);
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

final logoutProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
  return LogoutNotifier();
});
