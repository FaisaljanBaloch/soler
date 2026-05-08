import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageAsync = ref.watch(selectedLanguageProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: languageAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (language) => RadioGroup<AppLanguage>(
          groupValue: language,
          onChanged: (value) {
            if (value != null) {
              ref.read(selectedLanguageProvider.notifier).setLanguage(value);
            }
          },
          child: ListView(
            children: [
              RadioListTile<AppLanguage>(
                value: AppLanguage.english,
                title: Text(l10n.english),
              ),
              RadioListTile<AppLanguage>(
                value: AppLanguage.italian,
                title: Text(l10n.italian),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
