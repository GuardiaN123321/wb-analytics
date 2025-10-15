// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  article: json['article'] as String,
  name: json['name'] as String,
  brand: json['brand'] as String,
  image: json['image'] as String,
  price: (json['price'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  reviews: (json['reviews'] as num).toInt(),
  addedAt: (json['addedAt'] as num).toInt(),
  lastUpdated: (json['lastUpdated'] as num?)?.toInt(),
  history: (json['history'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, ProductHistory.fromJson(e as Map<String, dynamic>)),
  ),
  rating: (json['rating'] as num?)?.toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  discount: (json['discount'] as num?)?.toInt(),
  description: json['description'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  supplier: json['supplier'] as String?,
  supplierId: (json['supplierId'] as num?)?.toInt(),
  supplierRating: (json['supplierRating'] as num?)?.toDouble(),
  category: json['category'] as String?,
  categoryId: (json['categoryId'] as num?)?.toInt(),
  colors: (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  sizes: (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  characteristics: json['characteristics'] as Map<String, dynamic>?,
  purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'article': instance.article,
  'name': instance.name,
  'brand': instance.brand,
  'image': instance.image,
  'price': instance.price,
  'stock': instance.stock,
  'reviews': instance.reviews,
  'addedAt': instance.addedAt,
  'lastUpdated': instance.lastUpdated,
  'history': instance.history,
  'rating': instance.rating,
  'originalPrice': instance.originalPrice,
  'discount': instance.discount,
  'description': instance.description,
  'images': instance.images,
  'supplier': instance.supplier,
  'supplierId': instance.supplierId,
  'supplierRating': instance.supplierRating,
  'category': instance.category,
  'categoryId': instance.categoryId,
  'colors': instance.colors,
  'sizes': instance.sizes,
  'characteristics': instance.characteristics,
  'purchasePrice': instance.purchasePrice,
};

ProductHistory _$ProductHistoryFromJson(Map<String, dynamic> json) =>
    ProductHistory(
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      reviews: (json['reviews'] as num).toInt(),
    );

Map<String, dynamic> _$ProductHistoryToJson(ProductHistory instance) =>
    <String, dynamic>{
      'price': instance.price,
      'stock': instance.stock,
      'reviews': instance.reviews,
    };
