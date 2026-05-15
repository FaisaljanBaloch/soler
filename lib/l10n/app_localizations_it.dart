// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Soler';

  @override
  String get selectCity => 'Seleziona Città';

  @override
  String get search => 'Cerca';

  @override
  String get settings => 'Impostazioni';

  @override
  String get location => 'Posizione';

  @override
  String get language => 'Lingua';

  @override
  String get darkMode => 'Modalita scura';

  @override
  String get information => 'Funzionalita';

  @override
  String get infoForecastTitle => 'Previsione solare oraria';

  @override
  String get infoForecastDescription =>
      'Vedi le prossime 24 ore di intensita solare in una timeline.';

  @override
  String get infoOptimalTitle => 'Finestra di uso ottimale';

  @override
  String get infoOptimalDescription =>
      'Evidenzia le ore migliori e una finestra consigliata.';

  @override
  String get infoNotificationsTitle => 'Notifiche intelligenti';

  @override
  String get infoNotificationsDescription =>
      'Avvisi prima e durante le finestre di alta produzione.';

  @override
  String get infoAutoRefreshTitle => 'Aggiornamento automatico';

  @override
  String get infoAutoRefreshDescription =>
      'Aggiorna le previsioni ogni 15 minuti.';

  @override
  String get infoCityTitle => 'Selezione citta';

  @override
  String get infoCityDescription =>
      'Cerca e salva una citta per previsioni localizzate.';

  @override
  String get infoTipsTitle => 'Consigli solari';

  @override
  String get infoTipsDescription =>
      'Suggerimenti rapidi per pianificare e monitorare i consumi.';

  @override
  String get optimalNoStrongWindow =>
      'Nessuna finestra solare forte nelle prossime 24 ore.';

  @override
  String get optimalApplianceWindowTitle =>
      'Finestra ottimale per gli elettrodomestici';

  @override
  String optimalTopHoursLabel(Object count) {
    return 'Le migliori $count ore secondo la previsione solare';
  }

  @override
  String get optimalChipWashingMachine => 'Lavatrice';

  @override
  String get optimalChipDishwasher => 'Lavastoviglie';

  @override
  String get optimalChipEvCharging => 'Ricarica EV';

  @override
  String get solarTipsTitle => 'Consigli per l\'energia solare';

  @override
  String get solarTipPeakHoursTitle => 'Ore di picco';

  @override
  String get solarTipPeakHoursDescription =>
      'La radiazione solare e piu alta tra le 10 e le 15';

  @override
  String get solarTipPlanAheadTitle => 'Pianifica in anticipo';

  @override
  String get solarTipPlanAheadDescription =>
      'Programma le attivita ad alto consumo nelle ore migliori';

  @override
  String get solarTipMonitorUsageTitle => 'Monitora i consumi';

  @override
  String get solarTipMonitorUsageDescription =>
      'Controlla spesso per previsioni aggiornate';

  @override
  String get about => 'Informazioni';

  @override
  String get english => 'Inglese';

  @override
  String get italian => 'Italiano';

  @override
  String get aboutText =>
      'Questa app e stata sviluppata per l\'hackathon EMS - Energia e Mobilita Sostenibile APS nel 2026. Sviluppata da Faisal Jan, studente di Data Science for Management presso l\'Universita di Parma.';

  @override
  String get solarForecast => 'Previsione solare di oggi';

  @override
  String get updated => 'Aggiornato';

  @override
  String get now => 'Adesso';

  @override
  String get noForecast => 'Nessuna previsione disponibile.';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get noCitySelected => 'Nessuna città selezionata';

  @override
  String get pullToRefresh => 'Tira per aggiornare';
}
