// lib/services/firebase_service.dart
// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService implements IFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ───────────────────────────────────────── sign-up / sign-in

  @override
  Future<AuthResult<UserCredential>> signUp(
      {required String email, required String password}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthSuccess(cred);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Sign-up failed');
    }
  }

  @override
  Future<AuthResult<UserCredential>> signIn(
      {required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthSuccess(cred);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Sign-in failed');
    }
  }

  @override
  Future<AuthResult<UserCredential>> signInAnonymously() async {
    try {
      final cred = await _auth.signInAnonymously();
      return AuthSuccess(cred);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Anonymous sign-in failed');
    }
  }

  /// ───────────────────────────────────────── password / email helpers

  @override
  Future<AuthResult<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Reset e-mail failed');
    }
  }

  @override
  Future<AuthResult<void>> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.updateEmail(newEmail);
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Update e-mail failed');
    }
  }

  @override
  Future<AuthResult<void>> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Update password failed');
    }
  }

  @override
  Future<AuthResult<void>> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Verification e-mail failed');
    }
  }

  /// ───────────────────────────────────────── re-auth / sign-out / delete

  @override
  Future<AuthResult<UserCredential>> reAuthenticate(
      {required String email, required String password}) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: password);
      final res = await _auth.currentUser?.reauthenticateWithCredential(cred);
      return AuthSuccess(res!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Re-authentication failed');
    }
  }

  @override
  Future<AuthResult<void>> signOut() async {
    try {
      await _auth.signOut();
      return const AuthSuccess(null);
    } catch (e) {
      return const AuthFailure('Sign-out failed');
    }
  }

  @override
  Future<AuthResult<void>> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(e.message ?? 'Delete user failed');
    }
  }

  /// ───────────────────────────────────────── misc

  @override
  Future<User?> currentUser() async => _auth.currentUser;
}

/// Service contract
abstract interface class IFirebaseService {
  Future<AuthResult<UserCredential>> signUp(
      {required String email, required String password});

  Future<AuthResult<UserCredential>> signIn(
      {required String email, required String password});

  Future<AuthResult<UserCredential>> signInAnonymously();

  Future<AuthResult<void>> sendPasswordResetEmail(String email);

  Future<User?> currentUser();

  Future<AuthResult<void>> signOut();

  Future<AuthResult<void>> deleteUser();

  Future<AuthResult<void>> updateEmail(String newEmail);

  Future<AuthResult<void>> updatePassword(String newPassword);

  Future<AuthResult<void>> sendEmailVerification();

  /// Re-auth is required before sensitive ops (delete, email change, etc.)
  Future<AuthResult<UserCredential>> reAuthenticate(
      {required String email, required String password});
}

/// Return type for every auth call
sealed class AuthResult<T> {
  const AuthResult();
}

class AuthSuccess<T> extends AuthResult<T> {
  final T data;
  const AuthSuccess(this.data);
}

class AuthFailure<T> extends AuthResult<T> {
  final String message;
  const AuthFailure(this.message);
}
