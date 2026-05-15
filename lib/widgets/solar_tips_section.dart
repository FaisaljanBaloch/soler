import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SolarTipsSection extends StatelessWidget {
  const SolarTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.solarTipsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _TipItem(
            title: l10n.solarTipPeakHoursTitle,
            description: l10n.solarTipPeakHoursDescription,
            icon: Icons.wb_sunny,
          ),
          _TipItem(
            title: l10n.solarTipPlanAheadTitle,
            description: l10n.solarTipPlanAheadDescription,
            icon: Icons.schedule,
          ),
          _TipItem(
            title: l10n.solarTipMonitorUsageTitle,
            description: l10n.solarTipMonitorUsageDescription,
            icon: Icons.analytics,
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
