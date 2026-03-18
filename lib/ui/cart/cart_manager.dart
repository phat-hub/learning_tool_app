import 'package:flutter/material.dart';

import '../screen.dart';

class CartManager with ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItem> _item = [];

  int get productCount {
    return _item.length;
  }

  int get totalAmount {
    var total = 0;
    _item.forEach((cartItem) {
      if (cartItem.select) {
        total += cartItem.price * cartItem.quantity;
      }
    });
    return total;
  }

  List<CartItem> get items {
    return [..._item];
  }

  int get selectProductCount {
    return _item.where((item) => item.select).toList().length;
  }

  Future<void> addCartItem(Product product, int quantity,
      {bool add = true}) async {
    _item = await _cartService.fetchCartItems();
    // Kiểm tra xem sản phẩm đã tồn tại trong danh sách _item hay chưa
    final existingCartItemIndex =
        _item.indexWhere((cartItem) => cartItem.productId == product.id);

    if (existingCartItemIndex >= 0) {
      // Nếu sản phẩm đã tồn tại, cập nhật số lượng sản phẩm
      final updatedCartItem;
      if (add) {
        updatedCartItem = _item[existingCartItemIndex].copyWith(
          quantity: _item[existingCartItemIndex].quantity + quantity,
        );
      } else {
        updatedCartItem = _item[existingCartItemIndex].copyWith(
          quantity: _item[existingCartItemIndex].quantity - quantity,
        );
      }

      _item[existingCartItemIndex] = updatedCartItem;

      // Cập nhật sản phẩm trên cơ sở dữ liệu
      await _cartService.updateCartItem(updatedCartItem);
    } else {
      // Nếu sản phẩm chưa tồn tại, thêm sản phẩm mới
      final newCartItem = await _cartService.addCartItem(
        CartItem(
          title: product.title,
          imageUrl: product.imageURL1,
          price: product.price,
          quantity: quantity,
          select: true,
          productId: product.id!,
        ),
      );

      if (newCartItem != null) {
        _item.add(newCartItem);
      }
    }
    notifyListeners();
  }

  Future<void> updateSelectCartItems(Product product, bool select) async {
    _item = await _cartService.fetchCartItems();
    // Kiểm tra xem sản phẩm đã tồn tại trong danh sách _item hay chưa
    final existingCartItemIndex =
        _item.indexWhere((cartItem) => cartItem.productId == product.id);

    if (existingCartItemIndex >= 0) {
      final updatedCartItem =
          _item[existingCartItemIndex].copyWith(select: select);

      _item[existingCartItemIndex] = updatedCartItem;

      await _cartService.updateCartItem(updatedCartItem, check: true);
    }
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    _item = await _cartService.fetchCartItems();
    notifyListeners();
  }

  Future<void> fetchSelectedCartItems() async {
    _item = await _cartService.fetchCartItems();
    // Lọc ra các item có select là true
    _item = _item.where((item) => item.select == true).toList();
    notifyListeners();
  }

  Future<void> clearItem(String cartItemId) async {
    _item = await _cartService.fetchCartItems();
    // Kiểm tra xem sản phẩm đã tồn tại trong danh sách _item hay chưa
    final existingCartItemIndex =
        _item.indexWhere((cartItem) => cartItem.id == cartItemId);
    if (existingCartItemIndex >= 0 &&
        await _cartService.deleteCartItem(cartItemId)) {
      _item.removeAt(existingCartItemIndex);
    }
    notifyListeners();
  }

  Future<void> clearSelectedItems() async {
    _item = await _cartService.fetchCartItems();

    // Lọc ra các sản phẩm có select == true
    final selectedItems = _item.where((cartItem) => cartItem.select).toList();

    for (var cartItem in selectedItems) {
      await _cartService.deleteCartItem(cartItem.id!);
      _item.remove(cartItem);
    }

    notifyListeners();
  }
}
