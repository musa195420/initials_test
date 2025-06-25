// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:initial_test/view_models/authentication_view_model.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  final AuthenticationViewModel _viewModel = AuthenticationViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          onPressed: _viewModel.logout, // Call the _handleLogout method
        ),
      ),
    );
  }
}
