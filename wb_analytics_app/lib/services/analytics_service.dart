import 'dart:math';
import '../models/product.dart';

/// Сервис для расчета аналитических данных
class AnalyticsService {
  /// Прогнозирование цены методом линейной регрессии
  static double? predictPrice(Product product, {int daysAhead = 7}) {
    if (product.history == null || product.history!.length < 2) {
      return null;
    }

    final sortedDates = product.history!.keys.toList()..sort();
    final prices = sortedDates.map((date) => product.history![date]!.price).toList();

    // Линейная регрессия: y = ax + b
    final n = prices.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += prices[i];
      sumXY += i * prices[i];
      sumX2 += i * i;
    }

    final a = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final b = (sumY - a * sumX) / n;

    // Прогноз на daysAhead дней вперед
    final predictedPrice = a * (n + daysAhead) + b;
    
    // Возвращаем прогноз, но не меньше 0
    return max(0, predictedPrice);
  }

  /// Расчет тренда цены (положительный - рост, отрицательный - падение)
  static PriceTrend calculatePriceTrend(Product product) {
    if (product.history == null || product.history!.isEmpty) {
      return PriceTrend(
        direction: TrendDirection.stable,
        percentChange: 0,
        change: 0,
      );
    }

    final sortedDates = product.history!.keys.toList()..sort();
    final firstPrice = product.history![sortedDates.first]!.price;
    final currentPrice = product.price;

    final change = currentPrice - firstPrice;
    final percentChange = firstPrice > 0 ? (change / firstPrice) * 100 : 0.0;

    TrendDirection direction;
    if (percentChange > 2) {
      direction = TrendDirection.rising;
    } else if (percentChange < -2) {
      direction = TrendDirection.falling;
    } else {
      direction = TrendDirection.stable;
    }

    return PriceTrend(
      direction: direction,
      percentChange: percentChange,
      change: change,
    );
  }

  /// Расчет тренда остатков
  static StockTrend calculateStockTrend(Product product) {
    if (product.history == null || product.history!.isEmpty) {
      return StockTrend(
        direction: TrendDirection.stable,
        percentChange: 0,
        change: 0,
        salesSpeed: 0,
      );
    }

    final sortedDates = product.history!.keys.toList()..sort();
    final firstStock = product.history![sortedDates.first]!.stock;
    final currentStock = product.stock;

    final change = currentStock - firstStock;
    final percentChange = firstStock > 0 ? (change / firstStock) * 100 : 0.0;

    // Расчет скорости продаж (товаров в день)
    double salesSpeed = 0;
    if (sortedDates.length > 1) {
      final firstDate = DateTime.parse(sortedDates.first);
      final lastDate = DateTime.parse(sortedDates.last);
      final daysDiff = lastDate.difference(firstDate).inDays;
      
      if (daysDiff > 0 && firstStock > currentStock) {
        salesSpeed = (firstStock - currentStock) / daysDiff;
      }
    }

    TrendDirection direction;
    if (percentChange > 5) {
      direction = TrendDirection.rising;
    } else if (percentChange < -5) {
      direction = TrendDirection.falling;
    } else {
      direction = TrendDirection.stable;
    }

    return StockTrend(
      direction: direction,
      percentChange: percentChange,
      change: change,
      salesSpeed: salesSpeed,
    );
  }

  /// Расчет прибыли/рентабельности
  static ProfitAnalysis calculateProfit(Product product) {
    if (product.purchasePrice == null || product.purchasePrice! <= 0) {
      return ProfitAnalysis(
        hasPurchasePrice: false,
        profit: 0,
        profitMargin: 0,
        roi: 0,
      );
    }

    final profit = product.price - product.purchasePrice!;
    final profitMargin = (profit / product.price) * 100;
    final roi = (profit / product.purchasePrice!) * 100;

    return ProfitAnalysis(
      hasPurchasePrice: true,
      profit: profit,
      profitMargin: profitMargin,
      roi: roi,
    );
  }

  /// Расчет средней цены за период
  static PriceStatistics calculatePriceStatistics(Product product) {
    if (product.history == null || product.history!.isEmpty) {
      return PriceStatistics(
        average: product.price,
        min: product.price,
        max: product.price,
        deviation: 0,
        currentDeviation: 0,
      );
    }

    final prices = product.history!.values.map((h) => h.price).toList()
      ..add(product.price);

    final average = prices.reduce((a, b) => a + b) / prices.length;
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);

    // Стандартное отклонение
    final variance = prices.map((p) => pow(p - average, 2)).reduce((a, b) => a + b) / prices.length;
    final deviation = sqrt(variance);

    // Отклонение текущей цены от средней
    final currentDeviation = ((product.price - average) / average) * 100;

    return PriceStatistics(
      average: average,
      min: min,
      max: max,
      deviation: deviation,
      currentDeviation: currentDeviation,
    );
  }

  /// Расчет скорости продаж и прогноз закончится ли товар
  static SalesAnalysis calculateSalesAnalysis(Product product) {
    final stockTrend = calculateStockTrend(product);
    
    int? daysUntilOutOfStock;
    if (stockTrend.salesSpeed > 0 && product.stock > 0) {
      daysUntilOutOfStock = (product.stock / stockTrend.salesSpeed).ceil();
    }

    return SalesAnalysis(
      salesPerDay: stockTrend.salesSpeed,
      daysUntilOutOfStock: daysUntilOutOfStock,
    );
  }

  /// Сравнение двух товаров
  static ComparisonResult compareProducts(Product product1, Product product2) {
    final profit1 = calculateProfit(product1);
    final profit2 = calculateProfit(product2);
    
    final sales1 = calculateSalesAnalysis(product1);
    final sales2 = calculateSalesAnalysis(product2);

    return ComparisonResult(
      priceDifference: product1.price - product2.price,
      profitDifference: profit1.profit - profit2.profit,
      stockDifference: product1.stock - product2.stock,
      reviewsDifference: product1.reviews - product2.reviews,
      salesSpeedDifference: sales1.salesPerDay - sales2.salesPerDay,
      ratingDifference: (product1.rating ?? 0) - (product2.rating ?? 0),
    );
  }
}

/// Направление тренда
enum TrendDirection {
  rising,   // Растет
  falling,  // Падает
  stable,   // Стабильно
}

/// Тренд цены
class PriceTrend {
  final TrendDirection direction;
  final double percentChange;
  final double change;

  PriceTrend({
    required this.direction,
    required this.percentChange,
    required this.change,
  });
}

/// Тренд остатков
class StockTrend {
  final TrendDirection direction;
  final double percentChange;
  final int change;
  final double salesSpeed; // товаров в день

  StockTrend({
    required this.direction,
    required this.percentChange,
    required this.change,
    required this.salesSpeed,
  });
}

/// Анализ прибыли
class ProfitAnalysis {
  final bool hasPurchasePrice;
  final double profit;         // Прибыль с единицы
  final double profitMargin;   // Маржа в процентах
  final double roi;            // Рентабельность инвестиций (ROI)

  ProfitAnalysis({
    required this.hasPurchasePrice,
    required this.profit,
    required this.profitMargin,
    required this.roi,
  });
}

/// Статистика цен
class PriceStatistics {
  final double average;          // Средняя цена
  final double min;              // Минимальная цена
  final double max;              // Максимальная цена
  final double deviation;        // Стандартное отклонение
  final double currentDeviation; // Отклонение текущей цены от средней (%)

  PriceStatistics({
    required this.average,
    required this.min,
    required this.max,
    required this.deviation,
    required this.currentDeviation,
  });
}

/// Анализ продаж
class SalesAnalysis {
  final double salesPerDay;      // Продаж в день
  final int? daysUntilOutOfStock; // Дней до окончания товара

  SalesAnalysis({
    required this.salesPerDay,
    this.daysUntilOutOfStock,
  });
}

/// Результат сравнения товаров
class ComparisonResult {
  final double priceDifference;
  final double profitDifference;
  final int stockDifference;
  final int reviewsDifference;
  final double salesSpeedDifference;
  final double ratingDifference;

  ComparisonResult({
    required this.priceDifference,
    required this.profitDifference,
    required this.stockDifference,
    required this.reviewsDifference,
    required this.salesSpeedDifference,
    required this.ratingDifference,
  });
}

