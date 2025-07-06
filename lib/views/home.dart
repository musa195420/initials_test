// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../providers/home_provider.dart';
import '../states/home_state.dart';

// ───────── Colour constants ─────────
const orange = Color(0xffff5722);
const dark = Colors.black;
const white = Colors.white;
const grey = Color(0xfff0f0f0);

// ───────── Ride types enum ─────────
enum RideType { bike, car, rickshaw }

extension RideTypeX on RideType {
  String get label => switch (this) {
        RideType.bike => 'bike',
        RideType.car => 'car',
        RideType.rickshaw => 'rickshaw'
      };
  String get asset => 'assets/images/$label.png';
}

// ────────────────────────────────────────────────────────────
/// Main map & booking screen
// ────────────────────────────────────────────────────────────
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final mapCtl = MapController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (!Platform.isWindows) {
      await Geolocator.requestPermission();
      final pos = await Geolocator.getCurrentPosition();
      final here = LatLng(pos.latitude, pos.longitude);

      ref.read(homeProvider.notifier).setCurrentPos(here);
      mapCtl.move(here, 15);
    }
  }

  /* ───────── let user tap on map ───────── */
  Future<LatLng?> _pickPoint({required bool forPickup}) async {
    final c = Completer<LatLng?>();
    StreamSubscription<MapEvent>? sub;

    sub = mapCtl.mapEventStream.listen((evt) {
      if (evt is MapEventTap) {
        c.complete(
            evt.tapPosition); // ✅ use the LatLng that comes with the event
        sub?.cancel();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tap on the map to set ${forPickup ? 'pickup (green)' : 'drop‑off (red)'}',
        ),
        duration: const Duration(seconds: 4),
      ),
    );

    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(homeProvider); // UI‑state
    final hp = ref.read(homeProvider.notifier); // notifier

    final centre = s.currentPos ?? const LatLng(33.6844, 73.0479);

    return Scaffold(
      body: Stack(
        children: [
          /* ───────── Map ───────── */
          FlutterMap(
            mapController: mapCtl,
            options:
                MapOptions(initialCenter: centre, initialZoom: 13, maxZoom: 18),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              if (s.currentPos != null)
                MarkerLayer(markers: [
                  Marker(
                    point: s.currentPos!,
                    child: const Icon(Icons.my_location, color: dark, size: 32),
                  )
                ]),
              if (s.pickup != null)
                MarkerLayer(markers: [
                  Marker(
                    point: s.pickup!,
                    child: const Icon(Icons.location_on,
                        color: Colors.green, size: 32),
                  )
                ]),
              if (s.drop != null)
                MarkerLayer(markers: [
                  Marker(
                    point: s.drop!,
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 32),
                  )
                ]),
            ],
          ),

          /* ───────── Bottom sheet ───────── */
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.85,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -3))
                ],
              ),
              child: Column(
                children: [
                  /* ---- Ride‑type selector ---- */
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: RideType.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final rt = RideType.values[i];
                        final sel = rt == s.selectedType;
                        return GestureDetector(
                          onTap: () => hp.selectRideType(rt),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: sel ? 0.8 : 1,
                            child: Container(
                              width: 110,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: sel ? orange : grey, width: 3),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(rt.asset, fit: BoxFit.contain),
                                  if (sel)
                                    Container(color: orange.withOpacity(0.3)),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(rt.label,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  /* ---- pickup & drop rows ---- */
                  _locRow(
                    'Pickup location',
                    s.pickup == null
                        ? 'choose'
                        : '${s.pickup!.latitude.toStringAsFixed(5)}, ${s.pickup!.longitude.toStringAsFixed(5)}',
                    Icons.location_on,
                    Colors.green,
                    () async {
                      final p = await _pickPoint(forPickup: true);
                      if (p != null) hp.setPickup(p);
                    },
                  ),
                  const SizedBox(height: 6),
                  _locRow(
                    'Drop‑off location',
                    s.drop == null
                        ? 'choose'
                        : '${s.drop!.latitude.toStringAsFixed(5)}, ${s.drop!.longitude.toStringAsFixed(5)}',
                    Icons.location_on,
                    Colors.red,
                    () async {
                      final d = await _pickPoint(forPickup: false);
                      if (d != null) hp.setDrop(d);
                    },
                  ),
                  const Divider(height: 24),

                  /* ---- fare + button ---- */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.fare == null
                            ? 'Fare —'
                            : 'Fare  PKR  ${s.fare!.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: (s.pickup != null &&
                                s.drop != null &&
                                !s.requesting)
                            ? hp.requestRide
                            : null,
                        child: Text(
                          s.requesting ? 'Requesting…' : 'Request a ride',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: white,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locRow(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
              color: grey, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text('$title:  $value',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: dark),
            ],
          ),
        ),
      );
}
