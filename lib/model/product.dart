import 'dart:io';

class Product {
  final String? id;
  final String title;
  final int price;
  final String imageURL1; // Đổi tên thành imageURL1
  final String imageURL2; // Thêm imageURL2
  final String imageURL3; // Thêm imageURL3
  final String imageURL4; // Thêm imageURL4
  final int ram;
  final int rom;
  final double rate;
  final bool isFavorite;
  final String type;
  final double screenSize;
  final String cpu;
  final String gpu;
  final int capacity;
  final String operatingSystem;
  final File? featuredImage1; // Đổi tên thành featuredImage1
  final File? featuredImage2; // Thêm featuredImage2
  final File? featuredImage3; // Thêm featuredImage3
  final File? featuredImage4; // Thêm featuredImage4

  Product({
    this.id,
    required this.title,
    required this.price,
    this.imageURL1 = '', // Thêm giá trị mặc định cho các imageURL
    this.imageURL2 = '',
    this.imageURL3 = '',
    this.imageURL4 = '',
    required this.ram,
    required this.rom,
    required this.rate,
    this.isFavorite = false,
    required this.type,
    required this.screenSize,
    required this.cpu,
    required this.gpu,
    required this.capacity,
    required this.operatingSystem,
    this.featuredImage1,
    this.featuredImage2,
    this.featuredImage3,
    this.featuredImage4,
  });

  Product copyWith({
    String? id,
    String? title,
    int? price,
    String? imageURL1,
    String? imageURL2,
    String? imageURL3,
    String? imageURL4,
    int? ram,
    int? rom,
    double? rate,
    bool? isFavorite,
    String? type,
    double? screenSize,
    String? cpu,
    String? gpu,
    int? capacity,
    String? operatingSystem,
    File? featuredImage1,
    File? featuredImage2,
    File? featuredImage3,
    File? featuredImage4,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageURL1: imageURL1 ?? this.imageURL1,
      imageURL2: imageURL2 ?? this.imageURL2,
      imageURL3: imageURL3 ?? this.imageURL3,
      imageURL4: imageURL4 ?? this.imageURL4,
      ram: ram ?? this.ram,
      rom: rom ?? this.rom,
      rate: rate ?? this.rate,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
      screenSize: screenSize ?? this.screenSize,
      cpu: cpu ?? this.cpu,
      gpu: gpu ?? this.gpu,
      capacity: capacity ?? this.capacity,
      operatingSystem: operatingSystem ?? this.operatingSystem,
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
      'ram': ram,
      'rom': rom,
      'rate': rate,
      'isFavorite': isFavorite,
      'type': type,
      'screenSize': screenSize,
      'cpu': cpu,
      'gpu': gpu,
      'capacity': capacity,
      'operatingSystem': operatingSystem,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] ?? 0) as int,
      ram: (json['ram'] ?? 0) as int,
      rom: (json['rom'] ?? 0) as int,
      rate: (json['rate'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      screenSize: (json['screenSize'] ?? 0).toDouble(),
      cpu: json['cpu'] ?? '',
      gpu: json['gpu'] ?? '',
      capacity: (json['capacity'] ?? 0) as int,
      operatingSystem: json['operatingSystem'] ?? '',
      imageURL1: json['imageURL1'] ?? '',
      imageURL2: json['imageURL2'] ?? '',
      imageURL3: json['imageURL3'] ?? '',
      imageURL4: json['imageURL4'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
