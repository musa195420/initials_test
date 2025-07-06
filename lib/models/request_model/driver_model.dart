// lib/models/driver_model.dart
import 'package:latlong2/latlong.dart';

class DriverModel {
  /* ────────────────────────── fields ─────────────────────────── */
  final String driverId; // UUID (PK)
  final String? cnicFrontUrl;
  final String? drivingLicenseUrl;
  final bool isApproved;
  final bool availabilityStatus;
  final DateTime createdAt;

  // Optional — pulled from driver_locations
  final LatLng? currentPoint;
  final DateTime? locationUpdatedAt;

  /* ───────────────────────── constructors ───────────────────── */
  const DriverModel({
    required this.driverId,
    this.cnicFrontUrl,
    this.drivingLicenseUrl,
    this.isApproved = false,
    this.availabilityStatus = false,
    required this.createdAt,
    this.currentPoint,
    this.locationUpdatedAt,
  });

  /* ───────────────────────── factory ─────────────────────────── */
  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        driverId: json['driver_id'] ?? json['user_id'] as String,
        cnicFrontUrl: json['cnic_front_url'] as String?,
        drivingLicenseUrl: json['driving_license_url'] as String?,
        isApproved: json['is_approved'] as bool? ?? false,
        availabilityStatus: json['availability_status'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
        currentPoint: json['current_point'] != null
            ? _latLngFromGeo(json['current_point'])
            : null,
        locationUpdatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  /* ───────────────────────── serialiser ──────────────────────── */
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'driver_id': driverId,
      'is_approved': isApproved,
      'availability_status': availabilityStatus,
      'created_at': createdAt.toIso8601String(),
      if (currentPoint != null) 'current_point': _geoFromLatLng(currentPoint!),
      if (locationUpdatedAt != null)
        'updated_at': locationUpdatedAt!.toIso8601String(),
      // nullable strings added only when present ↓
      if (cnicFrontUrl != null) 'cnic_front_url': cnicFrontUrl,
      if (drivingLicenseUrl != null) 'driving_license_url': drivingLicenseUrl,
    };

    // In case you want to strip any accidental nulls that slipped through:
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /* ───────────────────────── copyWith ────────────────────────── */
  DriverModel copyWith({
    String? driverId,
    String? cnicFrontUrl,
    String? drivingLicenseUrl,
    bool? isApproved,
    bool? availabilityStatus,
    DateTime? createdAt,
    LatLng? currentPoint,
    DateTime? locationUpdatedAt,
  }) =>
      DriverModel(
        driverId: driverId ?? this.driverId,
        cnicFrontUrl: cnicFrontUrl ?? this.cnicFrontUrl,
        drivingLicenseUrl: drivingLicenseUrl ?? this.drivingLicenseUrl,
        isApproved: isApproved ?? this.isApproved,
        availabilityStatus: availabilityStatus ?? this.availabilityStatus,
        createdAt: createdAt ?? this.createdAt,
        currentPoint: currentPoint ?? this.currentPoint,
        locationUpdatedAt: locationUpdatedAt ?? this.locationUpdatedAt,
      );

  /* ───────────────────── geo helpers (optional) ──────────────── */
  static LatLng _latLngFromGeo(Map<String, dynamic> geo) {
    // GeoJSON Point: { "type": "Point", "coordinates": [lng, lat] }
    final List coords = geo['coordinates'] as List;
    return LatLng(coords[1] as double, coords[0] as double);
  }

  static Map<String, dynamic> _geoFromLatLng(LatLng point) => {
        'type': 'Point',
        'coordinates': [point.longitude, point.latitude],
      };
}
