import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen.dart';

class AuthInformationScreen extends StatelessWidget {
  static const routeName = '/auth_information';

  const AuthInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng từ AuthManager
    final authManager = Provider.of<AuthManager>(context);
    // Kiểm tra trạng thái đăng nhập của người dùng
    if (authManager.isAuth) {
      // Nếu đã đăng nhập, lấy thông tin người dùng
      final user = authManager.getUserDetails();
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thông tin tài khoản',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/edit_auth',
                  arguments: user,
                );
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildAvatar(user),
              const SizedBox(height: 20),
              _buildInfoTile('Số điện thoại', user['phoneNumber']),
              _buildInfoTile('Email', user['email']),
              _buildInfoTile('Địa chỉ', user['address']),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child:
            CircularProgressIndicator(), // Hiển thị indicator trong khi đang chuyển hướng
      );
    }
  }

  Widget _buildAvatar(Map<String, dynamic> user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(user['avatarUrl']!),
        ),
        const SizedBox(height: 20),
        Text(
          user['name'],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
