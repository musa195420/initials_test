// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/states/login_state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState()) {
    _checkLoginStatus();
  }

  /* ─────────────────────── UI setters ─────────────────────── */

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);

  void togglePasswordVisibility() =>
      state = state.copyWith(obscureText: !state.obscureText);

  /* ───────────────────  auth helpers ──────────────────── */

  Future<void> _checkLoginStatus() async {
    // Example:
    // final isLoggedInStr = await SharedPreferenceHelper().getLoginKey();
    // state = state.copyWith(isLoggedIn: isLoggedInStr == 'true');
  }

  Future<void> userLogin(BuildContext ctx) async {
    try {
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password,
      );
      if (res.user != null) {
        state = state.copyWith(isLoggedIn: true);
        _showPopup(ctx, 'Welcome back!', 15);
      }

      // state = state.copyWith(isLoggedIn: true);  // optionally update state
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'user-not-found') {
        _showPopup(ctx, 'No user registered for that e-mail address.', 12);
      } else {
        _showPopup(ctx, 'Login failed. Please try again.', 12);
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _showPopup(ctx, 'An unexpected error occurred.', 12);
    }
  }

  /* ──────────────────── misc ───────────────────── */

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
