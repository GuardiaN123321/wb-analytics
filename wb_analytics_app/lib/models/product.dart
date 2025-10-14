import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String article;
  final String name;
  final String brand;
  final String image;
  final double price;
  final int stock;
  final int reviews;
  final int addedAt;
  final int? lastUpdated;
  final Map<String, ProductHistory>? history;

  Product({
    required this.article,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.stock,
    required this.reviews,
    required this.addedAt,
    this.lastUpdated,
    this.history,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? article,
    String? name,
    String? brand,
    String? image,
    double? price,
    int? stock,
    int? reviews,
    int? addedAt,
    int? lastUpdated,
    Map<String, ProductHistory>? history,
  }) {
    return Product(
      article: article ?? this.article,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      reviews: reviews ?? this.reviews,
      addedAt: addedAt ?? this.addedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
    );
  }
}

@JsonSerializable()
class ProductHistory {
  final double price;
  final int stock;
  final int reviews;

  ProductHistory({
    required this.price,
    required this.stock,
    required this.reviews,
  });

  factory ProductHistory.fromJson(Map<String, dynamic> json) => _$ProductHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductHistoryToJson(this);
}

