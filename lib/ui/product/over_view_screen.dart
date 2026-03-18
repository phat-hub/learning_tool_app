import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class OverViewScreen extends StatefulWidget {
  static const routeName = '/over_view';
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  int _selectIndex = 0;
  late Future<void> _fetchProducts;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _pages = [
    ProductGrid(false),
    ProductsFavoriteScreen(),
    OrdersScreen(),
    AuthInformationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductManager>().fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectIndex == 0
          ? AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  const SizedBox(width: 8),

                  /// SEARCH BOX
                  Expanded(
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              size: 20, color: Colors.grey),

                          const SizedBox(width: 8),

                          /// TEXTFIELD
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Tìm sản phẩm...',
                                border: InputBorder.none,
                                isCollapsed: true, // fix lệch
                              ),
                              onSubmitted: (value) {
                                context
                                    .read<ProductManager>()
                                    .setSearchQuery(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// CART
                  ShoppingCartButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart_screen');
                    },
                  ),
                ],
              ),
            )
          : null,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _searchController.clear();

          /// RESET SEARCH
          context.read<ProductManager>().setSearchQuery('');

          /// LOAD LẠI DATA
          await context.read<ProductManager>().fetchProduct();
        },
        color: Color(0xFFFFA52D),
        backgroundColor: Colors.white,
        child: FutureBuilder(
          future: _fetchProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _pages[_selectIndex];
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        selectedIndex: _selectIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Đơn hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tôi',
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
