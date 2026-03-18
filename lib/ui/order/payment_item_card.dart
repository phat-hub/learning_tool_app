import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screen.dart';

class PaymentItemCard extends StatelessWidget {
  final List<CartItem> cartItems;

  PaymentItemCard(this.cartItems);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Đảm bảo chiều cao của Column phù hợp với số lượng phần tử
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...cartItems.asMap().entries.map((entry) {
              var cartItem = entry.value;
              var index = entry.key;

              return Column(
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
                              softWrap: true, // Cho phép xuống dòng nếu tên dài
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Số lượng: x${cartItem.quantity}',
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
                  if (index != cartItems.length - 1) Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
