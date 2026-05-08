import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/solar_forecast.dart';

/// Service for fetching solar forecast data from Open-Meteo API
class OpenMeteoService {
  static const String _baseUrl = 'https://archive-api.open-meteo.com/v1/archive';

  /// Fetch today's solar forecast for given coordinates
  /// Returns [ForecastData] with hourly solar irradiance (GHI) values
  static Future<ForecastData> getTodaysSolarForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateStr = today.toIso8601String().split('T')[0]; // YYYY-MM-DD

      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'start_date': dateStr,
          'end_date': dateStr,
          'hourly': 'global_horizontal_irradiance',
          'timezone': 'auto',
        },
      );

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('API request timed out'),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch solar forecast: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Parse the response
      final times = List<String>.from(json['hourly']['time'] as List);
      final ghiValues = List<num>.from(json['hourly']['global_horizontal_irradiance'] as List);
      final timezone = json['timezone'] as String;

      // Create hourly forecast objects
      final hourlyForecasts = <SolarForecastHour>[];
      for (int i = 0; i < times.length; i++) {
        final timestamp = DateTime.parse(times[i]);
        final ghi = ghiValues[i].toDouble();

        hourlyForecasts.add(
          SolarForecastHour(
            timestamp: timestamp,
            ghi: ghi,
            hour: i,
          ),
        );
      }

      return ForecastData(
        hourlyForecasts: hourlyForecasts,
        timezone: timezone,
        latitude: latitude,
        longitude: longitude,
        generatedAt: DateTime.now(),
      );
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
