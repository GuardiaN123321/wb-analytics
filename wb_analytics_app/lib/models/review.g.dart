// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  id: json['id'] as String,
  userName: json['userName'] as String?,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String?,
  pros: json['pros'] as String?,
  cons: json['cons'] as String?,
  createdDate: DateTime.parse(json['createdDate'] as String),
  photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  votesPlus: (json['votesPlus'] as num?)?.toInt(),
  votesMinus: (json['votesMinus'] as num?)?.toInt(),
  color: json['color'] as String?,
  size: json['size'] as String?,
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'rating': instance.rating,
  'text': instance.text,
  'pros': instance.pros,
  'cons': instance.cons,
  'createdDate': instance.createdDate.toIso8601String(),
  'photos': instance.photos,
  'votesPlus': instance.votesPlus,
  'votesMinus': instance.votesMinus,
  'color': instance.color,
  'size': instance.size,
};

ReviewsResponse _$ReviewsResponseFromJson(Map<String, dynamic> json) =>
    ReviewsResponse(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalCount: (json['totalCount'] as num).toInt(),
      ratingDistribution: (json['ratingDistribution'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(int.parse(k), (e as num).toInt())),
    );

Map<String, dynamic> _$ReviewsResponseToJson(ReviewsResponse instance) =>
    <String, dynamic>{
      'reviews': instance.reviews,
      'averageRating': instance.averageRating,
      'totalCount': instance.totalCount,
      'ratingDistribution': instance.ratingDistribution?.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
    };
