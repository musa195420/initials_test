import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/signup_provider.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/widget_support/text_styles.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final navigationService = locator<NavigationService>();

  late final TextEditingController _nameCtl;
  late final TextEditingController _emailCtl;
  late final TextEditingController _passCtl;
  late final TextEditingController _repassCtl;

  @override
  void initState() {
    super.initState();
    final state = ref.read(signupProvider);
    _nameCtl = TextEditingController(text: state.name);
    _emailCtl = TextEditingController(text: state.email);
    _passCtl = TextEditingController(text: state.password);
    _repassCtl = TextEditingController(text: state.repassword);
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _repassCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final signupNotifier = ref.read(signupProvider.notifier);
    final keyIcon = state.obscureText
        ? const Icon(Icons.key)
        : const Icon(Icons.key_off_outlined);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;

          final headerH = min(maxH * .35, 280);
          final logoW = min(maxW * .45, 160);

          final hPad = maxW < 500
              ? 16
              : maxW < 800
                  ? 32
                  : 64;

          return Stack(
            children: [
              _HeaderBackground(
                  height: double.parse(headerH.toString()),
                  logoW: double.parse(logoW.toString())),
              _WhiteBottomBox(offset: headerH - 20),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad.toDouble())
                    .add(EdgeInsets.only(top: headerH - 60)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        SizedBox(height: headerH / 3),
                        _FormCard(
                          formKey: _formKey,
                          nameCtl: _nameCtl,
                          emailCtl: _emailCtl,
                          passCtl: _passCtl,
                          repassCtl: _repassCtl,
                          keyIcon: keyIcon,
                          state: state,
                          actions: signupNotifier,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => navigationService.goTo(Routes.login),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "Already Have An Account? LogIn",
                              style: SemiboldTextFieldStyle(),
                            ),
                          ),
                        ),
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
          Image.asset("assets/images/logo.png", width: logoW),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text("Sign Up", style: SemiboldTextFieldStyle()),
          ),
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

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.formKey,
    required this.nameCtl,
    required this.emailCtl,
    required this.passCtl,
    required this.repassCtl,
    required this.keyIcon,
    required this.state,
    required this.actions,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtl;
  final TextEditingController emailCtl;
  final TextEditingController passCtl;
  final TextEditingController repassCtl;
  final Icon keyIcon;
  final dynamic state;
  final dynamic actions;

  InputDecoration _decoration(String hint, Widget prefixIcon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: SemiboldTextFieldStyle(),
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtl,
                onChanged: actions.setName,
                validator: (v) =>
                    v == null || v.isEmpty ? "Please enter your name" : null,
                decoration: _decoration('Name', const Icon(Icons.person)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: emailCtl,
                onChanged: actions.setEmail,
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter a valid email" : null,
                decoration:
                    _decoration('Email', const Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passCtl,
                onChanged: actions.setPassword,
                obscureText: state.obscureText,
                validator: (v) => v == null || v.length < 6
                    ? "Enter a strong password"
                    : null,
                decoration: _decoration(
                  'Password',
                  GestureDetector(
                    onTap: actions.togglePasswordVisibility,
                    child: keyIcon,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: repassCtl,
                onChanged: actions.setRePassword,
                obscureText: state.obscureText,
                validator: (v) =>
                    v != passCtl.text ? "Passwords do not match" : null,
                decoration: _decoration(
                  'Re-enter Password',
                  GestureDetector(
                    onTap: actions.togglePasswordVisibility,
                    child: keyIcon,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffff5722),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await actions.registerUser(context);
                  }
                },
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
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
  }
}
