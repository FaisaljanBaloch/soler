import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class GeocodingService {
  static const String _baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  static Future<List<City>> searchCities(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'name': query,
        'count': '10',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http
        .get(uri)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('City search timed out'),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'City search failed: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'];
    if (results is! List) {
      return [];
    }

    return results
        .whereType<Map<String, dynamic>>()
        .map(City.fromJson)
        .toList();
  }
}
