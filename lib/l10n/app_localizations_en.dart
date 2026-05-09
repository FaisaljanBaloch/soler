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
