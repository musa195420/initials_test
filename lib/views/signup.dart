// Refactored SignUp page to use Riverpod for registration state management

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/signup_provider.dart';
import 'package:initial_test/views/not_found_page.dart';

import '../widget_support/text_styles.dart';

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final signupNotifier = ref.read(signupProvider.notifier);
    final state = ref.watch(signupProvider);
    final nameController = TextEditingController(text: state.name);
    final emailController = TextEditingController(text: state.email);
    final repasswordController = TextEditingController(text: state.repassword);
    final passwordController = TextEditingController(text: state.password);

    final keyIcon = state.obscureText
        ? const Icon(Icons.key)
        : const Icon(Icons.key_off_outlined);

    if (state.isLoggedIn) {
      return const NotFoundPage();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFff5c30), Color(0xFFe74b1a)])),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.75),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: const Text(""),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60.0),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "images/logo.png",
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Text("Sign Up", style: SemiboldTextFieldStyle()),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: const Color(0xFFF14921), width: 0.9),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: nameController,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter your name"
                                            : null,
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      hintStyle: SemiboldTextFieldStyle(),
                                      prefixIcon:
                                          const Icon(Icons.person_2_outlined),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter a valid email"
                                            : null,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: SemiboldTextFieldStyle(),
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: state.obscureText,
                                    validator: (value) =>
                                        value == null || value.length < 6
                                            ? "Enter a stronger password"
                                            : null,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: SemiboldTextFieldStyle(),
                                      prefixIcon: GestureDetector(
                                        onTap: () => signupNotifier
                                            .togglePasswordVisibility(),
                                        child: keyIcon,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: repasswordController,
                                    obscureText: state.obscureText,
                                    validator: (value) =>
                                        value != passwordController.text
                                            ? "Passwords do not match"
                                            : null,
                                    decoration: InputDecoration(
                                      hintText: 'Re-Enter Password',
                                      hintStyle: SemiboldTextFieldStyle(),
                                      prefixIcon: GestureDetector(
                                        onTap: () => signupNotifier
                                            .togglePasswordVisibility(),
                                        child: keyIcon,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      if (formKey.currentState!.validate()) {
                                        await signupNotifier
                                            .registerUser(context);
                                      }
                                    },
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffff5722),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "SIGN UP",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontFamily: 'Poppins1',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const LogIn()),
                          // );
                        },
                        child: Text(
                          "Already Have An Account? LogIn",
                          style: SemiboldTextFieldStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
