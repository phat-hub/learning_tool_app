import 'package:flutter/material.dart';

import '../screen.dart';

class AuthManager with ChangeNotifier {
  late final AuthService _authService;
  User? _loggedInUser;

  AuthManager() {
    _authService = AuthService(onAuthChange: (User? user) {
      _loggedInUser = user;
      notifyListeners();
    });
  }

  bool get isAuth {
    return _loggedInUser != null;
  }

  Future<User> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<User> signup(String name, String email, String phoneNumber,
      String password, String address) async {
    return _authService.signup(name, email, phoneNumber, password, address);
  }

  Future<void> logout() async {
    return _authService.logout();
  }

  Future<void> tryAutoLogin() async {
    final user = await _authService.getUserFromStore();
    if (_loggedInUser != null) {
      _loggedInUser = user;
      notifyListeners();
    }
  }

  // Hàm lấy thông tin người dùng đã đăng nhập
  Map<String, dynamic> getUserDetails() {
    if (_loggedInUser != null) {
      return {
        'id': _loggedInUser!.id,
        'name': _loggedInUser!.name,
        'phoneNumber': _loggedInUser!.phoneNumber,
        'address': _loggedInUser!.address,
        'role': _loggedInUser!.role,
        'avatarUrl': _loggedInUser!.avatarUrl,
        'email': _loggedInUser!.email,
      };
    } else
      return {};
  }

  Future<User> updateUser(User user, String id, String phoneNumber) async {
    final updatedUser = await _authService.updateUser(user, id, phoneNumber);
    _loggedInUser = updatedUser;
    notifyListeners();
    return updatedUser;
  }

  // Hàm lấy thông tin người dùng từ Map
  User getUserFromMap(Map<String, dynamic> userMap) {
    return User(
      id: userMap['id'],
      name: userMap['name'],
      phoneNumber: userMap['phoneNumber'],
      address: userMap['address'],
      role: userMap['role'],
      avatarUrl: userMap['avatarUrl'],
      email: userMap['email'],
    );
  }
}
