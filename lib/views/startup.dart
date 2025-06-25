import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:initial_test/view_models/authentication_view_model.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
      builder: (context, authVM, _) {
        // Schedule navigation safely AFTER the build/layout phase.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authVM.user != null) {
            authVM.gotoHome(); // ✅ push home
          } else {
            authVM.gotoLogin(); // ✅ push login
          }
        });

        return const Scaffold(
          body: Center(child: Text('Project is starting, please wait…')),
        );
      },
    );
  }
}
