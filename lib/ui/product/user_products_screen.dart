import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user_products';
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  late Future<void> _fetchUserProducts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserProducts = context.read<ProductManager>().fetchUserProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm của bạn'),
        actions: [
          // DeleteUserProductButton(
          //   onPressed: () {},
          // ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchUserProducts,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProductManager>().fetchUserProduct(),
            child: const UserProductsList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).pushNamed('/edit_product');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class UserProductsList extends StatelessWidget {
  const UserProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductManager>(builder: (ctx, productManager, child) {
      return ListView.builder(
        itemCount: productManager.itemCount,
        itemBuilder: (ctx, i) => Column(
          children: [
            UserProudctTile(
              productManager.items[i],
            ),
          ],
        ),
      );
    });
  }
}

// class DeleteUserProductButton extends StatelessWidget {
//   const DeleteUserProductButton({
//     super.key,
//     this.onPressed,
//   });

//   final void Function()? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: onPressed,
//       icon: Icon(Icons.delete),
//     );
//   }
// }
