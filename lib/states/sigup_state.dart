class SignUpState {
  final String name;
  final String email;
  final String password;
  final String repassword;
  final bool isLoggedIn;
  final bool obscureText;

  SignUpState({
    required this.name,
    required this.email,
    required this.password,
    required this.repassword,
    this.isLoggedIn = false,
    this.obscureText = true,
  });

  SignUpState copyWith({
    bool? isLoggedIn,
    bool? obscureText,
  }) {
    return SignUpState(
      name: name,
      email: email,
      password: password,
      repassword: repassword,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}
