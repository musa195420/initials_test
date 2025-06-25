import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateChangesProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

/// Optional helper if you only need a `bool`
final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  return user != null;
});
