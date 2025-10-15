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
  
  // Новые поля
  final double? rating;              // Рейтинг товара (0-5)
  final double? originalPrice;       // Цена без скидки
  final int? discount;               // Процент скидки
  final String? description;         // Описание товара
  final List<String>? images;        // Все фотографии
  final String? supplier;            // Название продавца
  final int? supplierId;             // ID продавца
  final double? supplierRating;      // Рейтинг продавца
  final String? category;            // Категория товара
  final int? categoryId;             // ID категории
  final List<String>? colors;        // Доступные цвета
  final List<String>? sizes;         // Доступные размеры
  final Map<String, dynamic>? characteristics; // Характеристики
  final double? purchasePrice;       // Покупная цена для расчета прибыли

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
    this.rating,
    this.originalPrice,
    this.discount,
    this.description,
    this.images,
    this.supplier,
    this.supplierId,
    this.supplierRating,
    this.category,
    this.categoryId,
    this.colors,
    this.sizes,
    this.characteristics,
    this.purchasePrice,
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
    double? rating,
    double? originalPrice,
    int? discount,
    String? description,
    List<String>? images,
    String? supplier,
    int? supplierId,
    double? supplierRating,
    String? category,
    int? categoryId,
    List<String>? colors,
    List<String>? sizes,
    Map<String, dynamic>? characteristics,
    double? purchasePrice,
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
      rating: rating ?? this.rating,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      images: images ?? this.images,
      supplier: supplier ?? this.supplier,
      supplierId: supplierId ?? this.supplierId,
      supplierRating: supplierRating ?? this.supplierRating,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      characteristics: characteristics ?? this.characteristics,
      purchasePrice: purchasePrice ?? this.purchasePrice,
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

