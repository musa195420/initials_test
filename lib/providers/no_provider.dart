// lib/providers/logout_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/firebase_service.dart';
import 'package:initial_test/services/navigation_service.dart';

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final _firebase = locator<IFirebaseService>();
  final _nav = locator<NavigationService>();

  LogoutNotifier() : super(const AsyncData(null));

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await _firebase.signOut();

    switch (result) {
      case AuthSuccess():
        state = const AsyncData(null);
        _nav.goBack(Routes.login); // Use pushTo or replaceAll depending on flow
        break;
      case AuthFailure(message: final msg):
        state = AsyncError(msg, StackTrace.current);
        break;
    }
  }
}

final logoutProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
  return LogoutNotifier();
});
