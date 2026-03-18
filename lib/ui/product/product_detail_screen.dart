import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail';
  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  Text(
                    'Chi tiết sản phẩm',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  ShoppingCartButton(onPressed: () {
                    Navigator.of(context).pushNamed('/cart_screen');
                  }),
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Silder(widget: widget),
              Container(
                //color: Colors.blue,
                padding: EdgeInsets.only(left: 15, right: 5, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${NumberFormat.decimalPattern().format(widget.product.price)} VNĐ',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.yellow,
                              ),
                              Text('${widget.product.rate}/5'),
                              FavoriteButton(widget: widget),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.product.title}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        specifications(widget: widget),
                      ],
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            child: BottomPositionBar(widget: widget),
          )
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.widget,
  });

  final ProductDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ProductManager>().updateProduct(widget.product.copyWith(
            isFavorite: !context
                .read<ProductManager>()
                .isFavoriteById(widget.product.id!)));
      },
      icon: Icon(
        context.select<ProductManager, bool>((productManager) =>
                productManager.isFavoriteById(widget.product.id!))
            ? Icons.favorite
            : Icons.favorite_border,
      ),
      color: Colors.red,
      iconSize: 20,
    );
  }
}

class BottomPositionBar extends StatelessWidget {
  const BottomPositionBar({
    super.key,
    required this.widget,
  });

  final ProductDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.surfaceTint,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
                child: IconButton(
              onPressed: () {
                _showProductModal(context, widget.product);
              },
              icon: const Icon(Icons.add_shopping_cart_outlined),
              color: Theme.of(context).colorScheme.primary,
              iconSize: 30,
            )),
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
            flex: 4,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: Container(
                    child: ElevatedButton(
                  onPressed: () {
                    _showProductModal(context, widget.product,
                        isBuyingNow: true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'MUA NGAY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to show the product modal
  void _showProductModal(BuildContext context, Product product,
      {bool isBuyingNow = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ProductModal(
          product: product,
          isBuyingNow: isBuyingNow,
        );
      },
    );
  }
}

class ProductModal extends StatefulWidget {
  final Product product;
  final bool isBuyingNow;

  const ProductModal({
    Key? key,
    required this.product,
    required this.isBuyingNow,
  }) : super(key: key);

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  int _quantity = 1; // Initial quantity

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.product.imageURL1,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              // Product Info (Name and Price)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${NumberFormat.decimalPattern().format(widget.product.price)} VNĐ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Số lượng:"),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
              ),
              Text('$_quantity'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),

          // Add to cart or Buy now button with styling for small screens
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add the product to cart
                  if (!widget.isBuyingNow) {
                    context
                        .read<CartManager>()
                        .addCartItem(widget.product, _quantity);
                    showErrorDialog(
                      context,
                      'Sản phẩm đã được thêm vào giỏ hàng!',
                    );
                  } else {
                    final cartItem = CartItem(
                        title: widget.product.title,
                        imageUrl: widget.product.imageURL1,
                        quantity: _quantity,
                        price: widget.product.price,
                        productId: widget.product.id!);
                    Navigator.of(context).pushNamed(
                      '/payment',
                      arguments: cartItem,
                    );
                  }
                },
                child: Text(
                  widget.isBuyingNow ? 'Mua ngay' : 'Thêm vào giỏ hàng',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isBuyingNow
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('add product to shopping cart');
      },
      child: Text(
        'MUA NGAY',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class specifications extends StatelessWidget {
  const specifications({
    super.key,
    required this.widget,
  });

  final ProductDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 0.5,
          )),
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                child: Container(
                  child: Table(
                    //border: TableBorder.all(),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceTint,
                        ),
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('RAM:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.ram} GB'),
                          ),
                        ],
                      ),
                      //SizedBox(height: 10),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('ROM:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.rom} GB'),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceTint,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('Loại: '),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.type}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('Kích thước màn hình: '),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.screenSize} "'),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceTint,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('CPU: '),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.cpu}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('GPU: '),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.gpu}'),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceTint,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('Dung lượng pin:'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.capacity} mAh'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('Hệ điều hành: '),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${widget.product.operatingSystem}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Silder extends StatelessWidget {
  const Silder({
    super.key,
    required this.widget,
  });

  final ProductDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(top: 20),
      child: PageView(
        children: [
          Container(
            child: Image.network('${widget.product.imageURL1}'),
          ),
          Container(
            child: Image.network('${widget.product.imageURL2}'),
          ),
          Container(
            child: Image.network('${widget.product.imageURL3}'),
          ),
          Container(
            child: Image.network('${widget.product.imageURL4}'),
          ),
        ],
      ),
    );
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.shopping_cart,
        size: 30,
      ),
      onPressed: onPressed,
    );
  }
}
