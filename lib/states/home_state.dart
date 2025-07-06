import 'package:initial_test/views/home.dart';
import 'package:latlong2/latlong.dart'; // ← for the enum

/// Immutable UI‑state for the Home page.
class HomeState {
  final LatLng? currentPos; // live GPS
  final RideType selectedType; // bike / car / rickshaw
  final LatLng? pickup; // chosen pickup
  final LatLng? drop; // chosen drop‑off
  final double? fare; // PKR
  final bool requesting; // API call in progress

  const HomeState({
    this.currentPos,
    this.selectedType = RideType.bike,
    this.pickup,
    this.drop,
    this.fare,
    this.requesting = false,
  });

  HomeState copyWith({
    LatLng? currentPos,
    RideType? selectedType,
    LatLng? pickup,
    LatLng? drop,
    double? fare,
    bool? requesting,
  }) =>
      HomeState(
        currentPos: currentPos ?? this.currentPos,
        selectedType: selectedType ?? this.selectedType,
        pickup: pickup ?? this.pickup,
        drop: drop ?? this.drop,
        fare: fare ?? this.fare,
        requesting: requesting ?? this.requesting,
      );
}
