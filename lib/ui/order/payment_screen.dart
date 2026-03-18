import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  PaymentScreen(CartItem? cartItem, {super.key}) {
    if (cartItem == null) {
      this.cartItem = CartItem(
          title: '', imageUrl: '', quantity: 0, price: 0, productId: '');
    } else {
      this.cartItem = cartItem;
    }
  }
  late final CartItem cartItem;
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Future<void> _fetchSelectedCartItems;

  @override
  void initState() {
    super.initState();
    _fetchSelectedCartItems =
        context.read<CartManager>().fetchSelectedCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context);
    final user = authManager.getUserDetails();
    final cart = context.watch<CartManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchSelectedCartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Phần thông tin người nhận
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Địa chỉ nhận hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('Họ và tên: ${user['name']}'),
                        SizedBox(height: 5),
                        Text('Số điện thoại: ${user['phoneNumber']}'),
                        SizedBox(height: 5),
                        Text('Địa chỉ: ${user['address']}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Phần thông tin sản phẩm
                  widget.cartItem.productId != ''
                      ? PaymentItemCard([widget.cartItem])
                      : PaymentItemCard(cart.items),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Lỗi tải dữ liệu thanh toán'),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.cartItem.productId != ''
                ? Text(
                    'Tổng tiền: ${NumberFormat.decimalPattern().format(widget.cartItem.price * widget.cartItem.quantity)} VND',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'Tổng tiền: ${NumberFormat.decimalPattern().format(cart.totalAmount)} VND',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            FloatingActionButton.extended(
              onPressed: () {
                if (widget.cartItem.productId != '') {
                  context.read<OrdersManager>().addOrder(
                    [widget.cartItem],
                    (widget.cartItem.price * widget.cartItem.quantity)
                        .toDouble(),
                    user['name'],
                    user['phoneNumber'],
                    user['address'],
                  );
                } else {
                  context.read<OrdersManager>().addOrder(
                        cart.items,
                        cart.totalAmount.toDouble(),
                        user['name'],
                        user['phoneNumber'],
                        user['address'],
                      );
                  cart.clearSelectedItems();
                }
                Navigator.of(context).pushReplacementNamed('/order_screen');
              },
              label: const Text('Thanh toán'),
              icon: const Icon(Icons.payment),
            ),
          ],
        ),
      ),
    );
  }
}
