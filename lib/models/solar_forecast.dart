/// Model representing a single hour of solar forecast data
class SolarForecastHour {
  final DateTime timestamp;
  final double ghi; // Global Horizontal Irradiance in W/m²
  final int hour;

  SolarForecastHour({
    required this.timestamp,
    required this.ghi,
    required this.hour,
  });

  factory SolarForecastHour.fromJson(Map<String, dynamic> json, int index) {
    return SolarForecastHour(
      timestamp: DateTime.parse(json['time'] as String),
      ghi: (json['ghi'] as num).toDouble(),
      hour: index,
    );
  }

  Map<String, dynamic> toJson() => {
    'time': timestamp.toIso8601String(),
    'ghi': ghi,
    'hour': hour,
  };
}

/// Model representing today's complete solar forecast
class ForecastData {
  final List<SolarForecastHour> hourlyForecasts;
  final String timezone;
  final double latitude;
  final double longitude;
  final DateTime generatedAt;

  ForecastData({
    required this.hourlyForecasts,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.generatedAt,
  });

  DateTime get updatedAt => generatedAt;

  double get totalGhi {
    if (hourlyForecasts.isEmpty) return 0;
    final totalWh = hourlyForecasts.fold(
      0.0,
      (sum, forecast) => sum + forecast.ghi,
    );
    return totalWh / 1000;
  }

  /// Get maximum GHI value for scaling visualization
  double get maxGhi {
    if (hourlyForecasts.isEmpty) return 0;
    return hourlyForecasts.map((f) => f.ghi).reduce((a, b) => a > b ? a : b);
  }

  /// Get current hour's forecast (next hour or current)
  SolarForecastHour? get currentHourForecast {
    final now = DateTime.now();
    final currentHour = now.hour;

    try {
      return hourlyForecasts.firstWhere((f) => f.timestamp.hour == currentHour);
    } catch (e) {
      return null;
    }
  }
}
