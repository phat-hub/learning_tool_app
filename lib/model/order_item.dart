import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> items;
  final DateTime dateTime;
  final String name;
  final String phoneNumber;
  final String address;
  final String status;

  int get productCount {
    return items.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.items,
    DateTime? dateTime,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.status = 'pending',
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    double? amount,
    List<CartItem>? items,
    DateTime? dateTime,
    String? name,
    String? phoneNumber,
    String? address,
    String? status,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      items: items ?? this.items,
      dateTime: dateTime ?? this.dateTime,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'items': items.map((cartItem) => cartItem.toJson()).toList(),
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'status': status,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      amount: json['amount'].toDouble() ?? 0.0,
      dateTime: DateTime.parse(json['dateTime']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
