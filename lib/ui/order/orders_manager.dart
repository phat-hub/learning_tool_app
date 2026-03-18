import 'package:flutter/material.dart';

import '../screen.dart';

class OrdersManager with ChangeNotifier {
  List<OrderItem> _orders = [];
  final OrderService _orderService = OrderService();

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total, String name,
      String phoneNumber, String address) async {
    final newOrder = OrderItem(
        id: 'o${DateTime.now().toIso8601String()}',
        amount: total,
        items: cartProducts,
        dateTime: DateTime.now(),
        name: name,
        phoneNumber: phoneNumber,
        address: address);
    final addOrder = await _orderService.addOrder(newOrder);
    if (addOrder != null) {
      _orders.insert(0, addOrder);
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    _orders = await _orderService.fetchOrders();
    notifyListeners();
  }

  Future<void> fetchUserOrders() async {
    _orders = await _orderService.fetchOrders(filteredByUser: true);
    notifyListeners();
  }

  Future<void> clearItem(String orderItemId) async {
    _orders = await _orderService.fetchOrders();
    final existingOrderItemIndex =
        _orders.indexWhere((orderItem) => orderItem.id == orderItemId);
    if (existingOrderItemIndex >= 0 &&
        await _orderService.deleteOrderItem(orderItemId)) {
      _orders.removeAt(existingOrderItemIndex);
    }
    notifyListeners();
  }
}
