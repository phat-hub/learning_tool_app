import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/order_screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    final authManager = Provider.of<AuthManager>(context, listen: false);
    final user = authManager.getUserDetails();

    if (user['role'] == 'admin') {
      _fetchOrders = context.read<OrdersManager>().fetchOrders();
    } else {
      _fetchOrders = context.read<OrdersManager>().fetchUserOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Có lỗi khi tải dữ liệu đơn hàng.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<OrdersManager>(
              builder: (ctx, ordersManager, child) {
                if (ordersManager.orders.isEmpty) {
                  return const Center(
                    child: Text('Chưa có đơn hàng nào.'),
                  );
                }

                return ListView.builder(
                  itemCount: ordersManager.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderItemCard(ordersManager.orders[i]),
                );
              },
            );
          }

          return const Center(
            child: Text('Lỗi không xác định.'),
          );
        },
      ),
    );
  }
}
