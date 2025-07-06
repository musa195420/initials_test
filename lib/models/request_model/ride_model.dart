import 'package:latlong2/latlong.dart';

/// A single ride request / trip.
class RideModel {
  /// Table primary‑key (may come back nullable on insert).
  final int? id;

  final String? passengerId;
  final String? driverId;

  final String pickupText;
  final String dropText;

  /// Geographic points (lat, lng order ⬅️ same as LatLng)
  final LatLng pickupPoint;
  final LatLng dropPoint;

  final String rideType; // e.g. "economy", "bike", "premium"
  final String status; // e.g. "requested", "accepted", "completed"
  final double? fareEstimate;

  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  const RideModel({
    this.id,
    required this.passengerId,
    required this.driverId,
    required this.pickupText,
    required this.dropText,
    required this.pickupPoint,
    required this.dropPoint,
    required this.rideType,
    required this.status,
    this.fareEstimate,
    required this.requestedAt,
    this.acceptedAt,
    this.completedAt,
  });

  /* ------------------------------------------------------------------ */
  /*                         JSON ↔︎ Model helpers                      */
  /* ------------------------------------------------------------------ */

  /// GeoJSON ‑> LatLng helper
  static LatLng _pointFromGeoJson(Map<String, dynamic> geo) {
    final coords = geo['coordinates'] as List;

    return LatLng(
      (coords[1] as num).toDouble(),
      (coords[0] as num).toDouble(),
    );
  }

  /// LatLng ‑> WKT (for GEOGRAPHY(Point,4326))
  static String _toWkt(LatLng p) =>
      'SRID=4326;POINT(${p.longitude} ${p.latitude})';

  /* ----------------------------- fromJson --------------------------- */
  /// Factory for rows returned by Supabase / PostgREST
  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        id: json['id'] as int?,
        passengerId: json['passenger_id'] as String?,
        driverId: json['driver_id'] as String?,
        pickupText: json['pickup_text'] as String,
        dropText: json['drop_text'] as String,
        pickupPoint: _pointFromGeoJson(json['pickup_point']),
        dropPoint: _pointFromGeoJson(json['drop_point']),
        rideType: json['ride_type'] as String,
        status: json['status'] as String,
        fareEstimate: (json['fare_estimate'] as num?)?.toDouble(),
        requestedAt: DateTime.parse(json['requested_at'] as String),
        acceptedAt: json['accepted_at'] == null
            ? null
            : DateTime.parse(json['accepted_at']),
        completedAt: json['completed_at'] == null
            ? null
            : DateTime.parse(json['completed_at']),
      );

  /* ------------------------------ toJson ---------------------------- */
  /// Map ready for `.insert()` / `.update()` into Supabase
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'passenger_id': passengerId,
        'driver_id': driverId,
        'pickup_text': pickupText,
        'drop_text': dropText,
        // Send as WKT so PostGIS parses it into GEOGRAPHY
        'pickup_point': _toWkt(pickupPoint),
        'drop_point': _toWkt(dropPoint),
        'ride_type': rideType,
        'status': status,
        'fare_estimate': fareEstimate,
        'requested_at': requestedAt.toIso8601String(),
        'accepted_at': acceptedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };
}
