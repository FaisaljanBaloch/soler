import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _selectedLanguageKey = 'selected_language';

enum AppLanguage { english, italian }

extension AppLanguageLocale on AppLanguage {
  Locale get locale {
    switch (this) {
      case AppLanguage.italian:
        return const Locale('it');
      case AppLanguage.english:
        return const Locale('en');
    }
  }
}

final selectedLanguageProvider =
    AsyncNotifierProvider<SelectedLanguageNotifier, AppLanguage>(
      SelectedLanguageNotifier.new,
    );

class SelectedLanguageNotifier extends AsyncNotifier<AppLanguage> {
  @override
  Future<AppLanguage> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_selectedLanguageKey);
    if (stored == AppLanguage.italian.name) {
      return AppLanguage.italian;
    }
    return AppLanguage.english;
  }

  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, language.name);
    state = AsyncData(language);
  }
}
