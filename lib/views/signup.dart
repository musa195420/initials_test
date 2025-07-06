// lib/ui/auth/signup.dart
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
  late final TextEditingController _phoneCtl;
  late final TextEditingController _roleIdCtl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(signupProvider);
    _nameCtl = TextEditingController(text: s.name);
    _emailCtl = TextEditingController(text: s.email);
    _passCtl = TextEditingController(text: s.password);
    _repassCtl = TextEditingController(text: s.repassword);
    _phoneCtl = TextEditingController(text: s.phone);
    _roleIdCtl = TextEditingController(text: s.roleId.toString());
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _repassCtl.dispose();
    _phoneCtl.dispose();
    _roleIdCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final actions = ref.read(signupProvider.notifier);
    final keyIcon = state.obscureText
        ? const Icon(Icons.key)
        : const Icon(Icons.key_off_outlined);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          final maxW = c.maxWidth;
          final maxH = c.maxHeight;
          // ↓↓↓ Smaller header: 22% height or max 180px
          final header = min(maxH * .22, 180);
          // ↓↓↓ Smaller logo: 30% width or max 120px
          final logoW = min(maxW * .30, 120);
          final hPad = maxW < 500
              ? 16
              : maxW < 800
                  ? 32
                  : 64;

          return Stack(
            children: [
              _HeaderBackground(
                  height: header.toDouble(), logoW: logoW.toDouble()),
              _WhiteBottomBox(offset: header - 20),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad.toDouble())
                    .add(EdgeInsets.only(top: header - 60)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        SizedBox(height: header / 3),
                        _FormCard(
                          formKey: _formKey,
                          nameCtl: _nameCtl,
                          emailCtl: _emailCtl,
                          passCtl: _passCtl,
                          repassCtl: _repassCtl,
                          roleIdCtl: _roleIdCtl,
                          phoneCtl: _phoneCtl,
                          keyIcon: keyIcon,
                          state: state,
                          actions: actions,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => navigationService.goTo(Routes.login),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Already Have An Account? Log In',
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

/* ───────────────────────────────── header widgets ───────────────────────── */

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.height, required this.logoW});
  final double height, logoW;

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
          Image.asset('assets/images/logo.png', width: logoW),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text('Sign Up', style: SemiboldTextFieldStyle()),
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
  Widget build(BuildContext context) => Positioned.fill(
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

/* ───────────────────────────────── form card ───────────────────────────── */

class _FormCard extends ConsumerWidget {
  const _FormCard({
    required this.formKey,
    required this.nameCtl,
    required this.emailCtl,
    required this.passCtl,
    required this.repassCtl,
    required this.roleIdCtl,
    required this.keyIcon,
    required this.state,
    required this.actions,
    required this.phoneCtl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtl,
      emailCtl,
      passCtl,
      repassCtl,
      roleIdCtl,
      phoneCtl;
  final Icon keyIcon;
  final dynamic state, actions;

  InputDecoration _dec(String hint, Widget prefix) => InputDecoration(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.roles != null) {
      int roleId = state.roleId - 1;
      if (roleId >= 0 && roleId < state.roles.length) {
        roleIdCtl.text = state.roles[roleId].code.toString();
      }
    }

    final rulesOk = ref.watch(signupProvider.select((s) => s.allRulesPassed));

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
                    v == null || v.isEmpty ? 'Please enter your name' : null,
                decoration: _dec('Name', const Icon(Icons.person)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: emailCtl,
                onChanged: actions.setEmail,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a valid email' : null,
                decoration: _dec('Email', const Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                onTap: () {
                  actions.showRoles();
                  roleIdCtl.text = state.roleId.toString();
                },
                readOnly: true,
                controller: roleIdCtl,
                validator: (v) =>
                    v != roleIdCtl.text ? 'Role not Selected' : null,
                decoration: _dec(
                  'Select Role',
                  const Icon(Icons.roller_shades),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                onChanged: actions.setPhone,
                controller: phoneCtl,
                validator: (v) =>
                    v != phoneCtl.text ? 'Phone Number Not Selected' : null,
                decoration: _dec(
                  'Phone Number',
                  const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passCtl,
                onChanged: actions.setPassword,
                obscureText: state.obscureText,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a password' : null,
                decoration: _dec(
                  'Password',
                  GestureDetector(
                    onTap: actions.togglePasswordVisibility,
                    child: keyIcon,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const _PasswordRules(),
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
                onPressed: !rulesOk
                    ? null
                    : () async {
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

/* ───────────────────────── password‑rule widgets ───────────────────────── */

class _PasswordRules extends ConsumerWidget {
  const _PasswordRules({super.key});

  Color _c(BuildContext c, bool ok) =>
      ok ? const Color(0xff4caf50) : Theme.of(c).colorScheme.onSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(signupProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⚈  1 uppercase',
                style: TextStyle(color: _c(context, s.containsUpperCase))),
            Text('⚈  1 lowercase',
                style: TextStyle(color: _c(context, s.containsLowerCase))),
            Text('⚈  1 number',
                style: TextStyle(color: _c(context, s.containsNumber))),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⚈  1 special character',
                style: TextStyle(color: _c(context, s.containsSpecialChar))),
            Text('⚈  8 minimum characters',
                style: TextStyle(color: _c(context, s.contains8Length))),
          ],
        ),
      ],
    );
  }
}
