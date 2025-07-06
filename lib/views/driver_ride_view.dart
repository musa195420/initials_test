import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/app_constant.dart';

import '../providers/driver_ride_provider.dart';
import '../states/driver_ride_state.dart';
import '../models/request_model/ride_model.dart';

class DriverRideView extends ConsumerStatefulWidget {
  const DriverRideView({super.key});

  @override
  ConsumerState<DriverRideView> createState() => _DriverRideViewState();
}

class _DriverRideViewState extends ConsumerState<DriverRideView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(driverRideProvider.notifier).getDriverRides());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverRideProvider);
    final notifier = ref.read(driverRideProvider.notifier);

    final shown = state.rides
        .where((r) => r.status == state.selectedStatus.label)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Rides"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: RideStatus.values.map((st) {
                final sel = st == state.selectedStatus;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(st.pretty),
                    selected: sel,
                    selectedColor: Colors.orange,
                    onSelected: (_) => notifier.setFilter(st),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : shown.isEmpty
                    ? const Center(child: Text("No rides"))
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: shown.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final r = shown[i];

                          return ListTile(
                            tileColor: Colors.white,
                            title: Text("${r.pickupText} → ${r.dropText}"),
                            subtitle: Text(
                                "Fare: ${r.fareEstimate?.toStringAsFixed(0) ?? '--'}"),
                            trailing: Text(r.status),
                            onTap: () async {
                              if (r.status == RideStatus.requested.label) {
                                await notifier.acceptRide(r);
                              } else if (r.status ==
                                  RideStatus.accepted.label) {
                                await notifier.startRide(r);
                              } else if (r.status ==
                                  RideStatus.inProgress.label) {
                                await notifier.completeRide(r);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.getDriverRides,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
