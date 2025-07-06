import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/helper_models/message_model.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/response_models/role_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/states/signup_state.dart';

String tag = "signup_provider";

final signupProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier();
});

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier() : super(const SignUpState()) {
    _loadRoles();
  }

  /* ───────── injected services ───────── */
  final _api = locator<IApiService>();
  final _dialog = locator<IDialogService>();
  final _nav = locator<NavigationService>();

  final _hive = locator<IHiveService<UserProfile>>();
  final _glob = locator<GlobalService>();

  /* ───────── simple field setters ────── */
  void setName(String v) => state = state.copyWith(name: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setRole(int id) => state = state.copyWith(roleId: id);

  /* ───────── password & rules ────────── */
  void setPassword(String v) => _updatePasswordFields(pwd: v);
  void setRePassword(String v) => _updatePasswordFields(re: v);

  Future<void> showRoles() async {
    try {
      List<String> items = [];
      for (var r in state.roles) {
        items.add("${r.code} \n ${r.description}");
      }
      int index = await _dialog
          .showSelect(Message(items: items, description: "Select You Role"));
      if (index != -1) {
        state = state.copyWith(roleId: state.roles[index].id);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }
  }

  void _updatePasswordFields({String? pwd, String? re}) {
    final password = pwd ?? state.password;
    final repassword = re ?? state.repassword;

    state = state.copyWith(
      password: pwd ?? state.password,
      repassword: re ?? state.repassword,
      containsUpperCase: _has(password, r'[A-Z]'),
      containsLowerCase: _has(password, r'[a-z]'),
      containsNumber: _has(password, r'\d'),
      containsSpecialChar:
          _has(password, r'[!@#\$&*~_\-\.(),;:<>?{}\[\]|\\\/]'),
      contains8Length: password.length >= 8,
      passwordsMatch: password == repassword,
    );
  }

  bool _has(String src, String pattern) => RegExp(pattern).hasMatch(src);

  /* ───────── eye‑icon toggle ─────────── */
  void togglePasswordVisibility() =>
      state = state.copyWith(obscureText: !state.obscureText);

  /* ───────── fetch roles once ────────── */
  Future<void> _loadRoles() async {
    try {
      final res = await _api.getRoles();
      if (res.errorCode == 'PA0004') {
        final roles = (res.data as List)
            .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
            .toList(growable: false);
        state = state.copyWith(roles: roles);
      } else {
        _dialog.showApiError(res.data);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }
  }

  /* ───────── register user ───────────── */
  Future<void> registerUser(BuildContext ctx) async {
    if (!state.allRulesPassed) return; // extra safety

    try {
      final res = await _api.registerProfile(
        UserProfile(
          fullName: state.name.trim(),
          email: state.email.trim(),
          password: state.password,
          phone: state.phone.trim(),
          roleId: state.roleId,
        ),
      );

      if (res.errorCode == 'PA0004') {
        _dialog.showSuccess(text: "User Registered Successfully");
        final profRes =
            await _api.getUserProfileByEmail(UserProfile(email: state.email));
        if (profRes.errorCode == 'PA0004') {
          _glob.setuser(profRes.data as UserProfile);
          await _hive.deleteAllAndAdd(profRes.data as UserProfile);
          _nav.goTo(Routes.notfound);
        }
      } else {
        _dialog.showApiError(res.data);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }
  }
}
