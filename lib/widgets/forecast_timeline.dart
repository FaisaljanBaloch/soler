import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/solar_forecast.dart';

/// Widget that displays hourly solar forecast as a horizontally scrollable timeline
/// Each hour shows a bar chart with intensity mapped to color
class ForecastTimeline extends StatelessWidget {
  final ForecastData forecastData;

  const ForecastTimeline({
    super.key,
    required this.forecastData,
  });

  /// Get color based on GHI intensity value
  /// Color gradient: yellow (low) -> orange -> red (high)
  Color _getColorForIntensity(double ghi, double maxGhi) {
    if (maxGhi == 0) return Colors.grey[200]!;

    final normalizedValue = (ghi / maxGhi).clamp(0.0, 1.0);

    if (normalizedValue < 0.3) {
      // Light yellow for low values
      return Color.lerp(Colors.grey[300]!, Colors.yellow.shade300, normalizedValue / 0.3)!;
    } else if (normalizedValue < 0.6) {
      // Yellow to orange
      return Color.lerp(
        Colors.yellow.shade300,
        Colors.orange.shade400,
        (normalizedValue - 0.3) / 0.3,
      )!;
    } else {
      // Orange to red
      return Color.lerp(
        Colors.orange.shade400,
        Colors.red.shade600,
        (normalizedValue - 0.6) / 0.4,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxGhi = forecastData.maxGhi;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          forecastData.hourlyForecasts.length,
          (index) => _buildHourlyItem(
            forecastData.hourlyForecasts[index],
            maxGhi,
            context,
          ),
        ),
      ),
    );
  }

  /// Build individual hourly forecast item
  Widget _buildHourlyItem(
    SolarForecastHour forecast,
    double maxGhi,
    BuildContext context,
  ) {
    final color = _getColorForIntensity(forecast.ghi, maxGhi);
    final barHeight = (forecast.ghi / (maxGhi + 100)) * 150; // Max height 150
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Time label
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              timeFormat.format(forecast.timestamp),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
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
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          // GHI value
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              forecast.ghi.toStringAsFixed(0),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

  const ForecastHeader({
    super.key,
    required this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Solar Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Location: ${forecastData.latitude.toStringAsFixed(2)}°, ${forecastData.longitude.toStringAsFixed(2)}° • ${forecastData.timezone}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'Updated: ${timeFormat.format(forecastData.generatedAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 8),
          // Legend for color intensity
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildLegendItem('Low', Colors.yellow.shade300),
                const SizedBox(width: 16),
                _buildLegendItem('Medium', Colors.orange.shade400),
                const SizedBox(width: 16),
                _buildLegendItem('High', Colors.red.shade600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
