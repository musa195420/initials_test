import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/login_controller.dart';
import 'package:initial_test/widget_support/text_styles.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  final LoginController controller = Get.find<LoginController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double maxW = Get.width;
    final double maxH = Get.height;

    final double headerH = min(maxH * .35, 280);
    final double logoW = min(maxW * .45, 160);
    final double hPad = maxW < 500
        ? 16
        : maxW < 800
            ? 32
            : 64;

    return Scaffold(
      body: Stack(
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
                    _FormCard(formKey: _formKey, controller: controller),
                    const SizedBox(height: 28),
                    _SignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
    required GlobalKey<FormState> formKey,
    required this.controller,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
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
                onChanged: controller.setEmail,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter your e-mail' : null,
                decoration: _inputDecoration(
                  'Email',
                  const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 18),
              // Password
              Obx(() => TextFormField(
                    onChanged: controller.setPassword,
                    obscureText: controller.obscureText.value,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter your password' : null,
                    decoration: _inputDecoration(
                      'Password',
                      GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: controller.obscureText.value
                            ? const Icon(Icons.key)
                            : const Icon(Icons.key_off_outlined),
                      ),
                    ),
                  )),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.userLogin();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins1',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
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
}

class _SignUpLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Get.toNamed(Routes.signup),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Don\'t Have An Account? Sign Up',
            style: SemiboldTextFieldStyle(),
          ),
        ),
      );
}
