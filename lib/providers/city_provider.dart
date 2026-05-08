import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../services/geocoding_service.dart';

const _selectedCityKey = 'selected_city';

final citySearchQueryProvider = StateProvider<String>((ref) => '');

final citySearchResultsProvider = FutureProvider.family<List<City>, String>((
  ref,
  query,
) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) {
    return [];
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
