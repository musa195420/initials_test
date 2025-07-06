// lib/models/request_model/ride_model.dart
import 'dart:convert'; // ← for jsonDecode (GeoJSON string case)
import 'dart:typed_data'; // ← for ByteData / Uint8List
import 'package:latlong2/latlong.dart';

/// A single ride request / trip.
class RideModel {
  /* ─────────────────────────── fields ──────────────────────────── */
  final int? id;
  final String? passengerId;
  final String? driverId;

  final String pickupText;
  final String dropText;

  final LatLng pickupPoint;
  final LatLng dropPoint;

  final String rideType; // "bike", "car", …
  final String status; // "requested", "accepted", …
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

  /* ───────────────────────── helpers ──────────────────────────── */

  /// 1️⃣ GeoJSON map → LatLng
  static LatLng _pointFromGeoJson(Map<String, dynamic> geo) {
    final coords = geo['coordinates'] as List;
    return LatLng(
      (coords[1] as num).toDouble(), // lat
      (coords[0] as num).toDouble(), // lng
    );
  }

  /// 2️⃣ EWKB hex → LatLng
  static LatLng _pointFromEwkb(String hex) {
    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      bytes[i >> 1] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    final data = ByteData.sublistView(bytes);

    final endian = bytes[0] == 0 ? Endian.big : Endian.little;
    var offset = 1 + 4; // byteOrder + geomType/flags

    const sridFlag = 0x20000000;
    final typeAndFlags = data.getUint32(1, endian);
    if ((typeAndFlags & sridFlag) != 0) offset += 4; // skip SRID if present

    final x = data.getFloat64(offset, endian); // longitude
    final y = data.getFloat64(offset + 8, endian); // latitude
    return LatLng(y, x);
  }

  /// Accept **GeoJSON map**, **GeoJSON string**, **EWKB string**
  static LatLng _latLngFromPg(dynamic value) {
    if (value is Map<String, dynamic>) {
      return _pointFromGeoJson(value);
    }
    if (value is String) {
      final trimmed = value.trimLeft();
      if (trimmed.startsWith('{')) {
        return _pointFromGeoJson(jsonDecode(trimmed));
      }
      return _pointFromEwkb(trimmed);
    }
    throw ArgumentError('Unsupported geography format: $value');
  }

  /// LatLng → WKT (for inserts/updates)
  static String _toWkt(LatLng p) =>
      'SRID=4326;POINT(${p.longitude} ${p.latitude})';

  /* ───────────────────────── fromJson ──────────────────────────── */
  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        id: json['id'] as int?,
        passengerId: json['passenger_id'] as String?,
        driverId: json['driver_id'] as String?,
        pickupText: json['pickup_text'] as String,
        dropText: json['drop_text'] as String,

        // 👉 fixed: use _latLngFromPg so Strings work
        pickupPoint: _latLngFromPg(json['pickup_point']),
        dropPoint: _latLngFromPg(json['drop_point']),

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

  /* ────────────────────────── toJson ───────────────────────────── */
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'passenger_id': passengerId,
        'driver_id': driverId,
        'pickup_text': pickupText,
        'drop_text': dropText,
        'pickup_point': _toWkt(pickupPoint),
        'drop_point': _toWkt(dropPoint),
        'ride_type': rideType,
        'status': status,
        'fare_estimate': fareEstimate,
        'requested_at': requestedAt.toIso8601String(),
        'accepted_at': acceptedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  /* ────────────────────────── copyWith ─────────────────────────── */
  /// Returns a **new** `RideModel` with the provided fields replaced.
  RideModel copyWith({
    int? id,
    String? passengerId,
    String? driverId,
    String? pickupText,
    String? dropText,
    LatLng? pickupPoint,
    LatLng? dropPoint,
    String? rideType,
    String? status,
    double? fareEstimate,
    DateTime? requestedAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return RideModel(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      pickupText: pickupText ?? this.pickupText,
      dropText: dropText ?? this.dropText,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      dropPoint: dropPoint ?? this.dropPoint,
      rideType: rideType ?? this.rideType,
      status: status ?? this.status,
      fareEstimate: fareEstimate ?? this.fareEstimate,
      requestedAt: requestedAt ?? this.requestedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
