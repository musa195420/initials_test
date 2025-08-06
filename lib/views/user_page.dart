import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/providers/user_controller.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        controller.selectUser(user);
                      },
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              final user = controller.selectedUser.value;
              if (user == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.grey[100],
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Selected User Details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Name: ${user.name}"),
                        Text("Email: ${user.email}"),
                        Text("ID: ${user.id}"),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
