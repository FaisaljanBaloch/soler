// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Soler';

  @override
  String get selectCity => 'Select City';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get location => 'Location';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get information => 'Information';

  @override
  String get infoForecastTitle => 'Hourly solar forecast';

  @override
  String get infoForecastDescription =>
      'See the next 24 hours of solar intensity in a timeline.';

  @override
  String get infoOptimalTitle => 'Optimal use window';

  @override
  String get infoOptimalDescription =>
      'Highlights the top forecast hours and a recommended window.';

  @override
  String get infoNotificationsTitle => 'Smart notifications';

  @override
  String get infoNotificationsDescription =>
      'Alerts before and during high-production windows.';

  @override
  String get infoAutoRefreshTitle => 'Auto refresh';

  @override
  String get infoAutoRefreshDescription =>
      'Updates forecasts automatically every 15 minutes.';

  @override
  String get infoCityTitle => 'City selection';

  @override
  String get infoCityDescription =>
      'Search and save a city for localized forecasts.';

  @override
  String get infoTipsTitle => 'Solar tips';

  @override
  String get infoTipsDescription =>
      'Quick guidance for planning and monitoring usage.';

  @override
  String get about => 'About';

  @override
  String get english => 'English';

  @override
  String get italian => 'Italian';

  @override
  String get aboutText =>
      'This app was developed for the CerHack 2024 hackathon, organized by the CERTH research center. The developer is Faisal J.';

  @override
  String get solarForecast => 'Today\'s Solar Forecast';

  @override
  String get updated => 'Updated';

  @override
  String get now => 'Now';

  @override
  String get noForecast => 'No forecast available.';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noCitySelected => 'No city selected';

  @override
  String get pullToRefresh => 'Pull to refresh';
}
