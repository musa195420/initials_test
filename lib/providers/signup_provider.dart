import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/states/sigup_state.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier()
      : super(SignUpState(name: '', email: '', password: '', repassword: '')) {
    checkLoginStatus();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  Future<void> checkLoginStatus() async {}

  Future<void> registerUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      // Map<String, dynamic> userInfo = {
      //   "Name": state.nameController.text.trim(),
      //   "Email": state.emailController.text.trim(),
      //   "Wallet": "0",
      //   "Id": id,
      // };

      // await DataBaseMethods().addUserDetail(userInfo, id);
      // await SharedPreferenceHelper().saveUserName(userInfo["Name"]);
      // await SharedPreferenceHelper().saveUserEmail(userInfo["Email"]);
      // await SharedPreferenceHelper().saveUserWallet("0");
      // await SharedPreferenceHelper().saveUserId(id);
      // await SharedPreferenceHelper().saveLoginKey("true");

      state = state.copyWith(isLoggedIn: true);

      if (context.mounted) {
        //Goto Next Page Navigation Service
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Registration failed!";
      if (e.code == 'weak-password') {
        msg = "The provided password is too weak!";
      } else if (e.code == 'email-already-in-use') {
        msg = "An account with this email already exists!";
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    }
  }
}

final signupProvider = StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(),
);
