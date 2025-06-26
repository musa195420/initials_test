import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/models/aqi_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/aqi_notifier.dart';

class AqiScreen extends ConsumerWidget {
  const AqiScreen({super.key});

  static Color getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiState = ref.watch(aqiProvider);
    final notifier = ref.read(aqiProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 119, 230),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Select city',
                          style: TextStyle(color: Colors.white)),
                      dropdownColor: Colors.blueAccent,
                      items: ['Lahore', 'Karachi', 'Islamabad']
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (city) {
                        if (city != null) notifier.fetchForCity(city);
                      },
                    ),
                    const SizedBox(height: 24),
                    aqiState.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e',
                          style: const TextStyle(color: Colors.white)),
                      data: (aqi) {
                        final percent = (aqi.aqi / 500).clamp(0.0, 1.0);
                        final color = getAqiColor(aqi.aqi);

                        return Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 140,
                              lineWidth: 10,
                              percent: percent,
                              animation: true,
                              animationDuration: 800,
                              backgroundColor: Colors.blue.shade100,
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
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(width: 24),
                                const Icon(Icons.thermostat_outlined,
                                    color: Colors.orangeAccent),
                                const SizedBox(width: 4),
                                Text('${aqi.temperature ?? '--'}°C',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 100),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.transparent,
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
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pollutantRow(
                label: 'NO₂',
                value: aqi.no2,
                max: 200,
              ),
              const SizedBox(height: 16),
              _pollutantRow(
                label: 'PM2.5',
                value: aqi.pm25,
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
                  Text(
                    '      (µg/m³)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    status,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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

  String getPollutionStatus(int value, double max) {
    double percent = (value / max).clamp(0.0, 1.0);

    if (percent <= 0.2) return "Excellent";
    if (percent <= 0.4) return "Good";
    if (percent <= 0.6) return "Moderate";
    if (percent <= 0.8) return "Unhealthy";
    return "Hazardous";
  }
}
