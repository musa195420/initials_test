import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/response_models/refresh_response.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';

final _prefService = locator<PrefService>();
IApiService get _apiService => locator<IApiService>();
IDialogService get _dialogService => locator<IDialogService>();

final _nav = locator<NavigationService>();
final _hive = locator<IHiveService<UserProfile>>();
final _glob = locator<GlobalService>();
String tag = "status_provider";

/// `true`  → navigate to *NotFound*
/// `false` → navigate to *Login*
final isSignedInProvider = FutureProvider<bool>((ref) async {
  final access = await _prefService.getString(PrefKey.token);
  final refresh = await _prefService.getString(PrefKey.refreshToken);

  // 1️⃣  either token missing → straight to login
  if (access.isEmpty || refresh.isEmpty) {
    _nav.goTo(Routes.login);
    return false;
  }

  // 2️⃣  try refresh
  try {
    final res = await _apiService
        .refreshToken(RefreshTokenResponse(refreshToken: refresh));

    if (res.errorCode == 'PA0004') {
      final data = res.data as RefreshTokenResponse;
      await _prefService.setString(PrefKey.token, data.accessToken ?? '');
      await _prefService.setString(
          PrefKey.refreshToken, data.refreshToken ?? '');
      UserProfile? user = await _hive.getFirstOrDefault();
      if (user != null) {
        final profRes = await _apiService
            .getUserProfileByEmail(UserProfile(email: user.email));
        if (profRes.errorCode == 'PA0004') {
          _glob.setuser(profRes.data as UserProfile);
          await _hive.deleteAllAndAdd(profRes.data as UserProfile);
          if (user.roleId == 2) {
            _nav.goTo(Routes.driverhome);
            // _nav.goTo(Routes.driver);
            // _nav.goTo(Routes.vehicle);
          } else {
            _nav.goTo(Routes.notfound);
          }
        }
      }
      return true; // ✅ success → NotFound
    }

    // 3️⃣  API answered but not PA0004
    _dialogService.showApiError(res.data);
    return false; // → Login
  } catch (e, st) {
    printError(error: e.toString(), stack: st.toString(), tag: tag);
    return false; // → Login
  }
});
