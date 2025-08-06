import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_test/services/navigation_service.dart';

class DialogService implements IDialogService {
  NavigationService get _navigationService => Get.find<NavigationService>();

  @override
  Future<void> showSuccess({String text = 'Operation Successful'}) async {
    showDialog(
      context: _navigationService.navigatorKey.currentContext!,
      barrierDismissible: false, // prevent closing manually
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Retur
}

abstract class IDialogService {
  Future<void> showSuccess({String text = 'Operation Successful'});
}
