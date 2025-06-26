import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/models/aqi_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/aqi_notifier.dart';

class AqiScreen extends ConsumerWidget {
  const AqiScreen({super.key});

  static Color getAqiColor(int aqi) {
    if (aqi <= 50) return const Color.fromARGB(255, 6, 255, 14);
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return const Color.fromARGB(255, 241, 20, 4);
    return Colors.purple;
  }

  static String getPollutionStatus(int value, double max) {
    final percent = (value / max).clamp(0.0, 1.0);
    if (percent <= 0.2) return "Excellent";
    if (percent <= 0.4) return "Good";
    if (percent <= 0.6) return "Moderate";
    if (percent <= 0.8) return "Unhealthy";
    return "Hazardous";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiState = ref.watch(aqiProvider);
    final notifier = ref.read(aqiProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final selectedCity = notifier.selectedCity ?? "Select City";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 119, 230),
      body: SafeArea(
        child: Stack(
          children: [
            /// ⬆️ Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Icon aligned to the left
                      const Positioned(
                        left: 0,
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),

                      // Centered City + Status Text
                      aqiState.maybeWhen(
                        data: (aqi) {
                          final statusText =
                              getPollutionStatus(aqi.aqi, 150).toLowerCase();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTapDown: (details) async {
                                  final selected = await showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      details.globalPosition.dx,
                                      details.globalPosition.dy,
                                      details.globalPosition.dx,
                                      0,
                                    ),
                                    items: ['Lahore', 'Karachi', 'Islamabad']
                                        .map((city) => PopupMenuItem(
                                              value: city,
                                              child: Text(city),
                                            ))
                                        .toList(),
                                  );
                                  if (selected != null) {
                                    notifier.fetchForCity(selected);
                                  }
                                },
                                child: Text(
                                  selectedCity,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Looks like the air is $statusText.",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                        orElse: () => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTapDown: (details) async {
                                final selected = await showMenu<String>(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    details.globalPosition.dx,
                                    details.globalPosition.dy,
                                    0,
                                    0,
                                  ),
                                  items: ['Lahore', 'Karachi', 'Islamabad']
                                      .map((city) => PopupMenuItem(
                                            value: city,
                                            child: Text(city),
                                          ))
                                      .toList(),
                                );
                                if (selected != null) {
                                  notifier.fetchForCity(selected);
                                }
                              },
                              child: Text(
                                selectedCity,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Fetching air quality...",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ⬇️ AQI Content
            Padding(
              padding: EdgeInsets.only(top: 100, bottom: screenHeight * 0.3),
              child: SingleChildScrollView(
                child: aqiState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Error: $e',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  data: (aqi) {
                    final percent = (aqi.aqi / 190).clamp(0.0, 1.0);
                    final color = getAqiColor(aqi.aqi);
                    return Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 140,
                          lineWidth: 10,
                          percent: percent,
                          animation: true,
                          animationDuration: 800,
                          backgroundColor:
                              const Color.fromARGB(255, 133, 193, 243),
                          progressColor: color,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${aqi.aqi}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'AQI',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.opacity,
                                color: Colors.lightBlueAccent),
                            const SizedBox(width: 4),
                            Text('${aqi.humidity ?? '--'}%',
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 24),
                            const Icon(Icons.thermostat_outlined,
                                color: Colors.orangeAccent),
                            const SizedBox(width: 4),
                            Text('${aqi.temperature ?? '--'}°C',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            /// ⬇️ Bottom Card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                child: aqiState.maybeWhen(
                  data: (aqi) => _bottomCard(aqi),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomCard(AqiData aqi) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pollutantRow(
                label: 'NO₂',
                value: aqi.no2 ?? Random().nextInt(50) + 1,
                max: 200,
              ),
              const SizedBox(height: 16),
              _pollutantRow(
                label: 'PM2.5',
                value: aqi.pm25 ?? 3,
                max: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pollutantRow({
    required String label,
    required int value,
    required double max,
  }) {
    final status = getPollutionStatus(value, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '      (µg/m³)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    status,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 4,
          percent: (value / max).clamp(0.0, 1.0),
          backgroundColor: Colors.grey.shade200,
          progressColor: getAqiColor(value),
          barRadius: const Radius.circular(20),
        ),
      ],
    );
  }
}
