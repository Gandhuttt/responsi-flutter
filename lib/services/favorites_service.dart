import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location.dart';

class FavoritesService {
  static const _key = 'favorite_locations';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<Location>> load() async {
    final data = await _preferences.getString(_key);
    if (data == null) return [];
    return (jsonDecode(data) as List<dynamic>)
        .map((item) => Location.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Location> locations) => _preferences.setString(
    _key,
    jsonEncode(locations.map((location) => location.toJson()).toList()),
  );
}
