import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<void> _fetchCartItems;

  @override
  void initState() {
    super.initState();
    _fetchCartItems = context.read<CartManager>().fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Giỏ Hàng (${cart.productCount})'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder(
        future: _fetchCartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final cart = context.watch<CartManager>();
            if (cart.productCount == 0) {
              return const Center(
                child: Text('Chưa có sản phẩm nào được thêm vào giỏ hàng.'),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<CartManager>().fetchCartItems(),
              child: Column(
                children: [
                  Expanded(child: CartItemList(cart)),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Error loading cart items'),
          );
        },
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(this.cart, {super.key});

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: cart.items
              .map(
                (item) => CartItemCard(item),
              )
              .toList(),
        ),
        Positioned(
          bottom: 0,
          child: BottomBar(cart),
        )
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar(this.cart, {super.key});

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                  'Tổng cộng: ${NumberFormat.decimalPattern().format(cart.totalAmount)} VNĐ'),
            ),
          ),
          SizedBox(
            width: 1,
            height: 35,
            child: DecoratedBox(
                decoration: BoxDecoration(
              color: Colors.black,
            )),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.95,
                heightFactor: 0.8,
                child: Container(
                  //color: Colors.green,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kiểm tra nếu tổng tiền lớn hơn 0 mới chuyển sang trang thanh toán
                      if (cart.totalAmount > 0) {
                        final cartItem = CartItem(
                            title: '',
                            imageUrl: '',
                            quantity: 0,
                            price: 0,
                            productId: '');
                        Navigator.of(context)
                            .pushNamed('/payment', arguments: cartItem)
                            .then((_) {
                          context
                              .read<CartManager>()
                              .fetchCartItems(); // Làm mới giỏ hàng khi quay lại
                        });
                      } else {
                        // Hiển thị thông báo nếu tổng tiền là 0
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Không thể thanh toán!')),
                        );
                      }
                    },
                    child: Text('THANH TOÁN (${cart.selectProductCount})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
