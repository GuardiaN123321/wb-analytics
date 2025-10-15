import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';
import '../services/analytics_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Экран сравнения товаров
class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  Product? _selectedProduct1;
  Product? _selectedProduct2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Сравнение товаров',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return const Center(
              child: Text('Добавьте товары для сравнения'),
            );
          }

          if (provider.products.length < 2) {
            return const Center(
              child: Text('Для сравнения нужно минимум 2 товара'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Выбор товаров
                Container(
                  margin: const EdgeInsets.all(16),
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
                      const Text(
                        'Выберите товары для сравнения',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProductSelector(
                        'Товар 1',
                        _selectedProduct1,
                        provider.products,
                        (product) => setState(() => _selectedProduct1 = product),
                      ),
                      const SizedBox(height: 12),
                      _buildProductSelector(
                        'Товар 2',
                        _selectedProduct2,
                        provider.products,
                        (product) => setState(() => _selectedProduct2 = product),
                      ),
                    ],
                  ),
                ),

                // Результат сравнения
                if (_selectedProduct1 != null && _selectedProduct2 != null)
                  _buildComparisonResult(_selectedProduct1!, _selectedProduct2!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSelector(
    String label,
    Product? selected,
    List<Product> products,
    Function(Product) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showProductPicker(context, products, onSelect),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: selected.image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Арт: ${selected.article}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Text(
                      'Выберите товар',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showProductPicker(
    BuildContext context,
    List<Product> products,
    Function(Product) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Выберите товар',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      onSelect(product);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Арт: ${product.article}',
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonResult(Product product1, Product product2) {
    final comparison = AnalyticsService.compareProducts(product1, product2);
    final formatter = NumberFormat('#,##0.00', 'ru_RU');

    return Container(
      margin: const EdgeInsets.all(16),
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
                  Icons.compare_arrows_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Результаты сравнения',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Сравнение цен
          _buildComparisonRow(
            'Цена',
            '${formatter.format(product1.price)} ₽',
            '${formatter.format(product2.price)} ₽',
            comparison.priceDifference,
            isPrice: true,
          ),
          const Divider(height: 24),

          // Сравнение остатков
          _buildComparisonRow(
            'Остаток',
            '${product1.stock}',
            '${product2.stock}',
            comparison.stockDifference.toDouble(),
          ),
          const Divider(height: 24),

          // Сравнение отзывов
          _buildComparisonRow(
            'Отзывы',
            '${product1.reviews}',
            '${product2.reviews}',
            comparison.reviewsDifference.toDouble(),
          ),
          const Divider(height: 24),

          // Сравнение рейтингов
          if (product1.rating != null || product2.rating != null) ...[
            _buildComparisonRow(
              'Рейтинг',
              product1.rating?.toStringAsFixed(1) ?? 'N/A',
              product2.rating?.toStringAsFixed(1) ?? 'N/A',
              comparison.ratingDifference,
              isRating: true,
            ),
            const Divider(height: 24),
          ],

          // Сравнение скорости продаж
          if (comparison.salesSpeedDifference != 0) ...[
            _buildComparisonRow(
              'Скорость продаж',
              '${AnalyticsService.calculateSalesAnalysis(product1).salesPerDay.toStringAsFixed(1)}/день',
              '${AnalyticsService.calculateSalesAnalysis(product2).salesPerDay.toStringAsFixed(1)}/день',
              comparison.salesSpeedDifference,
            ),
            const Divider(height: 24),
          ],

          // Сравнение прибыли
          if (comparison.profitDifference != 0) ...[
            _buildComparisonRow(
              'Прибыль с единицы',
              '${formatter.format(AnalyticsService.calculateProfit(product1).profit)} ₽',
              '${formatter.format(AnalyticsService.calculateProfit(product2).profit)} ₽',
              comparison.profitDifference,
              isPrice: true,
            ),
            const Divider(height: 24),
          ],

          // Рекомендация
          const SizedBox(height: 12),
          _buildRecommendation(comparison, product1, product2),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String value1,
    String value2,
    double difference, {
    bool isPrice = false,
    bool isRating = false,
  }) {
    final formatter = NumberFormat('#,##0.00', 'ru_RU');
    final absDiff = difference.abs();
    
    String diffText;
    if (isPrice) {
      diffText = '${formatter.format(absDiff)} ₽';
    } else if (isRating) {
      diffText = absDiff.toStringAsFixed(1);
    } else {
      diffText = absDiff.toStringAsFixed(0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: difference > 0
                      ? Colors.green.withOpacity(0.1)
                      : difference < 0
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: difference > 0
                        ? Colors.green
                        : difference < 0
                            ? Colors.red
                            : Colors.grey[700],
                  ),
                ),
              ),
            ),
            if (difference != 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      difference > 0
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_back_rounded,
                      color: difference > 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    Text(
                      diffText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: difference > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: difference < 0
                      ? Colors.green.withOpacity(0.1)
                      : difference > 0
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value2,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: difference < 0
                        ? Colors.green
                        : difference > 0
                            ? Colors.red
                            : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendation(
    ComparisonResult comparison,
    Product product1,
    Product product2,
  ) {
    int score1 = 0;
    int score2 = 0;

    // Подсчет очков для рекомендации
    if (comparison.profitDifference > 0) score1++;
    if (comparison.profitDifference < 0) score2++;
    
    if (comparison.salesSpeedDifference > 0) score1++;
    if (comparison.salesSpeedDifference < 0) score2++;
    
    if (comparison.ratingDifference > 0) score1++;
    if (comparison.ratingDifference < 0) score2++;

    final recommended = score1 > score2 ? product1 : score2 > score1 ? product2 : null;

    if (recommended == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[700],
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Товары имеют схожие показатели',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.green[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Рекомендуем',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommended.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Арт: ${recommended.article}',
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
}

