import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/providers/driver_provider.dart';
import 'package:initial_test/services/global_service.dart';

class DriverPage extends ConsumerStatefulWidget {
  const DriverPage({super.key});

  @override
  ConsumerState<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends ConsumerState<DriverPage> {
  final _formKey = GlobalKey<FormState>();
  final _glob = locator<GlobalService>();
  File? cnicFile;
  File? licenseFile;

  Future<void> pickFile(bool isCnic) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => isCnic
          ? cnicFile = File(picked.path)
          : licenseFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverProvider);
    final actions = ref.read(driverProvider.notifier);
    final userId = _glob.getuser()!.userId;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Driver Setup"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader("Upload CNIC"),
              const SizedBox(height: 10),
              _fileTile(
                file: cnicFile,
                label: "CNIC Document",
                onTap: () => pickFile(true),
              ),
              const SizedBox(height: 20),
              sectionHeader("Upload Driving License"),
              const SizedBox(height: 10),
              _fileTile(
                file: licenseFile,
                label: "Driving License",
                onTap: () => pickFile(false),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (cnicFile == null || licenseFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please upload both documents"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    await actions.uploadCnicImage(cnicFile!.path, userId!);
                    await actions.uploadLicenseImage(licenseFile!.path, userId);
                    await actions.addDriver(userId);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Submit Driver Info"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );

  Widget _fileTile({
    required File? file,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.file_present_rounded, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              file?.path.split('/').last ?? "No file selected",
              style: TextStyle(
                fontSize: 14,
                color: file != null ? Colors.black87 : Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: onTap,
            tooltip: "Select file",
          )
        ],
      ),
    );
  }
}
