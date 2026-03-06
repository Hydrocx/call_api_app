class Product {
  final dynamic id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;
  final double rating;
  final double discountPercentage;
  final int stock;
  final String brand;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.rating,
    required this.discountPercentage,
    required this.stock,
    required this.brand,
  });

  /// Parse từ DummyJSON API
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnail: json['thumbnail'] as String,
      rating: (json['rating'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      stock: json['stock'] as int,
      brand: (json['brand'] ?? '') as String,
    );
  }

  /// Parse từ Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      title: data['title'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      thumbnail: data['thumbnail'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (data['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      brand: data['brand'] as String? ?? '',
    );
  }

  /// Chuyển thành Map để lưu lên Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'thumbnail': thumbnail,
      'rating': rating,
      'discountPercentage': discountPercentage,
      'stock': stock,
      'brand': brand,
    };
  }
}
