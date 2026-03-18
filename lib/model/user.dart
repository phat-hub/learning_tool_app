import 'dart:io';

class User {
  final String? id;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String? avatarUrl;
  final String? role;
  final File? avatar;

  User(
      {this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.address,
      String? avatarUrl,
      this.role,
      this.avatar})
      : avatarUrl = avatarUrl ??
            'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg';

  User copyWith(
      {String? id,
      String? name,
      String? phoneNumber,
      String? email,
      String? address,
      String? avatarUrl,
      String? role,
      File? avatar}) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        address: address ?? this.address,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        role: role ?? this.role,
        avatar: avatar ?? this.avatar);
  }

  bool hasAvatarImage() {
    return avatar != null || avatarUrl!.isNotEmpty;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        address: json['address'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        role: json['role'] ?? 'user');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'role': role
    };
  }
}
