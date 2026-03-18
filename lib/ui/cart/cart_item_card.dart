import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard(this.cartItem, {super.key});

  final CartItem cartItem;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    int counter = widget.cartItem.quantity;
    bool _checkBox = widget.cartItem.select;

    return Dismissible(
      key: ValueKey(widget.cartItem.id),
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
          'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?',
        );
      },
      onDismissed: (direction) {
        context.read<CartManager>().clearItem(widget.cartItem.id!);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: _checkBox,
              onChanged: (newValue) {
                setState(() {
                  _checkBox = newValue!;
                  widget.cartItem.select = _checkBox;
                  context.read<CartManager>().updateSelectCartItems(
                      context
                          .read<ProductManager>()
                          .findById(widget.cartItem.productId)!,
                      _checkBox);
                });
              },
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 80,
                height: 80,
                child: Image.network(
                  widget.cartItem.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, top: 8, bottom: 5, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cartItem.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${NumberFormat.decimalPattern().format(widget.cartItem.price)} VNĐ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (counter > 1) {
                                  counter--;
                                  widget.cartItem.quantity = counter;
                                  // Cập nhật giỏ hàng trong CartManager
                                  context.read<CartManager>().addCartItem(
                                      context
                                          .read<ProductManager>()
                                          .findById(widget.cartItem.productId)!,
                                      1,
                                      add: false);
                                }
                              });
                            },
                            icon: Icon(Icons.remove),
                            iconSize: 15,
                          ),
                          Text(
                            counter.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                counter++;
                                widget.cartItem.quantity = counter;
                                // Cập nhật giỏ hàng trong CartManager
                                context.read<CartManager>().addCartItem(
                                    context
                                        .read<ProductManager>()
                                        .findById(widget.cartItem.productId)!,
                                    1);
                              });
                            },
                            icon: Icon(Icons.add),
                            iconSize: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
