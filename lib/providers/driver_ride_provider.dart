import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/app_constant.dart';
import 'package:initial_test/helper/routes.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/request_model/ride_model.dart';
import 'package:initial_test/services/hive_service.dart';
import 'package:initial_test/services/navigation_service.dart';
import 'package:initial_test/services/pref_service.dart';

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

  final _nav = locator<NavigationService>();
  final _prefs = locator<PrefService>();
  final _hive = locator<IHiveService<UserProfile>>();
  /*────────────────────────── fetching ──────────────────────────*/

  Future<void> _getRequestedRides() async {
    state = state.copyWith(loading: true);
    try {
      final res = await _api.getrides(); // all "requested"
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

  Future<void> _getMyRides() async {
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

  void logout() async {
    await _prefs.setString(PrefKey.token, '');
    await _prefs.setString(PrefKey.refreshToken, '');

    // fetch user profile

    await _hive.deleteAll();

    _nav.goTo(Routes.login);
  }

  /// called from UI (tab switch / pull‑to‑refresh)
  Future<void> refreshCurrent() async {
    switch (state.selectedStatus) {
      case RideStatus.requested:
        await _getRequestedRides();
        break;
      default:
        await _getMyRides();
    }
  }

  Future<void> setFilter(RideStatus s) async {
    state = state.copyWith(selectedStatus: s);
    await refreshCurrent();
  }

  /*─────────────────────── ride mutations ───────────────────────*/

  Future<void> acceptRide(RideModel ride) async {
    final user = _glob.getuser();
    if (user == null) return;

    final updated = ride.copyWith(
      status: RideStatus.accepted.label,
      driverId: user.userId,
    );
    await _updateRide(updated);
  }

  Future<void> completeRide(RideModel ride) async =>
      _updateRide(ride.copyWith(status: RideStatus.completed.label));

  Future<void> cancelRide(RideModel ride) async =>
      _updateRide(ride.copyWith(status: RideStatus.cancelled.label));

  Future<void> _updateRide(RideModel ride) async {
    state = state.copyWith(loading: true);
    try {
      final res = await _api.updateride(ride);
      if (res.errorCode == 'PA0004') {
        _dlg.showSuccess(text: 'Ride updated successfully');
        await refreshCurrent(); // reload list after server change
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
