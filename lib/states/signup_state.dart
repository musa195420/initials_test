import 'package:initial_test/models/response_models/role_model.dart';

class SignUpState {
  final String name;
  final String email;
  final String password;
  final String repassword;
  final String phone;
  final int roleId;
  final bool obscureText;
  final bool isLoggedIn;
  final List<RoleModel> roles;

  // ► live password‑rule flags
  final bool containsUpperCase;
  final bool containsLowerCase;
  final bool containsNumber;
  final bool containsSpecialChar;
  final bool contains8Length;
  final bool passwordsMatch;

  const SignUpState({
    this.phone = '',
    this.roleId = 1,
    this.name = '',
    this.email = '',
    this.password = '',
    this.repassword = '',
    this.obscureText = true,
    this.isLoggedIn = false,
    this.roles = const [],
    this.containsUpperCase = false,
    this.containsLowerCase = false,
    this.containsNumber = false,
    this.containsSpecialChar = false,
    this.contains8Length = false,
    this.passwordsMatch = false,
  });

  bool get allRulesPassed =>
      containsUpperCase &&
      containsLowerCase &&
      containsNumber &&
      containsSpecialChar &&
      contains8Length;

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? repassword,
    String? phone,
    int? roleId,
    bool? obscureText,
    bool? isLoggedIn,
    List<RoleModel>? roles,
    bool? containsUpperCase,
    bool? containsLowerCase,
    bool? containsNumber,
    bool? containsSpecialChar,
    bool? contains8Length,
    bool? passwordsMatch,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      repassword: repassword ?? this.repassword,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      obscureText: obscureText ?? this.obscureText,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      roles: roles ?? this.roles,
      containsUpperCase: containsUpperCase ?? this.containsUpperCase,
      containsLowerCase: containsLowerCase ?? this.containsLowerCase,
      containsNumber: containsNumber ?? this.containsNumber,
      containsSpecialChar: containsSpecialChar ?? this.containsSpecialChar,
      contains8Length: contains8Length ?? this.contains8Length,
      passwordsMatch: passwordsMatch ?? this.passwordsMatch,
    );
  }
}
