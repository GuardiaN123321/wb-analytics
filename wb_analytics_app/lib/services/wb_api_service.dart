import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class WbApiService {
  /// Генерация URL для изображения товара
  static String makeProductImageUrl(String productId, {int imageNumber = 1}) {
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

    return 'https://basket-$host.wbbasket.ru/vol$vol/part$part/$nm/images/big/$imageNumber.webp';
  }

  /// Генерация списка URL изображений товара (обычно 1-10 изображений)
  static List<String> makeProductImageUrls(String productId, {int count = 10}) {
    final images = <String>[];
    for (int i = 1; i <= count; i++) {
      images.add(makeProductImageUrl(productId, imageNumber: i));
    }
    return images;
  }

  /// Получение информации о товаре по артикулу
  Future<Product?> fetchProductInfo(String articleId, {double? purchasePrice}) async {
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
          // Новые поля
          rating: _extractRating(productData),
          originalPrice: _extractOriginalPrice(productData),
          discount: _calculateDiscount(productData),
          description: productData['description'] as String?,
          images: _extractAllImages(articleId, productData),
          supplier: productData['supplier'] as String?,
          supplierId: productData['supplierId'] as int?,
          supplierRating: _extractSupplierRating(productData),
          category: productData['subjectName'] as String?,
          categoryId: productData['subjectId'] as int?,
          colors: _extractColors(productData),
          sizes: _extractSizes(productData),
          characteristics: _extractCharacteristics(productData),
          purchasePrice: purchasePrice,
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

  /// Извлечение рейтинга товара
  double? _extractRating(Map<String, dynamic> productData) {
    try {
      if (productData['reviewRating'] != null) {
        return (productData['reviewRating'] as num).toDouble();
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения рейтинга: $e');
      return null;
    }
  }

  /// Извлечение оригинальной цены (без скидки)
  double? _extractOriginalPrice(Map<String, dynamic> productData) {
    try {
      if (productData['sizes'] != null && 
          (productData['sizes'] as List).isNotEmpty) {
        final firstSize = productData['sizes'][0];
        if (firstSize['price'] != null) {
          final priceU = firstSize['price']['basic'] ?? firstSize['price']['total'];
          if (priceU != null) {
            return (priceU as num) / 100.0;
          }
        }
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения оригинальной цены: $e');
      return null;
    }
  }

  /// Расчет скидки в процентах
  int? _calculateDiscount(Map<String, dynamic> productData) {
    try {
      final originalPrice = _extractOriginalPrice(productData);
      final currentPrice = _extractPrice(productData);
      
      if (originalPrice != null && currentPrice > 0 && originalPrice > currentPrice) {
        return ((1 - currentPrice / originalPrice) * 100).round();
      }
      return null;
    } catch (e) {
      print('Ошибка расчета скидки: $e');
      return null;
    }
  }

  /// Извлечение всех изображений товара
  List<String> _extractAllImages(String articleId, Map<String, dynamic> productData) {
    try {
      final nm = int.parse(articleId);
      final vol = nm ~/ 100000;
      final part = nm ~/ 1000;
      String host = _getImageHost(vol);
      
      // Получаем реальное количество фото из API
      int photoCount = productData['pics'] ?? 1;
      if (photoCount > 20) photoCount = 20; // Ограничиваем максимум
      if (photoCount < 1) photoCount = 1;
      
      List<String> images = [];
      // Генерируем только реальное количество изображений
      for (int i = 1; i <= photoCount; i++) {
        images.add('https://basket-$host.wbbasket.ru/vol$vol/part$part/$nm/images/big/$i.webp');
      }
      return images;
    } catch (e) {
      print('Ошибка извлечения изображений: $e');
      return [makeProductImageUrl(articleId)];
    }
  }

  /// Получение хоста для изображения
  String _getImageHost(int vol) {
    if (vol >= 0 && vol <= 143) return '01';
    if (vol >= 144 && vol <= 287) return '02';
    if (vol >= 288 && vol <= 431) return '03';
    if (vol >= 432 && vol <= 719) return '04';
    if (vol >= 720 && vol <= 1007) return '05';
    if (vol >= 1008 && vol <= 1061) return '06';
    if (vol >= 1062 && vol <= 1115) return '07';
    if (vol >= 1116 && vol <= 1169) return '08';
    if (vol >= 1170 && vol <= 1313) return '09';
    if (vol >= 1314 && vol <= 1601) return '10';
    if (vol >= 1602 && vol <= 1655) return '11';
    if (vol >= 1656 && vol <= 1919) return '12';
    if (vol >= 1920 && vol <= 2045) return '13';
    if (vol >= 2046 && vol <= 2189) return '14';
    if (vol >= 2190 && vol <= 2405) return '15';
    if (vol >= 2406 && vol <= 2621) return '16';
    if (vol >= 2622 && vol <= 2837) return '17';
    if (vol >= 2838 && vol <= 3053) return '18';
    if (vol >= 3054 && vol <= 3269) return '19';
    if (vol >= 3270 && vol <= 3485) return '20';
    return '21';
  }

  /// Извлечение рейтинга продавца
  double? _extractSupplierRating(Map<String, dynamic> productData) {
    try {
      if (productData['supplierRating'] != null) {
        return (productData['supplierRating'] as num).toDouble();
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения рейтинга продавца: $e');
      return null;
    }
  }

  /// Извлечение доступных цветов
  List<String>? _extractColors(Map<String, dynamic> productData) {
    try {
      if (productData['colors'] != null && productData['colors'] is List) {
        return (productData['colors'] as List)
            .map((color) => color['name'] as String)
            .toList();
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения цветов: $e');
      return null;
    }
  }

  /// Извлечение доступных размеров
  List<String>? _extractSizes(Map<String, dynamic> productData) {
    try {
      if (productData['sizes'] != null && productData['sizes'] is List) {
        return (productData['sizes'] as List)
            .where((size) => size['name'] != null)
            .map((size) => size['name'] as String)
            .toSet()
            .toList();
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения размеров: $e');
      return null;
    }
  }

  /// Извлечение характеристик товара
  Map<String, dynamic>? _extractCharacteristics(Map<String, dynamic> productData) {
    try {
      if (productData['options'] != null && productData['options'] is List) {
        Map<String, dynamic> characteristics = {};
        for (var option in productData['options']) {
          if (option['name'] != null && option['value'] != null) {
            characteristics[option['name']] = option['value'];
          }
        }
        return characteristics.isNotEmpty ? characteristics : null;
      }
      return null;
    } catch (e) {
      print('Ошибка извлечения характеристик: $e');
      return null;
    }
  }
}

