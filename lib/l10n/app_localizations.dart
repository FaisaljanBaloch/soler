import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Soler'**
  String get appTitle;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @infoForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Hourly solar forecast'**
  String get infoForecastTitle;

  /// No description provided for @infoForecastDescription.
  ///
  /// In en, this message translates to:
  /// **'See the next 24 hours of solar intensity in a timeline.'**
  String get infoForecastDescription;

  /// No description provided for @infoOptimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Optimal use window'**
  String get infoOptimalTitle;

  /// No description provided for @infoOptimalDescription.
  ///
  /// In en, this message translates to:
  /// **'Highlights the top forecast hours and a recommended window.'**
  String get infoOptimalDescription;

  /// No description provided for @infoNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart notifications'**
  String get infoNotificationsTitle;

  /// No description provided for @infoNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Alerts before and during high-production windows.'**
  String get infoNotificationsDescription;

  /// No description provided for @infoAutoRefreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto refresh'**
  String get infoAutoRefreshTitle;

  /// No description provided for @infoAutoRefreshDescription.
  ///
  /// In en, this message translates to:
  /// **'Updates forecasts automatically every 15 minutes.'**
  String get infoAutoRefreshDescription;

  /// No description provided for @infoCityTitle.
  ///
  /// In en, this message translates to:
  /// **'City selection'**
  String get infoCityTitle;

  /// No description provided for @infoCityDescription.
  ///
  /// In en, this message translates to:
  /// **'Search and save a city for localized forecasts.'**
  String get infoCityDescription;

  /// No description provided for @infoTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Solar tips'**
  String get infoTipsTitle;

  /// No description provided for @infoTipsDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick guidance for planning and monitoring usage.'**
  String get infoTipsDescription;

  /// No description provided for @optimalNoStrongWindow.
  ///
  /// In en, this message translates to:
  /// **'No strong solar window in the next 24 hours.'**
  String get optimalNoStrongWindow;

  /// No description provided for @optimalApplianceWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Optimal appliance window'**
  String get optimalApplianceWindowTitle;

  /// No description provided for @optimalTopHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Top {count} hours by solar forecast'**
  String optimalTopHoursLabel(Object count);

  /// No description provided for @optimalChipWashingMachine.
  ///
  /// In en, this message translates to:
  /// **'Washing machine'**
  String get optimalChipWashingMachine;

  /// No description provided for @optimalChipDishwasher.
  ///
  /// In en, this message translates to:
  /// **'Dishwasher'**
  String get optimalChipDishwasher;

  /// No description provided for @optimalChipEvCharging.
  ///
  /// In en, this message translates to:
  /// **'EV charging'**
  String get optimalChipEvCharging;

  /// No description provided for @solarTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Solar Energy Tips'**
  String get solarTipsTitle;

  /// No description provided for @solarTipPeakHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Peak Hours'**
  String get solarTipPeakHoursTitle;

  /// No description provided for @solarTipPeakHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Solar radiation is highest between 10 AM and 3 PM'**
  String get solarTipPeakHoursDescription;

  /// No description provided for @solarTipPlanAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Ahead'**
  String get solarTipPlanAheadTitle;

  /// No description provided for @solarTipPlanAheadDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule high-energy tasks during peak forecast hours'**
  String get solarTipPlanAheadDescription;

  /// No description provided for @solarTipMonitorUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor Usage'**
  String get solarTipMonitorUsageTitle;

  /// No description provided for @solarTipMonitorUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'Check back regularly for updated forecasts'**
  String get solarTipMonitorUsageDescription;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'This app was developed for the EMS - Energia e Mobilita Sostenibile APS hackathon in 2026. Developed by Faisal Jan, a student of Data Science for Management at the University of Parma.'**
  String get aboutText;

  /// No description provided for @solarForecast.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Solar Forecast'**
  String get solarForecast;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @noForecast.
  ///
  /// In en, this message translates to:
  /// **'No forecast available.'**
  String get noForecast;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noCitySelected.
  ///
  /// In en, this message translates to:
  /// **'No city selected'**
  String get noCitySelected;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
