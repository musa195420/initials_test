import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/app_constant.dart';
import 'package:initial_test/models/request_model/ride_model.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';

import '../states/driver_ride_state.dart';
import '../helper/locator.dart';
import '../services/api_service.dart';
import '../services/dialog_service.dart';
import '../services/global_service.dart';

final driverRideProvider =
    StateNotifierProvider<DriverRideNotifier, DriverRideState>(
        (ref) => DriverRideNotifier());

class DriverRideNotifier extends StateNotifier<DriverRideState> {
  DriverRideNotifier() : super(const DriverRideState());

  final _api = locator<IApiService>();
  final _dlg = locator<IDialogService>();
  final _glob = locator<GlobalService>();

  Future<void> getRides() async {
    state = state.copyWith(loading: true);
    try {
      final res = await _api.getrides(); // get all requested rides
      if (res.errorCode == 'PA0004') {
        final rides = (res.data as List)
            .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
            .toList(growable: false);
        state = state.copyWith(rides: rides);
      } else {
        _dlg.showApiError(res.data);
      }
    } catch (e) {
      _dlg.showApiError('Unexpected error: $e');
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> getDriverRides() async {
    state = state.copyWith(loading: true);
    try {
      final user = _glob.getuser();
      if (user != null) {
        final res = await _api.getRidesUserId(UserProfile(userId: user.userId));
        if (res.errorCode == 'PA0004') {
          final rides = (res.data as List)
              .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
              .toList(growable: false);
          state = state.copyWith(rides: rides);
        } else {
          _dlg.showApiError(res.data);
        }
      }
    } catch (e) {
      _dlg.showApiError('Unexpected error: $e');
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  void setFilter(RideStatus s) => state = state.copyWith(selectedStatus: s);

  Future<void> acceptRide(RideModel ride) async {
    final user = _glob.getuser();
    if (user == null) return;

    final updated = ride.copyWith(
      status: RideStatus.accepted.label,
      driverId: user.userId,
    );

    await _updateRide(updated);
  }

  Future<void> startRide(RideModel ride) async {
    final updated = ride.copyWith(status: RideStatus.inProgress.label);
    await _updateRide(updated);
  }

  Future<void> completeRide(RideModel ride) async {
    final updated = ride.copyWith(status: RideStatus.completed.label);
    await _updateRide(updated);
  }

  Future<void> cancelRide(RideModel ride) async {
    final updated = ride.copyWith(status: RideStatus.cancelled.label);
    await _updateRide(updated);
  }

  Future<void> _updateRide(RideModel ride) async {
    state = state.copyWith(loading: true);
    try {
      final res = await _api.updateride(ride);
      if (res.errorCode == 'PA0004') {
        _dlg.showSuccess(text: "Ride updated successfully");

        // refresh local
        final idx = state.rides.indexWhere((e) => e.id == ride.id);
        if (idx != -1) {
          final newRides = [...state.rides]..[idx] = ride;
          state = state.copyWith(rides: newRides);
        }
      } else {
        _dlg.showApiError(res.data);
      }
    } catch (e) {
      _dlg.showApiError('Unexpected error: $e');
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
