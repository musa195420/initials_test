// A tiny immutable state class – no code‑gen needed.
class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscureText = true,
    this.isLoading = false,
  });

  final String email;
  final String password;
  final bool obscureText;
  final bool isLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscureText,
    bool? isLoading,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        obscureText: obscureText ?? this.obscureText,
        isLoading: isLoading ?? this.isLoading,
      );
}
