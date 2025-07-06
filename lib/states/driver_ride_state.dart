import 'package:initial_test/helper/app_constant.dart';
import 'package:initial_test/models/request_model/ride_model.dart';

/// Immutable UI‑state for the DriverRideView screen.
class DriverRideState {
  final List<RideModel> rides;
  final RideStatus selectedStatus;
  final bool loading;

  const DriverRideState({
    this.rides = const [],
    this.selectedStatus = RideStatus.requested,
    this.loading = false,
  });

  DriverRideState copyWith({
    List<RideModel>? rides,
    RideStatus? selectedStatus,
    bool? loading,
  }) =>
      DriverRideState(
        rides: rides ?? this.rides,
        selectedStatus: selectedStatus ?? this.selectedStatus,
        loading: loading ?? this.loading,
      );
}
