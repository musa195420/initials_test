import 'package:initial_test/models/request_model/ride_model.dart';

/// Ride status options you get back from the API.
enum RideStatus { requested, accepted, inProgress, completed, cancelled }

extension RideStatusX on RideStatus {
  /// Exact strings used by your backend
  String get label => switch (this) {
        RideStatus.requested => 'requested',
        RideStatus.accepted => 'accepted',
        RideStatus.inProgress => 'in_progress',
        RideStatus.completed => 'completed',
        RideStatus.cancelled => 'cancelled',
      };

  /// Prettier label for the UI
  String get pretty =>
      label.replaceAll('_', ' ').replaceFirst(label[0], label[0].toUpperCase());
}

/// Immutable UI‑state for the RideView screen.
class RideState {
  final List<RideModel> rides;
  final RideStatus selectedStatus;
  final bool loading;

  const RideState({
    this.rides = const [],
    this.selectedStatus = RideStatus.requested,
    this.loading = false,
  });

  RideState copyWith({
    List<RideModel>? rides,
    RideStatus? selectedStatus,
    bool? loading,
  }) =>
      RideState(
        rides: rides ?? this.rides,
        selectedStatus: selectedStatus ?? this.selectedStatus,
        loading: loading ?? this.loading,
      );
}
