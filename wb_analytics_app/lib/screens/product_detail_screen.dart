import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final String articleId;

  const ProductDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshProduct() async {
    setState(() {
      _isRefreshing = true;
    });

    final provider = context.read<ProductsProvider>();
    await provider.updateProduct(widget.articleId);

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

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
          'Детали товара',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7232F2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF7232F2),
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF7232F2),
                        size: 20,
                      ),
              ),
              onPressed: _isRefreshing ? null : _refreshProduct,
            ),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          final product = provider.getProduct(widget.articleId);

          if (product == null) {
            return const Center(
              child: Text('Товар не найден'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(product),
                _buildProductInfo(product),
                _buildProductStats(product),
                if (product.history != null && product.history!.isNotEmpty)
                  _buildChart(product),
                _buildActions(context, product),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: CachedNetworkImage(
            imageUrl: product.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[200]!,
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF7232F2),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[200]!,
                  ],
                ),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tag_rounded,
                  size: 18,
                  color: const Color(0xFF7232F2).withOpacity(0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Артикул: ${product.article}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7232F2).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                product.brand,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductStats(Product product) {
    final formatter = NumberFormat('#,##0', 'ru_RU');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Цена',
              '${formatter.format(product.price.toInt())} ₽',
              const Color(0xFF7232F2),
              Icons.attach_money_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(
              'Остаток',
              formatter.format(product.stock),
              const Color(0xFF007AFF),
              Icons.inventory_2_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(
              'Отзывы',
              formatter.format(product.reviews),
              const Color(0xFF34C759),
              Icons.star_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Product product) {
    final history = product.history!;
    final sortedDates = history.keys.toList()..sort();

    if (sortedDates.length < 2) {
      return const SizedBox.shrink();
    }

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
                'История изменений',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: LineChart(
              _buildChartData(sortedDates, history),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(
    List<String> dates,
    Map<String, ProductHistory> history,
  ) {
    final priceSpots = <FlSpot>[];
    final stockSpots = <FlSpot>[];
    final reviewSpots = <FlSpot>[];

    for (int i = 0; i < dates.length; i++) {
      final data = history[dates[i]]!;
      priceSpots.add(FlSpot(i.toDouble(), data.price));
      stockSpots.add(FlSpot(i.toDouble(), data.stock.toDouble()));
      reviewSpots.add(FlSpot(i.toDouble(), data.reviews.toDouble()));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < dates.length) {
                final date = DateTime.parse(dates[value.toInt()]);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('dd.MM').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: priceSpots,
          isCurved: true,
          color: const Color(0xFF7232F2),
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF7232F2).withOpacity(0.1),
          ),
        ),
        LineChartBarData(
          spots: stockSpots,
          isCurved: true,
          color: const Color(0xFF2F80ED),
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2F80ED).withOpacity(0.1),
          ),
        ),
        LineChartBarData(
          spots: reviewSpots,
          isCurved: true,
          color: const Color(0xFF27AE60),
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF27AE60).withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7232F2),
                  Color(0xFF9D5EF5),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7232F2).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _isRefreshing ? null : _refreshProduct,
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22,
              ),
              label: const Text(
                'Обновить данные',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7232F2),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _shareProduct(product),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_rounded,
                        color: const Color(0xFF7232F2),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Поделиться',
                        style: TextStyle(
                          color: Color(0xFF7232F2),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _shareProduct(Product product) {
    final formatter = NumberFormat('#,##0', 'ru_RU');
    final text = '''
${product.name}
Артикул: ${product.article}
Бренд: ${product.brand}
Цена: ${formatter.format(product.price.toInt())} ₽
Остаток: ${formatter.format(product.stock)}
Отзывы: ${formatter.format(product.reviews)}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Информация скопирована в буфер обмена'),
        backgroundColor: Colors.green,
      ),
    );
  }
}


