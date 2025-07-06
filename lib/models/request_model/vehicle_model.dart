/// lib/models/vehicle_model.dart
class VehicleModel {
  /* ─────────────────────────── fields ──────────────────────────── */
  final int? id; // BIGINT  (PostgreSQL “bigint” → Dart int)
  final String? driverId; // UUID
  final String? vehicleType; // Enum/text in DB
  final String? make;
  final String? model;
  final String? variant;
  final String? plateNumber; // UNIQUE text
  final bool? isActive; // Defaults to true in DB
  final DateTime? addedAt; // Timestamp with time zone

  /* ───────────────────────── constructor ───────────────────────── */
  const VehicleModel({
    this.id,
    this.driverId,
    this.vehicleType,
    this.make,
    this.model,
    this.variant,
    this.plateNumber,
    this.isActive,
    this.addedAt,
  });

  /* ────────────────────────── fromJson ─────────────────────────── */
  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'] as int?,
        driverId: json['driver_id'] as String?,
        vehicleType: json['vehicle_type'] as String?,
        make: json['make'] as String?,
        model: json['model'] as String?,
        variant: json['variant'] as String?,
        plateNumber: json['plate_number'] as String?,
        isActive: json['is_active'] as bool?,
        addedAt: json['added_at'] != null
            ? DateTime.parse(json['added_at'] as String)
            : null,
      );

  /* ─────────────────────────── toJson ──────────────────────────── */
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (driverId != null) map['driver_id'] = driverId;
    if (vehicleType != null) map['vehicle_type'] = vehicleType;
    if (make != null) map['make'] = make;
    if (model != null) map['model'] = model;
    if (variant != null) map['variant'] = variant;
    if (plateNumber != null) map['plate_number'] = plateNumber;
    if (isActive != null) map['is_active'] = isActive;
    if (addedAt != null) map['added_at'] = addedAt!.toIso8601String();

    return map;
  }

  /* ────────────────────────── copyWith ─────────────────────────── */
  VehicleModel copyWith({
    int? id,
    String? driverId,
    String? vehicleType,
    String? make,
    String? model,
    String? variant,
    String? plateNumber,
    bool? isActive,
    DateTime? addedAt,
  }) =>
      VehicleModel(
        id: id ?? this.id,
        driverId: driverId ?? this.driverId,
        vehicleType: vehicleType ?? this.vehicleType,
        make: make ?? this.make,
        model: model ?? this.model,
        variant: variant ?? this.variant,
        plateNumber: plateNumber ?? this.plateNumber,
        isActive: isActive ?? this.isActive,
        addedAt: addedAt ?? this.addedAt,
      );
}
