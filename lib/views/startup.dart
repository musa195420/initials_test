// lib/ui/startup_page.dart
import 'dart:ui'; // ← for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/startup_provider.dart';

/// Glassy orange start‑up screen.
class StartupPage extends ConsumerWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(isSignedInProvider);

    return Scaffold(
      body: authAsync.when(
        loading: () => const _GlassyStartup(showLoader: true),
        error: (err, _) =>
            _GlassyStartup(message: 'Error: $err'), // quick inline error
        data: (_) => const _GlassyStartup(), // nav happens elsewhere
      ),
    );
  }
}

/// Reusable glassmorphism layout.
class _GlassyStartup extends StatelessWidget {
  const _GlassyStartup({this.showLoader = false, this.message, Key? key})
      : super(key: key);

  /// Whether to show a CircularProgressIndicator.
  final bool showLoader;

  /// Optional status / error string.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ① Background: orange‑to‑white radial gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.6,
              colors: [
                Color.fromARGB(255, 228, 173, 125), // vivid orange
                Color.fromARGB(255, 229, 100, 2),
              ],
            ),
          ),
        ),

        // ② Glass panel with blurred backdrop and logo
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 1.8,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // ③ Optional loader at the bottom
        if (showLoader)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),

        // ④ Optional status or error text
        if (message != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
