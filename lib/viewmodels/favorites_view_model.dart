import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../services/favorites_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel(this._service) {
    _ready = _load();
  }

  final FavoritesService _service;
  late final Future<void> _ready;
  Future<void> _pending = Future.value();
  List<Location> _locations = const [];
  bool _loading = true;
  bool _loadFailed = false;
  bool _hasError = false;
  bool _disposed = false;

  List<Location> get locations => _locations;
  bool get loading => _loading;
  bool get hasError => _hasError;
  bool isFavorite(Location location) =>
      _locations.any((item) => item.id == location.id);

  Future<void> _load() async {
    try {
      _locations = List.unmodifiable(await _service.load());
    } catch (_) {
      _hasError = true;
      _loadFailed = true;
    } finally {
      _loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> toggle(Location location) {
    final operation = _pending.then((_) async {
      await _ready;
      if (_loadFailed) return;
      final updated = [..._locations];
      final index = updated.indexWhere((item) => item.id == location.id);
      if (index == -1) {
        updated.add(location);
      } else {
        updated.removeAt(index);
      }
      try {
        await _service.save(updated);
        _locations = List.unmodifiable(updated);
        _hasError = false;
      } catch (_) {
        _hasError = true;
      }
      if (!_disposed) notifyListeners();
    });
    _pending = operation;
    return operation;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
