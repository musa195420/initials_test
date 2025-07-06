import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/request_model/login_request.dart';
import 'package:initial_test/models/response_models/refresh_response.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';
import 'package:initial_test/states/login_state.dart';

/// ───────── Provider that the UI imports ─────────
final loginProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  // ───── dependencies ─────
  final _api = locator<IApiService>();
  final _dialog = locator<IDialogService>();
  final _nav = locator<NavigationService>();
  final _prefs = locator<PrefService>();
  final _hive = locator<IHiveService<UserProfile>>();
  final _glob = locator<GlobalService>();

  // ───── setters the UI uses ─────
  void setEmail(String v) =>
      state = state.copyWith(email: v.trim().toLowerCase());
  void setPassword(String v) => state = state.copyWith(password: v.trim());
  void togglePasswordVisibility() =>
      state = state.copyWith(obscureText: !state.obscureText);

  // ───── login action ─────
  Future<bool> userLogin() async {
    try {
      final res = await _api.login(
        LoginRequest(email: state.email, password: state.password),
      );

      if (res.errorCode != 'PA0004') {
        _dialog.showApiError(res.data);
        return false;
      }

      // success ⇒ store tokens
      final data = res.data as RefreshTokenResponse;
      await _prefs.setString(PrefKey.token, data.accessToken ?? '');
      await _prefs.setString(PrefKey.refreshToken, data.refreshToken ?? '');

      // fetch user profile
      final profRes =
          await _api.getUserProfileByEmail(UserProfile(email: state.email));
      if (profRes.errorCode == 'PA0004') {
        UserProfile user = profRes.data as UserProfile;
        await _hive.deleteAllAndAdd(profRes.data as UserProfile);
        _glob.setuser(user);
        if (user.roleId == 2) {
          _nav.goTo(Routes.driverhome);
          // _nav.goTo(Routes.driver);
          // _nav.goTo(Routes.vehicle);
        } else {
          _nav.goTo(Routes.notfound);
        }

        return true;
      } else {
        _dialog.showApiError(profRes.data);
        return false;
      }
    } catch (e, st) {
      printError(
          error: e.toString(), stack: st.toString(), tag: 'login_provider');
      _dialog.showApiError('Unexpected error: $e');
      return false;
    }
  }
}
