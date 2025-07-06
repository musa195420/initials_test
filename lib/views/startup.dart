import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/startup_provider.dart';
import 'package:initial_test/services/navigation_service.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = locator<NavigationService>();
    final authAsync = ref.watch(isSignedInProvider);

    return authAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) => Scaffold(
        body: Center(child: Text('Error: $err\n\n$st')),
      ),
      data: (signedIn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nav.goTo(signedIn ? Routes.notfound : Routes.login);
        });
        // Invisible placeholder while nav happens
        return const Scaffold(
          body: Center(child: Text('Project is starting, please wait…')),
        );
      },
    );
  }
}
