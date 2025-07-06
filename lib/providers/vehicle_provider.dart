// lib/providers/vehicle_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/states/vehicle_state.dart';

final vehicleProvider =
    StateNotifierProvider<VehicleNotifier, VehicleState>((ref) {
  return VehicleNotifier();
});

class VehicleNotifier extends StateNotifier<VehicleState> {
  VehicleNotifier() : super(const VehicleState());

  final _api = locator<IApiService>();
  final _dialog = locator<IDialogService>();
  final _glob = locator<GlobalService>();

  final _nav = locator<NavigationService>();
  /* ─────── setters ─────── */
  void setVehicleType(String v) => state = state.copyWith(vehicleType: v);
  void setMake(String v) => state = state.copyWith(make: v);
  void setModel(String v) => state = state.copyWith(model: v);
  void setVariant(String v) => state = state.copyWith(variant: v);
  void setPlate(String v) => state = state.copyWith(plateNumber: v);
  void toggleActive(bool v) => state = state.copyWith(isActive: v);

  /* ─────── submit ─────── */
  Future<void> addVehicle(BuildContext ctx) async {
    if (!state.isComplete) return;

    state = state.copyWith(isSubmitting: true);
    final user = _glob.getuser();

    try {
      if (user != null) {
        final driverId = user.userId;
        final res = await _api.addVehicle(state.toModel(driverId ?? ""));

        if (res.errorCode == 'PA0004') {
          _dialog.showSuccess(text: 'Vehicle added!');
          // clear form
          state = const VehicleState();
          _nav.goTo(Routes.driverhome); // or go wherever you like
        } else {
          _dialog.showApiError(res.data);
        }
      }
    } catch (e, s) {
      printError(
          error: e.toString(), stack: s.toString(), tag: 'vehicle_provider');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
