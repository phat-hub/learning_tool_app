import '../ui/screen.dart';

class OrderService {
  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final orderModel = await pb.collection('orders').create(
        body: {
          'userId': userId,
          'amount': order.amount,
          'dateTime': order.dateTime.toIso8601String(),
          'items': order.items.map((cartItem) => cartItem.toJson()).toList(),
          'name': order.name,
          'phoneNumber': order.phoneNumber,
          'address': order.address,
          'status': 'pending',
        },
      );

      return order.copyWith(
        id: orderModel.id,
      );
    } catch (error) {
      return null;
    }
  }

  Future<List<OrderItem>> fetchOrders({bool filteredByUser = false}) async {
    final List<OrderItem> orders = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final orderModels = await pb.collection('orders').getFullList(
          filter: filteredByUser ? "userId ='$userId'" : null,
          sort: '-dateTime');
      for (final orderModel in orderModels) {
        final orderItem = OrderItem.fromJson(orderModel.toJson());
        orders.add(orderItem);
      }
      return orders;
    } catch (error) {
      return orders;
    }
  }

  Future<bool> deleteOrderItem(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      // Xóa CartItem từ collection 'cart' dựa trên id
      await pb.collection('orders').delete(id);
      return true; // Trả về true khi xóa thành công
    } catch (error) {
      print("Lỗi khi xóa CartItem: '${error}'");
      return false; // Trả về false khi gặp lỗi
    }
  }

  Future<bool> updateOrderStatus(String id, String status) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('orders').update(id, body: {
        'status': status,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
