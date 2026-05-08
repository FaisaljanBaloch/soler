import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solar_forecast.dart';
import '../services/open_meteo_service.dart';
import 'city_provider.dart';

/// Provider for today's solar forecast data
/// Automatically fetches forecast when location changes
final todaysSolarForecastProvider = FutureProvider<ForecastData>((ref) async {
  final city = await ref.watch(selectedCityProvider.future);
  if (city == null) {
    throw Exception('Select a city to load the forecast.');
  }

  // Fetch solar forecast for the selected city
  return await OpenMeteoService.getTodaysSolarForecast(
    latitude: city.latitude,
    longitude: city.longitude,
  );
});

/// Manually refreshable version of the forecast provider
/// Use ref.refresh(refreshableSolarForecastProvider) to trigger a manual refresh
final refreshableSolarForecastProvider =
    FutureProvider.autoDispose<ForecastData>((ref) async {
      final city = await ref.watch(selectedCityProvider.future);
      if (city == null) {
        throw Exception('Select a city to load the forecast.');
      }

      return await OpenMeteoService.getTodaysSolarForecast(
        latitude: city.latitude,
        longitude: city.longitude,
      );
    });
