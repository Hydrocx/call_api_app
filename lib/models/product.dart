class Product {
  final int id;
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
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
}
