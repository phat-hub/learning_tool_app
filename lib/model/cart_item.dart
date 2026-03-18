class CartItem {
  final String? id;
  final String title;
  final String imageUrl;
  int quantity;
  final int price;
  bool select;
  String productId;

  CartItem({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    this.select = true,
    required this.productId,
  });

  CartItem copyWith({
    String? id,
    String? title,
    String? imageUrl,
    int? quantity,
    int? price,
    bool? select,
    String? productId,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      select: select ?? this.select,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
      'select': select,
      'productId': productId,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0,
      select: json['select'] ?? false,
      productId: json['idProduct'] ?? '',
    );
  }
}
