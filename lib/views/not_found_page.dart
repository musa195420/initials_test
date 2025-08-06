// lib/screens/logout_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/providers/logout_controller.dart'; // assuming this sets up GetIt

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  final LogoutController _controller = Get.find<LogoutController>();
  bool isLoading = false;

  void _logout() async {
    await _controller.logout();
  }

  void _getUser() async {
    await _controller.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: _logout,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Get User'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: _getUser,
                  ),
                ],
              ),
      ),
    );
  }
}
