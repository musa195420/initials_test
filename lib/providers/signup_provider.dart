import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/user_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';
import 'package:initial_test/states/signup_state.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  final _apiService = locator<IApiService>();
  final PrefService _prefService = locator<PrefService>();
  final _nav = locator<NavigationService>();
  SignUpNotifier() : super(const SignUpState());

  // ⚡ setters called by onChanged
  void setName(String v) => state = state.copyWith(name: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void setRePassword(String v) => state = state.copyWith(repassword: v);

  void togglePasswordVisibility() =>
      state = state.copyWith(obscureText: !state.obscureText);

  Future<void> registerUser(BuildContext ctx) async {
    try {} catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }
}

final signupProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier();
});
