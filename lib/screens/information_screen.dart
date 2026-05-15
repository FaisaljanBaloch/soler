import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final features = <({IconData icon, String title, String description})>[
      (
        icon: Icons.bar_chart,
        title: l10n.infoForecastTitle,
        description: l10n.infoForecastDescription,
      ),
      (
        icon: Icons.bolt,
        title: l10n.infoOptimalTitle,
        description: l10n.infoOptimalDescription,
      ),
      (
        icon: Icons.notifications_active_outlined,
        title: l10n.infoNotificationsTitle,
        description: l10n.infoNotificationsDescription,
      ),
      (
        icon: Icons.refresh,
        title: l10n.infoAutoRefreshTitle,
        description: l10n.infoAutoRefreshDescription,
      ),
      (
        icon: Icons.location_city,
        title: l10n.infoCityTitle,
        description: l10n.infoCityDescription,
      ),
      (
        icon: Icons.lightbulb_outline,
        title: l10n.infoTipsTitle,
        description: l10n.infoTipsDescription,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.information)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: features.length,
        separatorBuilder: (context, index) =>
            Divider(height: 24, color: colorScheme.outlineVariant),
        itemBuilder: (context, index) {
          final feature = features[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(feature.icon, color: colorScheme.primary),
            title: Text(
              feature.title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(feature.description),
          );
        },
      ),
    );
  }
}
