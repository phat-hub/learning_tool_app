class Favorite {
  final String id;
  final String userId;
  final String productId;

  Favorite({
    required this.id,
    required this.userId,
    required this.productId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      userId: json['user'],
      productId: json['product'],
    );
  }
}
