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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Детали товара'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshProduct,
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
      color: Colors.white,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: product.image,
          height: 300,
          fit: BoxFit.contain,
          placeholder: (context, url) => const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 300,
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.article, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Артикул: ${product.article}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.business, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                product.brand,
                style: TextStyle(
                  fontSize: 14,
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
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Цена',
              '${formatter.format(product.price.toInt())} ₽',
              Colors.purple,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Остаток',
              formatter.format(product.stock),
              Colors.blue,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Отзывы',
              formatter.format(product.reviews),
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(Product product) {
    final history = product.history!;
    final sortedDates = history.keys.toList()..sort();

    if (sortedDates.length < 2) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'История изменений',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
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
          ElevatedButton.icon(
            onPressed: _isRefreshing ? null : _refreshProduct,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Обновить данные',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7232F2),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _shareProduct(product),
            icon: const Icon(Icons.share),
            label: const Text('Поделиться'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
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

