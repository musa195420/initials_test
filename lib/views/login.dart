import 'dart:math';
import 'package:flutter/material.dart';
import 'package:initial_test/view_models/login_view_model.dart';
import 'package:initial_test/widget_support/text_styles.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogInViewModel(),
      child: Consumer<LogInViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoggedIn && !hasNavigated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              hasNavigated = true;
              viewModel.gotoHome();
            });
          }

          final keyIcon = viewModel.obscureText
              ? const Icon(Icons.key)
              : const Icon(Icons.key_off_outlined);

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final double maxW = constraints.maxWidth;
                final double maxH = constraints.maxHeight;
                final double headerH = min(maxH * .35, 280);
                final double logoW = min(maxW * .45, 160);
                final double hPad = maxW < 500
                    ? 16
                    : maxW < 800
                        ? 32
                        : 64;

                return Stack(
                  children: [
                    _HeaderBackground(height: headerH, logoW: logoW),
                    _WhiteBottomBox(offset: headerH - 20),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: hPad)
                          .add(EdgeInsets.only(top: headerH - 60)),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            children: [
                              SizedBox(height: headerH / 2),
                              _FormCard(
                                emailController: emailController,
                                passController: passController,
                                keyIcon: keyIcon,
                                viewModel: viewModel,
                              ),
                              const SizedBox(height: 28),
                              _SignUpLink(viewModel),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/* ───────────────────── UI pieces ───────────────────── */

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.height, required this.logoW});
  final double height;
  final double logoW;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
        ),
      ),
      child: Column(
        children: [
          _Logo(width: logoW),
          const SizedBox(height: 14),
          const _Title('Login'),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _WhiteBottomBox extends StatelessWidget {
  const _WhiteBottomBox({required this.offset});
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: offset,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(text, style: SemiboldTextFieldStyle()),
      );
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.emailController,
    required this.passController,
    required this.keyIcon,
    required this.viewModel,
  });

  final TextEditingController emailController;
  final TextEditingController passController;
  final Icon keyIcon;
  final LogInViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration(
                'Email',
                const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: passController,
              obscureText: viewModel.obscureText,
              decoration: _inputDecoration(
                'Password',
                GestureDetector(
                  onTap: viewModel.togglePasswordVisibility,
                  child: keyIcon,
                ),
              ),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: () async {
                viewModel.setEmail(emailController.text.trim());
                viewModel.setPassword(passController.text);
                await viewModel.userLogin(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, Widget prefix) {
    return InputDecoration(
      hintText: hint,
      hintStyle: SemiboldTextFieldStyle(),
      prefixIcon: prefix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink(this.vm);
  final LogInViewModel vm;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: vm.gotoSignup,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Don\'t Have An Account? Sign Up',
            style: SemiboldTextFieldStyle(),
          ),
        ),
      );
}
