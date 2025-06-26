import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/providers/auth_provider.dart';
import 'package:initial_test/services/navigation_service.dart';

class StartupPage extends ConsumerStatefulWidget {
  const StartupPage({super.key});

  @override
  ConsumerState<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupPage> {
  late final NavigationService _nav;

  @override
  void initState() {
    super.initState();
    _nav = locator<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authStateChangesProvider, (prev, next) {
      next.when(
        data: (user) {
          // Navigate **after** the current frame so it won’t clash with build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (user != null) {
              _nav.goTo(Routes.notfound);
            } else {
              _nav.goTo(Routes.login);
            }
          });
        },
        loading: () {
          return CircularProgressIndicator();
        }, // show splash, do nothing
        error: (err, st) {
          return Column(
            children: [
              Text("Error ${err.toString()}, Stack ${st.toString()}"),
            ],
          );
        },
      );
    });

    return const Scaffold(
      body: Center(child: Text('Project is starting, please wait…')),
    );
  }
}
