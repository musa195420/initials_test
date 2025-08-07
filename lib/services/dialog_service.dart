import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/models/helper_models/error_response.dart';
import 'package:initial_test/models/helper_models/message_model.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DialogService implements IDialogService {
  NavigationService get _navigationService => locator<NavigationService>();
  @override
  Future<void> showSuccess({String text = 'Operation Successful'}) async {
    showDialog(
      context: _navigationService.navigatorKey.currentContext!,
      barrierDismissible: false, // Prevent manual close
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          backgroundColor: const Color(0xFF1C1C1E), // Dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E), // Dark gray
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 70,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> showError({String text = 'Operation Not Successful'}) async {
    showDialog(
      context: _navigationService.navigatorKey.currentContext!,
      barrierDismissible: false, // Prevent manual close
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          backgroundColor: const Color(0xFF1C1C1E), // Dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Future<bool> showApiError(dynamic dynamicRes) async {
    String code = "404";
    String error = "An Error Occurred";
    String message = "Please contact the administrator. Or try again later!";
    ErrorResponse? errorResponse;

    try {
      errorResponse = dynamicRes as ErrorResponse;
    } catch (e) {
      errorResponse = ErrorResponse(
        error: "Server Not Reachable",
        errorCode: "500",
        message: "Please contact the administrator. Or try again later!",
      );
    }

    error = errorResponse.error ?? "An Unexpected Error Occurred";
    code = errorResponse.errorCode ?? "404";
    message = errorResponse.message ??
        "Please contact the administrator. Or try again later!";

    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }

    var res = await showDialog<bool>(
          context: _navigationService.navigatorKey.currentContext!,
          barrierDismissible: true,
          builder: (_) => PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFF1C1C1E), // Dark background
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(
                              _navigationService.navigatorKey.currentContext!)
                          .size
                          .height *
                      0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Oops! Something went wrong",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF2C2C2E), // Slightly lighter dark
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.orangeAccent.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Code: $code",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Error: $error",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Message: $message",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              _navigationService.goBack();
                            },
                            child: const Text(
                              "Got It",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;

    if (EasyLoading.isShow) {
      await EasyLoading.show(status: 'Loading...');
    }

    return res;
  }

  /// Retur
  ///
  /// @override
  Future<int> showSelect(Message message) async {
    var isLoader = EasyLoading.isShow ? true : false;
    if (isLoader) {
      await EasyLoading.dismiss();
    }

    var res = await showBarModalBottomSheet<int>(
          context: _navigationService.navigatorKey.currentContext!,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                // Prevent overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap:
                          true, // Ensures ListView takes only required space
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevent ListView scrolling inside SingleChildScrollView
                      itemCount: message.items!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(message.items![index]!),
                          onTap: () {
                            Navigator.of(context).pop(index);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) ??
        -1;

    if (isLoader) {
      await EasyLoading.show(status: 'Loading...');
    }

    return res;
  }
}

abstract class IDialogService {
  Future<void> showSuccess({String text = 'Operation Successful'});
  Future<void> showError({String text = 'Operation Not  Successful'});
  Future<bool> showApiError(dynamic error);
  Future<int> showSelect(Message message);
}
