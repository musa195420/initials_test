import 'package:flutter/material.dart';
import 'package:initial_test/helper/stateful_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:initial_test/view_models/authentication_view_model.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel viewModel =
        context.watch<AuthenticationViewModel>();

    return StatefulWrapper(
      onInit: () {
        viewModel.checkLogin();
      },
      onDispose: () {},
      child: const Scaffold(
        body: Center(child: Text('Project is starting, please wait…')),
      ),
    );
  }
}
