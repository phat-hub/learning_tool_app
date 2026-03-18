import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductGrid(this.showFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductManager, List<Product>>(
        (productManager) =>
            showFavorite ? productManager.favoriteItems : productManager.items);
    // final products =
    //     showFavorite ? productManager.favoriteItems : productManager.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 4.2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
    );
  }
}
