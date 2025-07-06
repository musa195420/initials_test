// lib/providers/logout_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';

import '../services/pref_service.dart';

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final _api = locator<IApiService>();
  final _dialog = locator<IDialogService>();

  final _nav = locator<NavigationService>();
  final _prefs = locator<PrefService>();
  final _hive = locator<IHiveService<UserProfile>>();

  LogoutNotifier() : super(const AsyncData(null));

  void logout() async {
    await _prefs.setString(PrefKey.token, '');
    await _prefs.setString(PrefKey.refreshToken, '');

    // fetch user profile

    await _hive.deleteAll();

    _nav.goTo(Routes.login);
  }

  void gotoHome() {
    _nav.goTo(Routes.home);
  }
}

final logoutProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
  return LogoutNotifier();
});
