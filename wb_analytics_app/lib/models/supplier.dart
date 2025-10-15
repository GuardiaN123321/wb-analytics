import 'package:json_annotation/json_annotation.dart';

part 'supplier.g.dart';

@JsonSerializable()
class Supplier {
  final int id;
  final String name;
  final double? rating;            // Рейтинг продавца
  final int? totalProducts;        // Количество товаров
  final int? reviewsCount;         // Количество отзывов
  final String? description;       // Описание продавца
  final String? logo;              // Логотип
  final DateTime? registeredDate;  // Дата регистрации

  Supplier({
    required this.id,
    required this.name,
    this.rating,
    this.totalProducts,
    this.reviewsCount,
    this.description,
    this.logo,
    this.registeredDate,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}

