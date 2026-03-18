import 'dart:io';

class Product {
  final String? id;
  final String title;
  final int price;
  final String description;

  final String imageURL1; // Đổi tên thành imageURL1
  final String imageURL2; // Thêm imageURL2
  final String imageURL3; // Thêm imageURL3
  final String imageURL4; // Thêm imageURL4

  final bool isFavorite;

  final File? featuredImage1; // Đổi tên thành featuredImage1
  final File? featuredImage2; // Thêm featuredImage2
  final File? featuredImage3; // Thêm featuredImage3
  final File? featuredImage4; // Thêm featuredImage4

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    this.imageURL1 = '', // Thêm giá trị mặc định cho các imageURL
    this.imageURL2 = '',
    this.imageURL3 = '',
    this.imageURL4 = '',
    this.isFavorite = false,
    this.featuredImage1,
    this.featuredImage2,
    this.featuredImage3,
    this.featuredImage4,
  });

  Product copyWith({
    String? id,
    String? title,
    int? price,
    String? description,
    String? imageURL1,
    String? imageURL2,
    String? imageURL3,
    String? imageURL4,
    bool? isFavorite,
    File? featuredImage1,
    File? featuredImage2,
    File? featuredImage3,
    File? featuredImage4,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      imageURL1: imageURL1 ?? this.imageURL1,
      imageURL2: imageURL2 ?? this.imageURL2,
      imageURL3: imageURL3 ?? this.imageURL3,
      imageURL4: imageURL4 ?? this.imageURL4,
      isFavorite: isFavorite ?? this.isFavorite,
      featuredImage1: featuredImage1 ?? this.featuredImage1,
      featuredImage2: featuredImage2 ?? this.featuredImage2,
      featuredImage3: featuredImage3 ?? this.featuredImage3,
      featuredImage4: featuredImage4 ?? this.featuredImage4,
    );
  }

  bool hasFeaturedImage1() {
    return featuredImage1 != null || imageURL1.isNotEmpty;
  }

  bool hasFeaturedImage2() {
    return featuredImage2 != null || imageURL2.isNotEmpty;
  }

  bool hasFeaturedImage3() {
    return featuredImage3 != null || imageURL3.isNotEmpty;
  }

  bool hasFeaturedImage4() {
    return featuredImage4 != null || imageURL4.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] ?? 0) as int,
      description: json['description'] ?? '',
      imageURL1: json['imageURL1'] ?? '',
      imageURL2: json['imageURL2'] ?? '',
      imageURL3: json['imageURL3'] ?? '',
      imageURL4: json['imageURL4'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
