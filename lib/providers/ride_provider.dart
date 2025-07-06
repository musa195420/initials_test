import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/request_model/ride_model.dart';

import '../states/ride_state.dart';
import '../helper/locator.dart';
import '../services/api_service.dart';
import '../services/dialog_service.dart';
import '../services/global_service.dart';

final rideProvider =
    StateNotifierProvider<RideNotifier, RideState>((ref) => RideNotifier());

class RideNotifier extends StateNotifier<RideState> {
  RideNotifier() : super(const RideState());

  // ─── dependencies ───
  final _api = locator<IApiService>();
  final _dlg = locator<IDialogService>();
  final _glob = locator<GlobalService>();

  /* ───────── public API ───────── */

  /// Fetch all rides for current user
  Future<void> getRides() async {
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

  /// Change the status filter
  void setFilter(RideStatus s) => state = state.copyWith(selectedStatus: s);

  /* ───────── cancel & update helpers ───────── */

  /// Convenience: cancel a *requested* ride
  Future<void> cancelRide(RideModel ride) async {
    // create a copy with status changed to cancelled
    final updated = ride.copyWith(status: RideStatus.cancelled.label);
    await _updateride(updated);

    // update local list so UI refreshes instantly
    final idx = state.rides.indexWhere((e) => e.id == ride.id);
    if (idx != -1) {
      final newRides = [...state.rides]..[idx] = updated;
      state = state.copyWith(rides: newRides);
    }
  }

  /// Backend call to update a ride (status / fare etc.)
  Future<void> _updateride(RideModel ride) async {
    state = state.copyWith(loading: true);
    try {
      final res = await _api.updateride(ride);
      if (res.errorCode == 'PA0004') {
        _dlg.showSuccess(text: "Ride updated successfully");
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
