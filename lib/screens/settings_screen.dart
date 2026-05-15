import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/city_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'about_screen.dart';
import 'information_screen.dart';
import 'language_settings_screen.dart';
import 'location_settings_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCityAsync = ref.watch(selectedCityProvider);
    final languageAsync = ref.watch(selectedLanguageProvider);
    final themeModeAsync = ref.watch(themeModeProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeModeAsync.maybeWhen(
      data: (mode) => mode == ThemeMode.dark,
      orElse: () => false,
    );
    final canToggleTheme = themeModeAsync.hasValue;
    final locationSubtitle = selectedCityAsync.maybeWhen(
      data: (city) => city == null ? l10n.noCitySelected : city.name,
      orElse: () => '${l10n.loading}...',
    );
    final languageSubtitle = languageAsync.maybeWhen(
      data: (language) =>
          language == AppLanguage.italian ? l10n.italian : l10n.english,
      orElse: () => '${l10n.loading}...',
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(l10n.location),
            subtitle: Text(locationSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LocationSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(languageSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LanguageSettingsScreen(),
                ),
              );
            },
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.darkMode),
            value: isDarkMode,
            onChanged: canToggleTheme
                ? (value) {
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  }
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l10n.information),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InformationScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
