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
  String get about => 'Informazioni';

  @override
  String get english => 'Inglese';

  @override
  String get italian => 'Italiano';

  @override
  String get aboutText =>
      'Questa app è stata sviluppata per l\'hackathon CerHack 2024, organizzato dal centro di ricerca CERTH. Lo sviluppatore è Faisal J.';

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
