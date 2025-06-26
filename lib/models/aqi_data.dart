// lib/models/aqi_data.dart
class AqiData {
  /// Overall (composite) AQI 0-500
  final int aqi;

  /// Timestamp in the original string form
  final String time;

  /// The pollutant that produced the highest AQI
  final String dominantPollutant;

  // ── Pollutant concentrations (µg/m³) ────────────────────────────
  final int? pm25;
  final int? pm10;
  final int? no2;
  final int? o3;
  final int? so2;
  final int? co;

  // ── Optional weather data ───────────────────────────────────────
  final int? humidity; // %
  final int? temperature; // °C

  const AqiData({
    required this.aqi,
    required this.time,
    required this.dominantPollutant,
    this.pm25,
    this.pm10,
    this.no2,
    this.o3,
    this.so2,
    this.co,
    this.humidity,
    this.temperature,
  });

  /// Factory constructor from WAQI / OpenAQ JSON
  factory AqiData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final iaqi = (data['iaqi'] as Map<String, dynamic>?) ?? const {};

    int? _opt(String key) => iaqi[key] != null && iaqi[key]['v'] != null
        ? (iaqi[key]['v'] as num).round()
        : null;

    return AqiData(
      aqi: data['aqi'] as int,
      time: (data['time'] as Map<String, dynamic>)['s'] as String,
      dominantPollutant: data['dominentpol'] as String,
      pm25: _opt('pm25'),
      pm10: _opt('pm10'),
      no2: _opt('no2'),
      o3: _opt('o3'),
      so2: _opt('so2'),
      co: _opt('co'),
      humidity: _opt('h'), // relative humidity
      temperature: _opt('t'), // °C
    );
  }
}
