import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/models/request_model/ride_model.dart';
import 'package:initial_test/views/home.dart';
import 'package:latlong2/latlong.dart';

import '../states/home_state.dart';
import '../helper/locator.dart';
import '../services/api_service.dart';
import '../services/dialog_service.dart';
import '../services/global_service.dart';
import '../services/navigation_service.dart';

final nav = locator<NavigationService>();

final homeProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((_) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  // ─── dependencies
  final _api = locator<IApiService>();
  final _dlg = locator<IDialogService>();
  final _glob = locator<GlobalService>();

  /* ───────── basic setters ───────── */
  void setCurrentPos(LatLng p) => state = state.copyWith(currentPos: p);
  void selectRideType(RideType t) => state = state.copyWith(selectedType: t);

  void setPickup(LatLng p) {
    state = state.copyWith(pickup: p);
    _recalcFare();
  }

  void setDrop(LatLng d) {
    state = state.copyWith(drop: d);
    _recalcFare();
  }

  void _recalcFare() {
    final p = state.pickup, d = state.drop;
    if (p != null && d != null) {
      final km = const Distance().as(LengthUnit.Kilometer, p, d);
      final fare = km * 50; // your simple rate
      state = state.copyWith(fare: fare);
    }
  }

  /* ───────── API call ───────── */
  Future<void> requestRide() async {
    if (state.pickup == null || state.drop == null) {
      _dlg.showError(text: 'Select pickup & drop‑off first');
      return;
    }

    state = state.copyWith(requesting: true);
    try {
      final user = _glob.getuser(); // already in memory
      if (user != null) {
        final ride = RideModel(
          passengerId: user.userId ?? "",
          driverId: null,
          pickupText: '${state.pickup!.latitude},${state.pickup!.longitude}',
          dropText: '${state.drop!.latitude},${state.drop!.longitude}',
          pickupPoint: state.pickup!,
          dropPoint: state.drop!,
          rideType: state.selectedType.label,
          status: 'requested',
          fareEstimate: state.fare,
          requestedAt: DateTime.now(),
        );

        final res = await _api.addride(ride); // <- your existing endpoint
        if (res.errorCode == 'PA0004') {
          _dlg.showSuccess(text: 'Ride requested');
          // e.g. _nav.goTo(Routes.rideWaiting);
        } else {
          _dlg.showApiError(res.data);
        }
      } else {
        _dlg.showError(text: "User Not Found Globally");
      }
    } catch (e) {
      _dlg.showApiError('Unexpected error: $e');
    } finally {
      state = state.copyWith(requesting: false);
    }
  }
}
