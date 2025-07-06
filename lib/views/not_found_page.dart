// lib/screens/logout_screen.dart
import 'dart:ui'; // ← for BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/no_provider.dart';

class NotFoundPage extends ConsumerWidget {
  const NotFoundPage({super.key});

  static const _orange = Color(0xFFFF6F3C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);
    final logoutNotifier = ref.read(logoutProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          /* ---- blurred gradient background ---- */
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_orange, Color(0xFF181818)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          /* ---- subtle white overlay for glass feel ---- */
          Align(
            alignment: Alignment.center,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: logoutState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /* ---- logo ---- */
                          Image.asset('assets/images/logo.png', width: 100),
                          const SizedBox(height: 30),
                          /* ---- buttons ---- */
                          _GlassButton(
                            icon: Icons.logout,
                            label: 'Logout',
                            onTap: logoutNotifier.logout,
                          ),
                          const SizedBox(height: 20),
                          _GlassButton(
                            icon: Icons.car_crash,
                            label: 'Go to Pickup Ride',
                            onTap: logoutNotifier.gotoHome,
                          ),
                          const SizedBox(height: 20),
                          _GlassButton(
                            icon: Icons.history,
                            label: 'Your Rides',
                            onTap: logoutNotifier.gotoRide,
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

/* -------------------------------------------------------------------------- */
/*                               helper widget                                */
/* -------------------------------------------------------------------------- */

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _orange = Color(0xFFFF6F3C);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins1',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.black45,
        backgroundColor: _orange.withOpacity(0.85),
        foregroundColor: Colors.white,
        elevation: 6,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onTap,
    );
  }
}
