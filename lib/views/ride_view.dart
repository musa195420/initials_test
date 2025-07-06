// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ride_provider.dart';
import '../states/ride_state.dart';
import '../models/request_model/ride_model.dart';

class RideView extends ConsumerStatefulWidget {
  const RideView({super.key});

  @override
  _RideViewState createState() => _RideViewState();
}

class _RideViewState extends ConsumerState<RideView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(rideProvider.notifier).getRides());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rideProvider);
    final notifier = ref.read(rideProvider.notifier);

    final shown = state.rides
        .where((r) => r.status == state.selectedStatus.label)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Rides'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          /* ───────── FILTER BAR ───────── */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: RideStatus.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final st = RideStatus.values[i];
                  final sel = st == state.selectedStatus;
                  return ChoiceChip(
                    label: Text(
                      st.pretty,
                      style:
                          TextStyle(color: sel ? Colors.white : Colors.black),
                    ),
                    selectedColor: Colors.orange,
                    backgroundColor: Colors.grey[300],
                    selected: sel,
                    onSelected: (_) => notifier.setFilter(st),
                    elevation: 2,
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),

          /* ───────── RIDE LIST ───────── */
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : shown.isEmpty
                    ? Center(
                        child: Text('No ${state.selectedStatus.pretty} rides',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey[700])),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: shown.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final r = shown[i];

                          return Card(
                            elevation: 3,
                            shadowColor: Colors.orange.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              leading: const Icon(Icons.local_taxi,
                                  color: Colors.orange),
                              title: Text('${r.pickupText} → ${r.dropText}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                'Fare: PKR ${r.fareEstimate?.toStringAsFixed(0) ?? '--'}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              trailing: Text(
                                r.status.replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              // ────── NEW: tap to cancel if requested ──────
                              onTap: r.status == RideStatus.requested.label
                                  ? () async {
                                      final ok = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Cancel Ride?'),
                                              content: const Text(
                                                  'Do you really want to cancel this ride?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            ctx, false),
                                                    child: const Text('No')),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.orange),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            ctx, true),
                                                    child: const Text('Yes')),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      if (ok) {
                                        await notifier.cancelRide(r);
                                      }
                                    }
                                  : null,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: notifier.getRides,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
