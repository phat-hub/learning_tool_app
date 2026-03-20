import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductGrid(this.showFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    final productManager = context.watch<ProductManager>();

    final products =
        showFavorite ? productManager.favoriteItems : productManager.items;
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Không có sản phẩm phù hợp',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
    );
  }
}
