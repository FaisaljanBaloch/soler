import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const entries = [
      ('1', 'Amina Okafor', '1,240 kWh'),
      ('2', 'Luca Romano', '1,110 kWh'),
      ('3', 'Sara Ahmed', '980 kWh'),
      ('4', 'Mateo Silva', '910 kWh'),
      ('5', 'Priya Das', '860 kWh'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text.rich(
          TextSpan(
            text: 'Sol',
            children: [
              TextSpan(
                text: 'ER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Top consumers by energy use',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Placeholder data. Ranking logic will be added soon.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Text(entry.$1),
                ),
                title: Text(entry.$2),
                trailing: Text(
                  entry.$3,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
