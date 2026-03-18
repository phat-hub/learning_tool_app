import 'package:flutter/material.dart';

import '../screen.dart';

class ProductsFavoriteScreen extends StatefulWidget {
  static const routeName = '/product_favorite';
  const ProductsFavoriteScreen({super.key});

  @override
  State<ProductsFavoriteScreen> createState() => _ProductsFavoriteScreenState();
}

class _ProductsFavoriteScreenState extends State<ProductsFavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản Phẩm Yêu Thích'),
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(true),
    );
  }
}
