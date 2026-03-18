import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/product_detail',
            arguments: product.id,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Bo tròn các góc
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Màu sắc của bóng
                offset: Offset(0, 5), // Vị trí bóng (x, y)
                blurRadius: 5, // Độ mờ của bóng
                spreadRadius: 1, // Độ lan tỏa của bóng
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: Image.network(
                  product.imageURL1,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                // color: Colors.amber,
                height: 160,
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text.rich(
                                  TextSpan(
                                    text: '${product.title}',
                                    children: [
                                      TextSpan(text: '\n\n'),
                                    ],
                                  ),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  softWrap: true,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  context.read<ProductManager>().updateProduct(
                                      product.copyWith(
                                          isFavorite: !product.isFavorite));
                                },
                                icon: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color: Colors.red,
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${NumberFormat.decimalPattern().format(product.price)} VNĐ',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            for (int i = 0; i < 5; i++)
                              if (i < product.rate && (i + 1) <= product.rate)
                                const Icon(
                                  size: 20,
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              else if (i < product.rate &&
                                  (i + 1) > product.rate)
                                const Icon(
                                  size: 20,
                                  Icons.star_half_outlined,
                                  color: Colors.yellow,
                                )
                              else
                                const Icon(
                                  size: 20,
                                  Icons.star_outline,
                                  color: Colors.yellow,
                                ),
                          ],
                        ),
                        Text('${product.rate}/5')
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
