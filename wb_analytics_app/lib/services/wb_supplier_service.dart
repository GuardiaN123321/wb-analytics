import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/supplier.dart';

class WbSupplierService {
  /// Получение информации о продавце
  Future<Supplier?> fetchSupplierInfo(int supplierId) async {
    try {
      // Используем публичный API для получения информации о продавце
      final apiUrl = 'https://seller-ratings.wildberries.ru/api/v1/suppliers/$supplierId';
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15',
        },
      );

      if (response.statusCode != 200) {
        print('Ошибка HTTP при получении информации о продавце: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body);
      
      if (data != null) {
        return Supplier(
          id: supplierId,
          name: data['name'] ?? 'Неизвестный продавец',
          rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
          totalProducts: data['productsCount'] as int?,
          reviewsCount: data['reviewsCount'] as int?,
          description: data['description'] as String?,
          logo: data['logo'] as String?,
          registeredDate: data['registeredDate'] != null 
              ? DateTime.parse(data['registeredDate']) 
              : null,
        );
      }

      return null;
    } catch (e) {
      print('Ошибка при получении информации о продавце: $e');
      // Возвращаем базовую информацию, если API недоступен
      return Supplier(
        id: supplierId,
        name: 'Продавец #$supplierId',
      );
    }
  }

  /// Получение товаров продавца
  Future<List<Map<String, dynamic>>?> fetchSupplierProducts(int supplierId, {int page = 1, int limit = 100}) async {
    try {
      final apiUrl = 'https://catalog.wb.ru/sellers/catalog?appType=1&curr=rub&dest=-1257786&regions=80,38,83,4,64,33,68,70,30,40,86,75,69,22,1,31,66,110,48,71,114&sort=popular&supplier=$supplierId&page=$page&limit=$limit';
      
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
      
      if (data != null && data['data'] != null && data['data']['products'] != null) {
        return List<Map<String, dynamic>>.from(data['data']['products']);
      }

      return null;
    } catch (e) {
      print('Ошибка при получении товаров продавца: $e');
      return null;
    }
  }
}

