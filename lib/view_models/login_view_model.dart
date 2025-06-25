// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/view_models/base_view_model.dart';

class LogInViewModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool obscureText = true;
  bool isLoggedIn = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // Update email
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  // Update password
  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  // Perform login
  Future<void> userLogin(BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (result.user != null) {
        isLoggedIn = true;
        _showPopup(context, 'Welcome back!', 15);
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'user-not-found') {
        _showPopup(context, 'No user registered for that e-mail address.', 12);
      } else {
        _showPopup(context, 'Login failed. Please try again.', 12);
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _showPopup(context, 'An unexpected error occurred.', 12);
    }
  }

  gotoSignup() {
    _nav.goTo(Routes.signup);
  }

  gotoHome() {
    _nav.goTo(Routes.notfound);
  }

  // Display snack bar
  void _showPopup(BuildContext context, String text, double size) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE50914),
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: size, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
