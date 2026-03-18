import 'package:flutter/material.dart';

import '../../model/favorite.dart';
import '../../services/favoriter_service.dart';

class FavoriteManager with ChangeNotifier {
  final FavoriteService _service;

  List<Favorite> _items = [];

  FavoriteManager(this._service);

  List<Favorite> get items => _items;

  /// Load favorites
  Future<void> fetchFavorites(String userId) async {
    final records = await _service.fetchFavorites(userId);

    _items = records.map((e) => Favorite.fromJson(e.toJson())).toList();
    notifyListeners();
  }

  /// Check favorite
  bool isFavorite(String productId) {
    return _items.any((f) => f.productId == productId);
  }

  /// Toggle favorite
  Future<void> toggleFavorite(String userId, String productId) async {
    final existingIndex = _items.indexWhere((f) => f.productId == productId);

    if (existingIndex >= 0) {
      // XÓA
      final fav = _items[existingIndex];
      await _service.deleteFavorite(fav.id);
      _items.removeAt(existingIndex);
    } else {
      // THÊM
      final record = await _service.addFavorite(userId, productId);
      _items.add(Favorite.fromJson(record.toJson()));
    }

    notifyListeners();
  }
}
