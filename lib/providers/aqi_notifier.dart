// lib/providers/aqi_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/models/aqi_data.dart';
import '../services/api_service.dart';
import 'package:initial_test/helper/locator.dart';

class AqiNotifier extends StateNotifier<AsyncValue<AqiData>> {
  final _api = locator<IApiService>();

  String? selectedCity; // ✅ Track selected city

  AqiNotifier() : super(const AsyncValue.loading());

  Future<void> fetchForCity(String city) async {
    selectedCity = city; // ✅ Save city name
    state = const AsyncValue.loading();
    try {
      final data = await _api.fetchAqi(city);
      state = AsyncValue.data(data);
    } catch (err, st) {
      state = AsyncValue.error(err, st);
    }
  }
}

final aqiProvider = StateNotifierProvider<AqiNotifier, AsyncValue<AqiData>>(
  (ref) => AqiNotifier(),
);
