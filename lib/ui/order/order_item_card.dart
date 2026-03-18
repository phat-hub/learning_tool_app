import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  OrderItemCard(this.order);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context);
    final user = authManager.getUserDetails();

    return user['role'] == 'admin'
        ? Dismissible(
            key: ValueKey(widget.order.id),
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showConfirmDialog(
                context,
                'Bạn có chắc chắn muốn xóa đơn hàng này không?',
              );
            },
            onDismissed: (direction) {
              context.read<OrdersManager>().clearItem(widget.order.id!);
            },
            child: buildCard(context),
          )
        : buildCard(
            context); // Nếu không phải admin, chỉ trả về Card bình thường
  }

  Widget buildCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...widget.order.items.map((cartItem) => Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            cartItem.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap:
                                    true, // Cho phép xuống dòng nếu tên dài
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Họ và tên: ${widget.order.name}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Số điện thoại: ${widget.order.phoneNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Địa chỉ: ${widget.order.address}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy, HH:mm')
                                        .format(widget.order.dateTime),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'x${cartItem.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '${NumberFormat.decimalPattern().format(cartItem.price)} VND',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                )),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Tổng tiền: ${NumberFormat.decimalPattern().format(widget.order.amount)} VND',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
