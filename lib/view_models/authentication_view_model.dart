import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/view_models/base_view_model.dart';

class AuthenticationViewModel extends BaseViewModel {
  final _nav = locator<NavigationService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  // Constructor
  AuthenticationViewModel() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  bool isloading = false;
  Future<void> checkLogin() async {
    isloading = true;
    try {
      var res = FirebaseAuth.instance.currentUser;
      if (res == null) {
        gotoHome();
      } else {
        gotoLogin();
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  // Helper function to sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper function to sign in
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle error
      debugPrint("Error: $e");
    }
  }

  void gotoHome() {
    _nav.goTo(Routes.notfound, replace: true);
  }

  void gotoLogin() {
    _nav.goTo(Routes.login, replace: true);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _nav.goBack(Routes.login);
  }
}
