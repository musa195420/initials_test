// lib/providers/logout_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/navigation_service.dart';

import '../services/pref_service.dart';

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final _apiService = locator<IApiService>();
  final _dialogService = locator<IDialogService>();
  final PrefService _prefService = locator<PrefService>();
  final _nav = locator<NavigationService>();

  LogoutNotifier() : super(const AsyncData(null));
}

final logoutProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
  return LogoutNotifier();
});
