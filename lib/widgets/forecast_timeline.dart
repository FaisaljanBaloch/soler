import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soler/l10n/app_localizations.dart';
import '../models/solar_forecast.dart';
import '../services/solar_recommendation_service.dart';

/// Widget that displays hourly solar forecast as a horizontally scrollable timeline
/// Each hour shows a bar chart with intensity mapped to color
class ForecastTimeline extends StatelessWidget {
  final ForecastData forecastData;

  const ForecastTimeline({super.key, required this.forecastData});

  /// Get color based on GHI intensity value
  /// Color gradient: light green (low) -> green -> dark green (high)
  Color _getColorForIntensity(
    double ghi,
    double maxGhi,
    ColorScheme colorScheme,
  ) {
    if (maxGhi == 0) return colorScheme.surfaceContainerHighest;

    final normalizedValue = (ghi / maxGhi).clamp(0.0, 1.0);
    final lowColor = colorScheme.surfaceContainerHighest;
    final midColor = colorScheme.secondary;
    final highColor = colorScheme.primary;

    if (normalizedValue < 0.3) {
      // Light green for low values
      return Color.lerp(lowColor, midColor, normalizedValue / 0.3)!;
    } else if (normalizedValue < 0.6) {
      // Light green to green
      return Color.lerp(midColor, highColor, (normalizedValue - 0.3) / 0.3)!;
    } else {
      // Green to dark green
      return Color.lerp(
        highColor,
        highColor.withValues(alpha: 0.9),
        (normalizedValue - 0.6) / 0.4,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxGhi = forecastData.maxGhi;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final next24Forecasts = SolarRecommendationService.next24Forecasts(
      forecastData,
      now,
    );
    final displayForecasts = next24Forecasts.isNotEmpty
        ? next24Forecasts
        : forecastData.hourlyForecasts;
    final recommendation = SolarRecommendationService.buildRecommendation(
      forecastData,
      now: now,
    );
    final peakTimestamps = recommendation == null
        ? <int>{}
        : recommendation.peakHours
              .map((forecast) => forecast.timestamp.millisecondsSinceEpoch)
              .toSet();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          displayForecasts.length,
          (index) => _buildHourlyItem(
            displayForecasts[index],
            maxGhi,
            colorScheme,
            context,
            l10n,
            isNowLabel: index == 0,
            isPeak: peakTimestamps.contains(
              displayForecasts[index].timestamp.millisecondsSinceEpoch,
            ),
          ),
        ),
      ),
    );
  }

  /// Build individual hourly forecast item
  Widget _buildHourlyItem(
    SolarForecastHour forecast,
    double maxGhi,
    ColorScheme colorScheme,
    BuildContext context,
    AppLocalizations l10n, {
    bool isNowLabel = false,
    bool isPeak = false,
  }) {
    final color = _getColorForIntensity(forecast.ghi, maxGhi, colorScheme);
    final barHeight = (forecast.ghi / (maxGhi + 100)) * 150; // Max height 150
    final timeFormat = DateFormat('HH:mm');
    final label = isNowLabel ? l10n.now : timeFormat.format(forecast.timestamp);
    final peakBorderColor = colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Time label
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (isPeak) ...[
            Icon(Icons.bolt, size: 14, color: peakBorderColor),
            const SizedBox(height: 4),
          ],
          // Bar chart
          Container(
            width: 32,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              border: Border.all(
                color: isPeak ? peakBorderColor : color.withValues(alpha: 0.3),
                width: isPeak ? 2 : 1,
              ),
              boxShadow: isPeak
                  ? [
                      BoxShadow(
                        color: peakBorderColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
          // GHI value
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              forecast.ghi.toStringAsFixed(0),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header widget showing location and last updated time
class ForecastHeader extends StatelessWidget {
  final ForecastData forecastData;
  final String cityName;

  const ForecastHeader({
    super.key,
    required this.forecastData,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.solarForecast,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cityName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.updated} ${DateFormat.Hm().format(forecastData.updatedAt)}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (forecastData.totalGhi > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.solar_power,
                            color: colorScheme.onPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${forecastData.totalGhi.toStringAsFixed(2)} kWh/m²',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
