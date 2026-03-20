import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context);
    if (authManager.isAuth) {
      final user = authManager.getUserDetails();
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user['avatarUrl'])),
                  SizedBox(height: 10),
                  Text(
                    user['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user['email'],
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/over_view');
              },
            ),
            if (user['role'] == 'admin')
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Doanh thu'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/revenue');
                },
              ),
            if (user['role'] == 'admin')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Quản lý sản phẩm'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/user_products');
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacementNamed('/');
                context.read<AuthManager>().logout();
              },
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
