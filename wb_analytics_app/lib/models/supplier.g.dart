// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  rating: (json['rating'] as num?)?.toDouble(),
  totalProducts: (json['totalProducts'] as num?)?.toInt(),
  reviewsCount: (json['reviewsCount'] as num?)?.toInt(),
  description: json['description'] as String?,
  logo: json['logo'] as String?,
  registeredDate: json['registeredDate'] == null
      ? null
      : DateTime.parse(json['registeredDate'] as String),
);

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'rating': instance.rating,
  'totalProducts': instance.totalProducts,
  'reviewsCount': instance.reviewsCount,
  'description': instance.description,
  'logo': instance.logo,
  'registeredDate': instance.registeredDate?.toIso8601String(),
};
