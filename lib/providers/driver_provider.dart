// lib/providers/driver_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/request_model/driver_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/states/driver_state.dart';

final driverProvider = StateNotifierProvider<DriverNotifier, DriverState>(
  (ref) => DriverNotifier(),
);

class DriverNotifier extends StateNotifier<DriverState> {
  DriverNotifier() : super(const DriverState());

  final _nav = locator<NavigationService>();
  final _api = locator<IApiService>();
  final _dialog = locator<IDialogService>();
  final _glob = locator<GlobalService>();

  Future<void> uploadCnicImage(String filePath, String userId) async {
    state = state.copyWith(isLoading: true);
    final res = await _api.uploadCnicImage(filePath, userId);
    if (res.errorCode == 'CNIC0000') {
      state = state.copyWith(cnicUrl: res.data['url']);
    } else {}
    state = state.copyWith(isLoading: false);
  }

  Future<void> uploadLicenseImage(String filePath, String userId) async {
    state = state.copyWith(isLoading: true);
    final res = await _api.uploadLicenceImage(filePath, userId);
    if (res.errorCode == 'LIC0000') {
      state = state.copyWith(licenseUrl: res.data['url']);
    } else {}
    state = state.copyWith(isLoading: false);
  }

  void gotoVehcile() {
    _nav.goTo(Routes.vehicle);
  }

  Future<void> addDriver(String userId) async {
    try {
      state = state.copyWith(isLoading: true);

      final model = DriverModel(
        driverId: userId,
        cnicFrontUrl: state.cnicUrl,
        drivingLicenseUrl: state.licenseUrl,
        isApproved: false,
        availabilityStatus: false,
        createdAt: DateTime.now(),
      );

      final res = await _api.addDriver(model);

      if (res.errorCode == 'DRIVER0000') {
        _dialog.showSuccess(text: "Driver Added Successfully");
      } else {
        _dialog.showApiError(res.data);
      }

      state = state.copyWith(isLoading: false);
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      _nav.goTo(Routes.vehicle);
    }
  }

  String tag = "driver_provide.dart";
}
