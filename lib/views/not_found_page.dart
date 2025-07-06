// lib/screens/logout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/no_provider.dart';

class NotFoundPage extends ConsumerWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);
    final logoutNotifier = ref.read(logoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: logoutState.isLoading
            ? const CircularProgressIndicator()
            : Column(
                spacing: 40,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: () {
                      logoutNotifier.logout();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.car_crash),
                    label: const Text('Goto Pickup Ride'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: () {
                      logoutNotifier.gotoHome();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.history),
                    label: const Text('Your Rides'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: () {
                      logoutNotifier.gotoRide();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
