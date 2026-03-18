import 'package:flutter/material.dart';

import '../screen.dart';

class ProductManager with ChangeNotifier {
  final ProductsService _productsService = ProductsService();
  List<Product> _item = [];
  String _searchQuery = '';

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<Product> get filteredItems {
    if (_searchQuery.isEmpty) {
      return [..._item];
    }

    return _item.where((product) {
      return product.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  bool isFavoriteById(String id) {
    return _item.firstWhere((item) => item.id == id).isFavorite;
  }

  int get itemCount {
    return _item.length;
  }

  List<Product> get items {
    return filteredItems;
  }

  List<Product> get favoriteItems {
    return _item.where((item) => item.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
      _item.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _item.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final updatedProduct = await _productsService.updateProduct(product);
      if (updatedProduct != null) {
        _item[index] = updatedProduct;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _item.indexWhere((item) => item.id == id);
    if (index >= 0 && !await _productsService.deleteProduct(id)) {
      _item.removeAt(index);
      notifyListeners();
    }
  }

  Product? findById(String id) {
    try {
      return _item.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchProduct() async {
    _item = await _productsService.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchUserProduct() async {
    _item = await _productsService.fetchProducts(
      filteredByUser: true,
    );
    notifyListeners();
  }
}
