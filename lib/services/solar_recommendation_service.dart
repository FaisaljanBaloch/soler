import '../models/solar_forecast.dart';

class SolarRecommendation {
  final DateTime start;
  final DateTime end;
  final List<SolarForecastHour> peakHours;

  const SolarRecommendation({
    required this.start,
    required this.end,
    required this.peakHours,
  });
}

class SolarRecommendationService {
  static const int defaultTopHours = 3;

  static List<SolarForecastHour> next24Forecasts(
    ForecastData forecastData,
    DateTime now,
  ) {
    final startHour = DateTime(now.year, now.month, now.day, now.hour);
    final endHour = startHour.add(const Duration(hours: 24));

    return forecastData.hourlyForecasts
        .where(
          (forecast) =>
              !forecast.timestamp.isBefore(startHour) &&
              forecast.timestamp.isBefore(endHour),
        )
        .toList();
  }

  static SolarRecommendation? buildRecommendation(
    ForecastData forecastData, {
    DateTime? now,
    int topHours = defaultTopHours,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final windowForecasts = next24Forecasts(forecastData, effectiveNow);

    if (windowForecasts.isEmpty) {
      return null;
    }

    final sortedByGhi = [...windowForecasts]
      ..sort((a, b) => b.ghi.compareTo(a.ghi));
    final peakHours = sortedByGhi.take(topHours).toList();

    final earliest = peakHours
        .map((forecast) => forecast.timestamp)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latest = peakHours
        .map((forecast) => forecast.timestamp)
        .reduce((a, b) => a.isAfter(b) ? a : b)
        .add(const Duration(hours: 1));

    return SolarRecommendation(
      start: earliest,
      end: latest,
      peakHours: peakHours,
    );
  }
}
