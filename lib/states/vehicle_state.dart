// lib/states/vehicle_state.dart
import 'package:initial_test/models/request_model/vehicle_model.dart';

class VehicleState {
  final String vehicleType; // e.g. "bike", "car"
  final String make; // e.g. "Honda"
  final String model;
  final String variant;
  final String plateNumber;
  final bool isActive;
  final bool isSubmitting; // show progress

  const VehicleState({
    this.vehicleType = '',
    this.make = '',
    this.model = '',
    this.variant = '',
    this.plateNumber = '',
    this.isActive = true,
    this.isSubmitting = false,
  });

  bool get isComplete =>
      vehicleType.isNotEmpty &&
      plateNumber.isNotEmpty; // add more rules if you like

  VehicleState copyWith({
    String? vehicleType,
    String? make,
    String? model,
    String? variant,
    String? plateNumber,
    bool? isActive,
    bool? isSubmitting,
  }) =>
      VehicleState(
        vehicleType: vehicleType ?? this.vehicleType,
        make: make ?? this.make,
        model: model ?? this.model,
        variant: variant ?? this.variant,
        plateNumber: plateNumber ?? this.plateNumber,
        isActive: isActive ?? this.isActive,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      );

  /// Convenience transformer → API model
  VehicleModel toModel(String driverId) => VehicleModel(
        driverId: driverId,
        vehicleType: vehicleType,
        make: make,
        model: model,
        variant: variant,
        plateNumber: plateNumber,
        isActive: isActive,
      );
}
