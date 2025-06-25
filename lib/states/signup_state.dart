class SignUpState {
  final String name;
  final String email;
  final String password;
  final String repassword;
  final bool obscureText;
  final bool isLoggedIn;

  const SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.repassword = '',
    this.obscureText = true,
    this.isLoggedIn = false,
  });

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? repassword,
    bool? obscureText,
    bool? isLoggedIn,
  }) =>
      SignUpState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        repassword: repassword ?? this.repassword,
        obscureText: obscureText ?? this.obscureText,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      );
}
