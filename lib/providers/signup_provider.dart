import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/user_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/states/signup_state.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  final _apiService = locator<IApiService>();
  final _firebase = locator<IFirebaseService>();
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
    try {
      var res =
          await _firebase.signUp(email: state.email, password: state.password);

      if (res is AuthSuccess<UserCredential>) {
        final user = res.data.user!;
        _apiService.addUser(UserModel(
            id: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            wallet: 0));
        _nav.goTo(Routes.notfound);
        debugPrint(user.displayName);
      } else if (res is AuthFailure) {
        // handle the error
        //showError(res.message);
      }
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'weak-password' => 'The provided password is too weak.',
        'email-already-in-use' => 'This email is already registered.',
        _ => 'Registration failed.',
      };
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    }
  }
}

final signupProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier();
});
