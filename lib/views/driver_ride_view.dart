import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/helper/app_constant.dart';

import '../../providers/driver_ride_provider.dart';
import '../../states/driver_ride_state.dart';
import '../../models/request_model/ride_model.dart';

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
        () => ref.read(driverRideProvider.notifier).refreshCurrent());
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
        title: Row(
          children: [
            const Text('Driver Rides'),
            Spacer(),
            InkWell(
                onTap: () {
                  notifier.logout();
                },
                child: Icon(Icons.logout_outlined))
          ],
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _StatusChips(
            current: state.selectedStatus,
            onSelect: (st) => notifier.setFilter(st),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : shown.isEmpty
                    ? const Center(child: Text('No rides'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: shown.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _RideCard(
                          ride: shown[i],
                          onAccept: () async {
                            final ok = await _confirm(
                                context, 'Do you want to accept this ride?');
                            if (ok) await notifier.acceptRide(shown[i]);
                          },
                          onLongActions: () async {
                            final act = await _chooseAction(context);
                            if (act == _Action.complete) {
                              await notifier.completeRide(shown[i]);
                            } else if (act == _Action.cancel) {
                              await notifier.cancelRide(shown[i]);
                            }
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.refreshCurrent,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /*──────────────── dialogs ────────────────*/

  Future<bool> _confirm(BuildContext ctx, String msg) async {
    return (await showDialog<bool>(
          context: ctx,
          builder: (_) => AlertDialog(
            title: const Text('Confirm'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Yes')),
            ],
          ),
        )) ??
        false;
  }

  Future<_Action?> _chooseAction(BuildContext ctx) async {
    return showModalBottomSheet<_Action>(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Complete ride'),
              onTap: () => Navigator.pop(ctx, _Action.complete)),
          ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel ride'),
              onTap: () => Navigator.pop(ctx, _Action.cancel)),
        ]),
      ),
    );
  }
}

/*───────────────────────── helper widgets ─────────────────────────*/

class _StatusChips extends StatelessWidget {
  const _StatusChips({
    required this.current,
    required this.onSelect,
  });
  final RideStatus current;
  final ValueChanged<RideStatus> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: RideStatus.values.map((st) {
          final sel = st == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(st.pretty),
              selected: sel,
              selectedColor: Colors.orange,
              onSelected: (_) => onSelect(st),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.ride,
    required this.onAccept,
    required this.onLongActions,
  });

  final RideModel ride;
  final VoidCallback onAccept;
  final VoidCallback onLongActions;

  @override
  Widget build(BuildContext context) {
    final icon = _vehicleIcon(ride.rideType);
    final color = _statusColor(ride.status);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: ride.status == RideStatus.requested.label ? onAccept : null,
      onLongPress: (ride.status == RideStatus.accepted.label ||
              ride.status == RideStatus.inProgress.label)
          ? onLongActions
          : null,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.black,
              child: Icon(icon, size: 34, color: Colors.orange),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.rideType.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    'Fare • ${ride.fareEstimate?.toStringAsFixed(0) ?? '--'} PKR',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ride.status,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*──────── icon & color helpers ────────*/
  IconData _vehicleIcon(String t) {
    switch (t.toLowerCase()) {
      case 'bike':
      case 'motorbike':
        return Icons.two_wheeler;
      case 'rickshaw':
      case 'tuk tuk':
        return Icons.electric_rickshaw;
      default:
        return Icons.directions_car;
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'requested':
        return Colors.grey;
      case 'accepted':
        return Colors.orange;
      case 'in_progress':
      case 'inprogress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/*──────── internal enum for bottom‑sheet ────────*/
enum _Action { complete, cancel }
