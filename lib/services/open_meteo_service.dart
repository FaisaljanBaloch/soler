import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/solar_forecast.dart';

/// Service for fetching solar forecast data from Open-Meteo API
class OpenMeteoService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Fetch solar forecast for given coordinates
  /// Returns [ForecastData] with hourly solar irradiance (GHI) values
  static Future<ForecastData> getTodaysSolarForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'latitude': latitude.toStringAsFixed(5),
          'longitude': longitude.toStringAsFixed(5),
          'hourly': 'shortwave_radiation',
          'forecast_days': '2',
          'timezone': 'auto',
        },
      );

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('API request timed out'),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch solar forecast: ${response.statusCode} ${response.reasonPhrase} ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Parse the response
      final times = List<String>.from(json['hourly']['time'] as List);
      final ghiValues = List<num>.from(
        json['hourly']['shortwave_radiation'] as List,
      );
      final timezone = json['timezone'] as String;

      // Create hourly forecast objects
      final hourlyForecasts = <SolarForecastHour>[];
      for (int i = 0; i < times.length; i++) {
        final timestamp = DateTime.parse(times[i]);
        final ghi = ghiValues[i].toDouble();

        hourlyForecasts.add(
          SolarForecastHour(timestamp: timestamp, ghi: ghi, hour: i),
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
