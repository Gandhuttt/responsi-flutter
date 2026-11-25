import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, success, empty, error }

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._service);

  final WeatherService _service;
  WeatherStatus _status = WeatherStatus.initial;
  Location? _location;
  Weather? _weather;
  int _requestId = 0;
  bool _disposed = false;

  WeatherStatus get status => _status;
  Location? get location => _location;
  Weather? get weather => _weather;

  Future<void> load(Location location) async {
    final requestId = ++_requestId;
    _location = location;
    _weather = null;
    _status = WeatherStatus.loading;
    notifyListeners();
    try {
      final weather = await _service.fetch(location);
      if (_disposed || requestId != _requestId) return;
      _weather = weather;
      _status = weather.daily.isEmpty
          ? WeatherStatus.empty
          : WeatherStatus.success;
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      _status = WeatherStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _service.dispose();
    super.dispose();
  }
}
