import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/helper/app_router.dart';
import 'package:initial_test/providers/signup_controller.dart';
import 'package:initial_test/widget_support/text_styles.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final SignUpController controller = Get.find<SignUpController>();
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
                    SizedBox(height: headerH / 3),
                    _FormCard(formKey: _formKey, controller: controller),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
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
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final SignUpController controller;

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
          child: Obx(() => Column(
                children: [
                  TextFormField(
                    onChanged: controller.setName,
                    validator: (v) => v == null || v.isEmpty
                        ? "Please enter your name"
                        : null,
                    decoration: _decoration('Name', const Icon(Icons.person)),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    onChanged: controller.setEmail,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter a valid email" : null,
                    decoration:
                        _decoration('Email', const Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    onChanged: controller.setPassword,
                    obscureText: controller.obscureText.value,
                    validator: (v) => v == null || v.length < 6
                        ? "Enter a strong password"
                        : null,
                    decoration: _decoration(
                      'Password',
                      GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: controller.obscureText.value
                            ? const Icon(Icons.key)
                            : const Icon(Icons.key_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    onChanged: controller.setRePassword,
                    obscureText: controller.obscureText.value,
                    validator: (v) => v != controller.password.value
                        ? "Passwords do not match"
                        : null,
                    decoration: _decoration(
                      'Re-enter Password',
                      GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: controller.obscureText.value
                            ? const Icon(Icons.key)
                            : const Icon(Icons.key_off_outlined),
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.registerUser();
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
              )),
        ),
      ),
    );
  }
}
