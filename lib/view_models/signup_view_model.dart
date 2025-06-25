import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/view_models/base_view_model.dart';

class SignUpViewModel extends BaseViewModel {
  final _firebase = locator<IFirebaseService>();
  final _nav = locator<NavigationService>();

  // Declare the variables for holding user input
  String name = '';
  String email = '';
  String password = '';
  String repassword = '';
  bool obscureText = true;

  // Setters to update values (can be called directly from UI)
  void setName(String value) {
    name = value;
  }

  void setEmail(String value) {
    email = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setRePassword(String value) {
    repassword = value;
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // Registration method
  Future<void> registerUser(BuildContext ctx) async {
    if (password != repassword) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
              content: Text('Passwords do not match'),
              backgroundColor: Colors.red),
        );
      }
      return;
    }

    try {
      var res = await _firebase.signUp(email: email, password: password);

      if (res is AuthSuccess<UserCredential>) {
        final user = res.data.user!;
        _nav.goTo(Routes.notfound);
        debugPrint('Registered user: ${user.displayName}');
      } else if (res is AuthFailure) {
        // Handle error
        if (ctx.mounted) {}
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
