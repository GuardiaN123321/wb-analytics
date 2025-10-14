import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Аналитика Маркетплейсов',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
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
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFF7232F2),
                  size: 20,
                ),
              ),
              onPressed: () {
                final provider = context.read<ProductsProvider>();
                provider.updateAllProducts();
              },
            ),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadProducts();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (provider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF7232F2).withOpacity(0.1),
                          const Color(0xFF9D5EF5).withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: const Color(0xFF7232F2).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Начните отслеживание',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Добавьте товары для аналитики\nи отслеживания позиций',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.updateAllProducts(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          articleId: product.article,
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить товар?'),
                        content: Text(
                          'Вы действительно хотите удалить "${product.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      provider.removeProduct(product.article);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7232F2).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF7232F2),
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

