import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class StorageService {
  static const String _productsKey = 'wb_products';

  /// Сохранение списка товаров
  Future<void> saveProducts(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = products.map((p) => p.toJson()).toList();
      await prefs.setString(_productsKey, json.encode(productsJson));
    } catch (e) {
      print('Ошибка при сохранении товаров: $e');
      rethrow;
    }
  }

  /// Получение списка товаров
  Future<List<Product>> getProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsString = prefs.getString(_productsKey);
      
      if (productsString == null || productsString.isEmpty) {
        return [];
      }

      final List<dynamic> productsJson = json.decode(productsString);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Ошибка при получении товаров: $e');
      return [];
    }
  }

  /// Добавление товара
  Future<void> addProduct(Product product) async {
    try {
      final products = await getProducts();
      products.add(product);
      await saveProducts(products);
    } catch (e) {
      print('Ошибка при добавлении товара: $e');
      rethrow;
    }
  }

  /// Удаление товара по артикулу
  Future<void> removeProduct(String articleId) async {
    try {
      final products = await getProducts();
      products.removeWhere((p) => p.article == articleId);
      await saveProducts(products);
    } catch (e) {
      print('Ошибка при удалении товара: $e');
      rethrow;
    }
  }

  /// Обновление товара
  Future<void> updateProduct(Product product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((p) => p.article == product.article);
      
      if (index != -1) {
        products[index] = product;
        await saveProducts(products);
      }
    } catch (e) {
      print('Ошибка при обновлении товара: $e');
      rethrow;
    }
  }

  /// Проверка существования товара
  Future<bool> productExists(String articleId) async {
    try {
      final products = await getProducts();
      return products.any((p) => p.article == articleId);
    } catch (e) {
      print('Ошибка при проверке существования товара: $e');
      return false;
    }
  }

  /// Очистка всех данных
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_productsKey);
    } catch (e) {
      print('Ошибка при очистке данных: $e');
      rethrow;
    }
  }
}

