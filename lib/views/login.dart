import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/login_provider.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/states/login_state.dart';
import 'package:initial_test/widget_support/text_styles.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});
  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtl;
  late final TextEditingController _passCtl;

  @override
  void initState() {
    super.initState();
    final state = ref.read(loginProvider);
    _emailCtl = TextEditingController(text: state.email);
    _passCtl = TextEditingController(text: state.password);
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(loginProvider);
    final actions = ref.read(loginProvider.notifier);

    final keyIcon = ui.obscureText
        ? const Icon(Icons.key)
        : const Icon(Icons.key_off_outlined);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          final double maxW = c.maxWidth;
          final double maxH = c.maxHeight;
          final double headerH = min(maxH * .35, 280.0);
          final double logoW = min(maxW * .45, 160.0);
          final double hPad = maxW < 500
              ? 16.0
              : maxW < 800
                  ? 32.0
                  : 64.0;

          return Stack(
            children: [
              _HeaderBackground(height: headerH, logoW: logoW),
              _WhiteBottomBox(offset: headerH - 20.0),
              // ─── Main content ───
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad)
                    .add(EdgeInsets.only(top: headerH - 60.0)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        SizedBox(height: headerH / 2),
                        _FormCard(
                          formKey: _formKey,
                          emailCtl: _emailCtl,
                          passCtl: _passCtl,
                          keyIcon: keyIcon,
                          ui: ui,
                          actions: actions,
                        ),
                        const SizedBox(height: 28),
                        const _SignUpLink(),
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
  }
}

/* ────────────────── UI pieces ────────────────── */

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.height, required this.logoW});
  final double height, logoW;

  @override
  Widget build(BuildContext context) => Container(
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

class _WhiteBottomBox extends StatelessWidget {
  const _WhiteBottomBox({required this.offset});
  final double offset;

  @override
  Widget build(BuildContext context) => Positioned.fill(
        top: offset,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
        ),
      );
}

class _Logo extends StatelessWidget {
  const _Logo({required this.width});
  final double width;
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/logo.png', width: width);
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
              topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        child: Text(text, style: SemiboldTextFieldStyle()),
      );
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailCtl,
    required TextEditingController passCtl,
    required this.keyIcon,
    required this.ui,
    required this.actions,
  })  : _formKey = formKey,
        _emailCtl = emailCtl,
        _passCtl = passCtl;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailCtl, _passCtl;
  final Icon keyIcon;
  final LoginState ui;
  final LoginNotifier actions;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Email
                TextFormField(
                  controller: _emailCtl,
                  onChanged: actions.setEmail,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your e‑mail' : null,
                  decoration: _inputDecoration(
                      'Email', const Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 18),
                // Password
                TextFormField(
                  controller: _passCtl,
                  onChanged: actions.setPassword,
                  obscureText: ui.obscureText,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your password' : null,
                  decoration: _inputDecoration(
                    'Password',
                    GestureDetector(
                      onTap: actions.togglePasswordVisibility,
                      child: keyIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff5722),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  onPressed: ui.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final ok = await actions.userLogin();
                            if (!ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login failed')),
                              );
                            }
                          }
                        },
                  child: ui.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins1',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );

  InputDecoration _inputDecoration(String hint, Widget prefix) =>
      InputDecoration(
        hintText: hint,
        hintStyle: SemiboldTextFieldStyle(),
        prefixIcon: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();
  NavigationService get _nav => locator<NavigationService>();
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _nav.goTo(Routes.signup),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('Don\'t Have An Account? Sign Up',
              style: SemiboldTextFieldStyle()),
        ),
      );
}
