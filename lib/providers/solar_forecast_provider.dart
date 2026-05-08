import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solar_forecast.dart';
import '../services/open_meteo_service.dart';
import 'location_provider.dart';

/// Provider for today's solar forecast data
/// Automatically fetches forecast when location changes
final todaysSolarForecastProvider =
    FutureProvider<ForecastData>((ref) async {
  // Watch the location provider - will refetch if location changes
  final location = await ref.watch(locationProvider.future);

  // Fetch solar forecast for the current location
  return await OpenMeteoService.getTodaysSolarForecast(
    latitude: location.latitude,
    longitude: location.longitude,
  );
});

/// Manually refreshable version of the forecast provider
/// Use ref.refresh(refreshableSolarForecastProvider) to trigger a manual refresh
final refreshableSolarForecastProvider =
    FutureProvider.autoDispose<ForecastData>((ref) async {
  final location = await ref.watch(locationProvider.future);

  return await OpenMeteoService.getTodaysSolarForecast(
    latitude: location.latitude,
    longitude: location.longitude,
  );
});
