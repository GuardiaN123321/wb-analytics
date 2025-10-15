import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../services/analytics_service.dart';

/// Виджет расширенной аналитики товара
class AnalyticsWidget extends StatelessWidget {
  final Product product;

  const AnalyticsWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final priceTrend = AnalyticsService.calculatePriceTrend(product);
    final stockTrend = AnalyticsService.calculateStockTrend(product);
    final profitAnalysis = AnalyticsService.calculateProfit(product);
    final priceStats = AnalyticsService.calculatePriceStatistics(product);
    final salesAnalysis = AnalyticsService.calculateSalesAnalysis(product);
    final predictedPrice = AnalyticsService.predictPrice(product);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7232F2),
                      Color(0xFF9D5EF5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Расширенная аналитика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Тренд цены
          _buildTrendCard(
            title: 'Тренд цены',
            icon: Icons.trending_up_rounded,
            trend: priceTrend.direction,
            value: '${priceTrend.percentChange.toStringAsFixed(1)}%',
            description: _getTrendDescription(priceTrend.direction),
            color: _getTrendColor(priceTrend.direction),
          ),
          const SizedBox(height: 12),

          // Прогноз цены
          if (predictedPrice != null) ...[
            _buildPredictionCard(
              title: 'Прогноз цены (7 дней)',
              predictedValue: predictedPrice,
              currentValue: product.price,
            ),
            const SizedBox(height: 12),
          ],

          // Статистика цен
          _buildStatsCard(
            title: 'Статистика цен',
            stats: priceStats,
          ),
          const SizedBox(height: 12),

          // Прибыль и рентабельность
          if (profitAnalysis.hasPurchasePrice) ...[
            _buildProfitCard(
              profitAnalysis: profitAnalysis,
              currentPrice: product.price,
            ),
            const SizedBox(height: 12),
          ],

          // Скорость продаж
          if (salesAnalysis.salesPerDay > 0) ...[
            _buildSalesCard(
              salesAnalysis: salesAnalysis,
              stockTrend: stockTrend,
            ),
            const SizedBox(height: 12),
          ],

          // Тренд остатков
          _buildTrendCard(
            title: 'Тренд остатков',
            icon: Icons.inventory_2_rounded,
            trend: stockTrend.direction,
            value: '${stockTrend.change > 0 ? "+" : ""}${stockTrend.change}',
            description: stockTrend.direction == TrendDirection.falling
                ? 'Товар продается'
                : stockTrend.direction == TrendDirection.rising
                    ? 'Товар пополняется'
                    : 'Остатки стабильны',
            color: stockTrend.direction == TrendDirection.falling
                ? Colors.orange
                : _getTrendColor(stockTrend.direction),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard({
    required String title,
    required IconData icon,
    required TrendDirection trend,
    required String value,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      trend == TrendDirection.rising
                          ? Icons.arrow_upward_rounded
                          : trend == TrendDirection.falling
                              ? Icons.arrow_downward_rounded
                              : Icons.remove_rounded,
                      color: color,
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard({
    required String title,
    required double predictedValue,
    required double currentValue,
  }) {
    final formatter = NumberFormat('#,##0.00', 'ru_RU');
    final change = predictedValue - currentValue;
    final percentChange = (change / currentValue) * 100;
    final isPositive = change > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7232F2).withOpacity(0.1),
            const Color(0xFF9D5EF5).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7232F2).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_graph_rounded,
                color: const Color(0xFF7232F2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Прогноз',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatter.format(predictedValue)} ₽',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7232F2),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentChange.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required PriceStatistics stats,
  }) {
    final formatter = NumberFormat('#,##0.00', 'ru_RU');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Средняя',
                  '${formatter.format(stats.average)} ₽',
                  const Color(0xFF7232F2),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Мин',
                  '${formatter.format(stats.min)} ₽',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Макс',
                  '${formatter.format(stats.max)} ₽',
                  Colors.orange,
                ),
              ),
            ],
          ),
          if (stats.currentDeviation.abs() > 1) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Текущая цена ${stats.currentDeviation > 0 ? "выше" : "ниже"} средней на ${stats.currentDeviation.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProfitCard({
    required ProfitAnalysis profitAnalysis,
    required double currentPrice,
  }) {
    final formatter = NumberFormat('#,##0.00', 'ru_RU');
    final isProfitable = profitAnalysis.profit > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isProfitable
              ? [
                  Colors.green.withOpacity(0.1),
                  Colors.green.withOpacity(0.05),
                ]
              : [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isProfitable
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: isProfitable ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Прибыль и рентабельность',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Прибыль с ед.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profitAnalysis.profit > 0 ? "+" : ""}${formatter.format(profitAnalysis.profit)} ₽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isProfitable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Маржа',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profitAnalysis.profitMargin.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isProfitable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROI',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profitAnalysis.roi.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isProfitable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesCard({
    required SalesAnalysis salesAnalysis,
    required StockTrend stockTrend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed_rounded,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Скорость продаж',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Продаж в день',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      salesAnalysis.salesPerDay.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              if (salesAnalysis.daysUntilOutOfStock != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Закончится через',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${salesAnalysis.daysUntilOutOfStock} дн.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: salesAnalysis.daysUntilOutOfStock! < 7
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTrendDescription(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.rising:
        return 'Цена растет';
      case TrendDirection.falling:
        return 'Цена падает';
      case TrendDirection.stable:
        return 'Цена стабильна';
    }
  }

  Color _getTrendColor(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.rising:
        return Colors.green;
      case TrendDirection.falling:
        return Colors.red;
      case TrendDirection.stable:
        return Colors.blue;
    }
  }
}

