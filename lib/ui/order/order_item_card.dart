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
    return buildCard(context);
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Widget buildCard(BuildContext context) {
    final user = context.watch<AuthManager>().getUserDetails();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng tiền: ${NumberFormat.decimalPattern().format(widget.order.amount)} VND',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),

                  const SizedBox(height: 5),

                  /// ⭐ STATUS
                  Text(
                    _getStatusText(widget.order.status),
                    style: TextStyle(
                      color: _getStatusColor(widget.order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// 👤 USER - HỦY ĐƠN
            if (user['role'] != 'admin' && widget.order.status == 'pending')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context
                        .read<OrdersManager>()
                        .updateStatus(widget.order.id!, 'cancelled');
                  },
                  child: const Text(
                    'Hủy đơn',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

            /// 👨‍💼 ADMIN - XÁC NHẬN
            if (user['role'] == 'admin' && widget.order.status == 'pending')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<OrdersManager>()
                        .updateStatus(widget.order.id!, 'confirmed');
                  },
                  child: const Text('Xác nhận'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
