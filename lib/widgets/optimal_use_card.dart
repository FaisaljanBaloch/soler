import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/solar_forecast.dart';
import '../services/solar_recommendation_service.dart';

class OptimalUseCard extends StatelessWidget {
  final ForecastData forecastData;

  const OptimalUseCard({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    final recommendation = SolarRecommendationService.buildRecommendation(
      forecastData,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (recommendation == null) {
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No strong solar window in the next 24 hours.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final timeFormat = DateFormat('EEE HH:mm');
    final shortTimeFormat = DateFormat('HH:mm');
    final sameDay = recommendation.start.day == recommendation.end.day;
    final rangeLabel = sameDay
        ? '${timeFormat.format(recommendation.start)} - ${shortTimeFormat.format(recommendation.end)}'
        : '${timeFormat.format(recommendation.start)} - ${timeFormat.format(recommendation.end)}';

    final peakHours = [...recommendation.peakHours]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final peakLabels = peakHours
        .map((hour) => shortTimeFormat.format(hour.timestamp))
        .toList();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: colorScheme.tertiary),
                const SizedBox(width: 8),
                Text(
                  'Optimal appliance window',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              rangeLabel,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Top ${peakLabels.length} hours by solar forecast',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: peakLabels
                  .map(
                    (label) => Chip(
                      label: Text(label),
                      backgroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Washing machine')),
                Chip(label: Text('Dishwasher')),
                Chip(label: Text('EV charging')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
