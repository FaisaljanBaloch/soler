import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soler/providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const lightGreen = Color(0xFFA5D6A7);
    const darkGreen = Color(0xFF1B5E20);
    const surfaceLight = Color(0xFFFFFFFF);

    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: darkGreen,
      onPrimary: Colors.white,
      secondary: lightGreen,
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: Color(0xFF0F1A13),
      surfaceContainerHighest: Color(0xFFE8F5E9),
      onSurfaceVariant: Color(0xFF2F3B33),
      outline: Color(0xFF91A295),
      outlineVariant: Color(0xFFC5D1C8),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF1A251E),
      onInverseSurface: Colors.white,
      inversePrimary: lightGreen,
      tertiary: Color(0xFF2E7D32),
      onTertiary: Colors.white,
    );

    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: lightGreen,
      onPrimary: Color(0xFF0F1A13),
      secondary: Color(0xFF2E7D32),
      onSecondary: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF14201A),
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF1F2B23),
      onSurfaceVariant: Color(0xFFB8C7BC),
      outline: Color(0xFF3C4A41),
      outlineVariant: Color(0xFF28352C),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: surfaceLight,
      onInverseSurface: Color(0xFF0F1A13),
      inversePrimary: darkGreen,
      tertiary: Color(0xFF66BB6A),
      onTertiary: Color(0xFF0F1A13),
    );

    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final language = ref.watch(selectedLanguageProvider);
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              scaffoldBackgroundColor: lightColorScheme.surface,
              appBarTheme: AppBarTheme(
                backgroundColor: lightColorScheme.surface,
                foregroundColor: lightColorScheme.onSurface,
                elevation: 1,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
              scaffoldBackgroundColor: darkColorScheme.surface,
              appBarTheme: AppBarTheme(
                backgroundColor: darkColorScheme.surface,
                foregroundColor: darkColorScheme.onSurface,
                elevation: 1,
              ),
            ),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            locale: language.value?.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
