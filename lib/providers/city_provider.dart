import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../services/geocoding_service.dart';

const _selectedCityKey = 'selected_city';

const _defaultCities = [
  City(
    name: 'Athens',
    latitude: 37.9838,
    longitude: 23.7275,
    admin1: 'Attica',
    country: 'Greece',
  ),
  City(
    name: 'Barcelona',
    latitude: 41.3874,
    longitude: 2.1686,
    admin1: 'Catalonia',
    country: 'Spain',
  ),
  City(
    name: 'Berlin',
    latitude: 52.52,
    longitude: 13.405,
    admin1: 'Berlin',
    country: 'Germany',
  ),
  City(
    name: 'Cairo',
    latitude: 30.0444,
    longitude: 31.2357,
    admin1: 'Cairo',
    country: 'Egypt',
  ),
  City(
    name: 'Lisbon',
    latitude: 38.7223,
    longitude: -9.1393,
    admin1: 'Lisbon',
    country: 'Portugal',
  ),
  City(
    name: 'London',
    latitude: 51.5072,
    longitude: -0.1276,
    admin1: 'England',
    country: 'United Kingdom',
  ),
  City(
    name: 'Milan',
    latitude: 45.4642,
    longitude: 9.19,
    admin1: 'Lombardy',
    country: 'Italy',
  ),
  City(
    name: 'Nairobi',
    latitude: -1.2864,
    longitude: 36.8172,
    admin1: 'Nairobi Area',
    country: 'Kenya',
  ),
  City(
    name: 'New York',
    latitude: 40.7128,
    longitude: -74.006,
    admin1: 'New York',
    country: 'United States',
  ),
  City(
    name: 'Rome',
    latitude: 41.9028,
    longitude: 12.4964,
    admin1: 'Lazio',
    country: 'Italy',
  ),
  City(
    name: 'Stockholm',
    latitude: 59.3293,
    longitude: 18.0686,
    admin1: 'Stockholm',
    country: 'Sweden',
  ),
  City(
    name: 'Tokyo',
    latitude: 35.6762,
    longitude: 139.6503,
    admin1: 'Tokyo',
    country: 'Japan',
  ),
];

final citySearchQueryProvider = StateProvider<String>((ref) => '');

final citySearchResultsProvider = FutureProvider.family<List<City>, String>((
  ref,
  query,
) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    final sortedDefaults = [..._defaultCities]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sortedDefaults;
  }

  return GeocodingService.searchCities(trimmed);
});

final selectedCityProvider = AsyncNotifierProvider<SelectedCityNotifier, City?>(
  SelectedCityNotifier.new,
);

class SelectedCityNotifier extends AsyncNotifier<City?> {
  @override
  Future<City?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString(_selectedCityKey);
    if (storedValue == null) {
      return null;
    }

    try {
      final json = jsonDecode(storedValue) as Map<String, dynamic>;
      return City.fromJson(json);
    } catch (_) {
      final fallbackResults = await GeocodingService.searchCities(storedValue);
      if (fallbackResults.isNotEmpty) {
        return fallbackResults.first;
      }
      return null;
    }
  }

  Future<void> setCity(City city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCityKey, jsonEncode(city.toJson()));
    state = AsyncData(city);
  }
}
