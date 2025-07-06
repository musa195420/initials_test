import 'package:equatable/equatable.dart';
import 'package:initial_test/helper/app_constant.dart';
import 'package:initial_test/models/request_model/ride_model.dart';

class DriverRideState extends Equatable {
  final bool loading;
  final List<RideModel> rides;
  final RideStatus selectedStatus;

  const DriverRideState({
    this.loading = false,
    this.rides = const [],
    this.selectedStatus = RideStatus.requested,
  });

  DriverRideState copyWith({
    bool? loading,
    List<RideModel>? rides,
    RideStatus? selectedStatus,
  }) =>
      DriverRideState(
        loading: loading ?? this.loading,
        rides: rides ?? this.rides,
        selectedStatus: selectedStatus ?? this.selectedStatus,
      );

  @override
  List<Object?> get props => [loading, rides, selectedStatus];
}
