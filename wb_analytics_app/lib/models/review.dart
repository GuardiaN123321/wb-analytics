import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final String id;
  final String? userName;
  final int rating;               // Оценка (1-5)
  final String? text;             // Текст отзыва
  final String? pros;             // Плюсы
  final String? cons;             // Минусы
  final DateTime createdDate;     // Дата создания
  final List<String>? photos;     // Фото от покупателей
  final int? votesPlus;           // Лайки
  final int? votesMinus;          // Дизлайки
  final String? color;            // Цвет товара
  final String? size;             // Размер товара

  Review({
    required this.id,
    this.userName,
    required this.rating,
    this.text,
    this.pros,
    this.cons,
    required this.createdDate,
    this.photos,
    this.votesPlus,
    this.votesMinus,
    this.color,
    this.size,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class ReviewsResponse {
  final List<Review> reviews;
  final double averageRating;      // Средний рейтинг
  final int totalCount;            // Общее количество
  final Map<int, int>? ratingDistribution; // Распределение оценок (1-5)

  ReviewsResponse({
    required this.reviews,
    required this.averageRating,
    required this.totalCount,
    this.ratingDistribution,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) => _$ReviewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewsResponseToJson(this);
}

