import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/wb_api_service.dart';
import '../services/storage_service.dart';

class ProductsProvider with ChangeNotifier {
  final WbApiService _apiService = WbApiService();
  final StorageService _storageService = StorageService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductsProvider() {
    loadProducts();
  }

  /// Загрузка товаров из хранилища
  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _storageService.getProducts();
      // Сортируем по дате добавления (новые сверху)
      _products.sort((a, b) => b.addedAt.compareTo(a.addedAt));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки товаров: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Добавление нового товара
  Future<bool> addProduct(String articleId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Проверяем, существует ли товар
      final exists = await _storageService.productExists(articleId);
      if (exists) {
        _error = 'Товар с таким артикулом уже добавлен';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Получаем информацию о товаре
      final product = await _apiService.fetchProductInfo(articleId);
      
      if (product == null) {
        _error = 'Не удалось найти товар с указанным артикулом';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Сохраняем товар
      await _storageService.addProduct(product);
      
      // Перезагружаем список
      await loadProducts();
      
      return true;
    } catch (e) {
      _error = 'Ошибка при добавлении товара: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Удаление товара
  Future<void> removeProduct(String articleId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _storageService.removeProduct(articleId);
      await loadProducts();
    } catch (e) {
      _error = 'Ошибка при удалении товара: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновление данных товара
  Future<void> updateProduct(String articleId) async {
    try {
      final product = _products.firstWhere((p) => p.article == articleId);
      
      // Получаем обновленные данные
      final updatedData = await _apiService.fetchProductInfo(articleId);
      
      if (updatedData == null) {
        _error = 'Не удалось обновить данные товара';
        notifyListeners();
        return;
      }

      // Сохраняем историю
      final history = Map<String, ProductHistory>.from(product.history ?? {});
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      if (!history.containsKey(today)) {
        history[today] = ProductHistory(
          price: product.price,
          stock: product.stock,
          reviews: product.reviews,
        );
      }

      // Обновляем товар
      final updatedProduct = product.copyWith(
        price: updatedData.price,
        stock: updatedData.stock,
        reviews: updatedData.reviews,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
        history: history,
      );

      await _storageService.updateProduct(updatedProduct);
      await loadProducts();
    } catch (e) {
      _error = 'Ошибка при обновлении товара: $e';
      notifyListeners();
    }
  }

  /// Обновление всех товаров
  Future<void> updateAllProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      for (final product in _products) {
        await updateProduct(product.article);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка при обновлении товаров: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Получение товара по артикулу
  Product? getProduct(String articleId) {
    try {
      return _products.firstWhere((p) => p.article == articleId);
    } catch (e) {
      return null;
    }
  }

  /// Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

