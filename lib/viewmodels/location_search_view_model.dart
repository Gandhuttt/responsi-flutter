import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../services/geocoding_service.dart';

enum SearchStatus { initial, loading, success, empty, error }

class LocationSearchViewModel extends ChangeNotifier {
  LocationSearchViewModel(this._service);

  final GeocodingService _service;
  SearchStatus _status = SearchStatus.initial;
  List<Location> _locations = const [];
  int _requestId = 0;
  bool _disposed = false;

  SearchStatus get status => _status;
  List<Location> get locations => _locations;

  Future<void> search(String query) async {
    final requestId = ++_requestId;
    final name = query.trim();
    _locations = const [];
    if (name.isEmpty) {
      _status = SearchStatus.initial;
      notifyListeners();
      return;
    }
    _status = SearchStatus.loading;
    notifyListeners();
    try {
      final locations = await _service.search(name);
      if (_disposed || requestId != _requestId) return;
      _locations = List.unmodifiable(locations);
      _status = locations.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      _status = SearchStatus.error;
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
