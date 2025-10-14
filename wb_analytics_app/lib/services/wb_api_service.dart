import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class WbApiService {
  /// Генерация URL для изображения товара
  static String makeProductImageUrl(String productId) {
    final nm = int.parse(productId);
    final vol = nm ~/ 100000;
    final part = nm ~/ 1000;
    String host = '';

    if (vol >= 0 && vol <= 143) {
      host = '01';
    } else if (vol >= 144 && vol <= 287) {
      host = '02';
    } else if (vol >= 288 && vol <= 431) {
      host = '03';
    } else if (vol >= 432 && vol <= 719) {
      host = '04';
    } else if (vol >= 720 && vol <= 1007) {
      host = '05';
    } else if (vol >= 1008 && vol <= 1061) {
      host = '06';
    } else if (vol >= 1062 && vol <= 1115) {
      host = '07';
    } else if (vol >= 1116 && vol <= 1169) {
      host = '08';
    } else if (vol >= 1170 && vol <= 1313) {
      host = '09';
    } else if (vol >= 1314 && vol <= 1601) {
      host = '10';
    } else if (vol >= 1602 && vol <= 1655) {
      host = '11';
    } else if (vol >= 1656 && vol <= 1919) {
      host = '12';
    } else if (vol >= 1920 && vol <= 2045) {
      host = '13';
    } else if (vol >= 2046 && vol <= 2189) {
      host = '14';
    } else if (vol >= 2190 && vol <= 2405) {
      host = '15';
    } else if (vol >= 2406 && vol <= 2621) {
      host = '16';
    } else if (vol >= 2622 && vol <= 2837) {
      host = '17';
    } else if (vol >= 2838 && vol <= 3053) {
      host = '18';
    } else if (vol >= 3054 && vol <= 3269) {
      host = '19';
    } else if (vol >= 3270 && vol <= 3485) {
      host = '20';
    } else {
      host = '21';
    }

    return 'https://basket-$host.wbbasket.ru/vol$vol/part$part/$nm/images/big/1.webp';
  }

  /// Получение информации о товаре по артикулу
  Future<Product?> fetchProductInfo(String articleId) async {
    try {
      final imageUrl = makeProductImageUrl(articleId);
      
      // Используем актуальный API v2
      final apiUrl = 'https://card.wb.ru/cards/v2/detail?appType=128&curr=rub&dest=-1257786&spp=30&nm=$articleId';
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15',
        },
      );

      if (response.statusCode != 200) {
        print('Ошибка HTTP: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body);
      print('Ответ API: $data');

      // API v2 возвращает данные в формате data.products[]
      if (data != null && 
          data['data'] != null && 
          data['data']['products'] != null && 
          (data['data']['products'] as List).isNotEmpty) {
        
        final productData = data['data']['products'][0];
        
        return Product(
          article: articleId,
          name: productData['name'] ?? '',
          brand: productData['brand'] ?? '',
          image: imageUrl,
          price: _extractPrice(productData),
          stock: _calculateTotalStock(productData['sizes']),
          reviews: productData['feedbacks'] ?? 0,
          addedAt: DateTime.now().millisecondsSinceEpoch,
        );
      }

      return null;
    } catch (e) {
      print('Ошибка при получении информации о товаре: $e');
      return null;
    }
  }

  /// Извлечение цены из данных
  double _extractPrice(Map<String, dynamic> productData) {
    try {
      // В API v2 цена находится в sizes[0].price.product
      if (productData['sizes'] != null && 
          (productData['sizes'] as List).isNotEmpty) {
        final firstSize = productData['sizes'][0];
        if (firstSize['price'] != null && firstSize['price']['product'] != null) {
          return (firstSize['price']['product'] as num) / 100.0;
        }
      }
      return 0.0;
    } catch (e) {
      print('Ошибка извлечения цены: $e');
      return 0.0;
    }
  }

  /// Расчет общего количества товара
  int _calculateTotalStock(dynamic sizes) {
    if (sizes == null || sizes is! List) return 0;

    int total = 0;
    for (var size in sizes) {
      if (size['stocks'] != null && size['stocks'] is List) {
        for (var stock in size['stocks']) {
          total += (stock['qty'] ?? 0) as int;
        }
      }
    }

    return total;
  }
}

