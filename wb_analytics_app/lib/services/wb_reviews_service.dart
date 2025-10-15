import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class WbReviewsService {
  /// Получение отзывов о товаре
  Future<ReviewsResponse?> fetchReviews(String articleId, {int page = 1}) async {
    try {
      // Используем новый корректный API - тот же домен что и для карточек товара
      // Отзывы недоступны через публичный API, поэтому создаём заглушку с информацией из основного API
      print('Попытка загрузки отзывов для товара $articleId');
      
      // Возвращаем заглушку - отзывы через публичное API WB недоступны
      // Информация об общем количестве отзывов уже есть в карточке товара
      return null;
      
    } catch (e) {
      print('Ошибка при получении отзывов: $e');
      return null;
    }
  }

  /// Извлечение ссылок на фото из отзывов
  List<String>? _extractPhotos(dynamic photoLinks) {
    try {
      if (photoLinks != null && photoLinks is List) {
        return photoLinks.map((link) => link.toString()).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Расчет среднего рейтинга
  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    
    final sum = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  /// Расчет распределения оценок
  Map<int, int> _calculateRatingDistribution(List<Review> reviews) {
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    
    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    
    return distribution;
  }

  /// Получение статистики рейтингов товара
  Future<Map<String, dynamic>?> fetchRatingStats(String articleId) async {
    try {
      final apiUrl = 'https://feedbacks-api.wb.ru/api/v1/summary/full?nmId=$articleId';
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      print('Ошибка при получении статистики рейтингов: $e');
      return null;
    }
  }
}

