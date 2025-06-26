// lib/models/aqi_data_model.dart
class AqiData {
  final int aqi;
  final String time;
  final String dominantPollutant;
  final int no2;
  final int pm25;
  final int? humidity;
  final int? temperature;

  AqiData({
    required this.aqi,
    required this.time,
    required this.dominantPollutant,
    required this.no2,
    required this.pm25,
    this.humidity,
    this.temperature,
  });

  factory AqiData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final iaqi = (data['iaqi'] as Map<String, dynamic>?) ?? {};

    int parseIaqi(String key) => (iaqi[key] != null && iaqi[key]['v'] != null)
        ? (iaqi[key]['v'] as num).round()
        : 0;

    int? parseOptional(String key) =>
        iaqi[key] != null && iaqi[key]['v'] != null
            ? (iaqi[key]['v'] as num).round()
            : null;

    return AqiData(
      aqi: data['aqi'] as int,
      time: (data['time'] as Map<String, dynamic>)['s'] as String,
      dominantPollutant: data['dominentpol'] as String,
      no2: parseIaqi('no2'),
      pm25: parseIaqi('pm25'),
      humidity: parseOptional('h'),
      temperature: parseOptional('t'),
    );
  }
}
