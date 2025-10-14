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
