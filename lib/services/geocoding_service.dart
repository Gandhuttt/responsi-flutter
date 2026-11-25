import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location.dart';

class GeocodingService {
  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Location>> search(String name) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': name,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Geocoding request failed: ${response.statusCode}',
        uri,
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? [];
    return results
        .map((result) => Location.fromJson(result as Map<String, dynamic>))
        .toList();
  }

  void dispose() => _client.close();
}
