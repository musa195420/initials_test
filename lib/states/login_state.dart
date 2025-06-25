class LoginState {
  final String email;
  final String password;
  final bool obscureText;
  final bool isLoggedIn;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscureText = true,
    this.isLoggedIn = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscureText,
    bool? isLoggedIn,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        obscureText: obscureText ?? this.obscureText,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      );
}
