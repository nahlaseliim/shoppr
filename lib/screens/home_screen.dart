import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../state/auth_state.dart';
import '../state/cart_state.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ProductService();

  List<Product> _products = [];
  List<String> _categories = ['all'];
  String _selectedCategory = 'all';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _service.fetchAll(),
        _service.fetchCategories(),
      ]);

      setState(() {
        _products = List<Product>.from(results[0] as List);
        _categories = ['all', ...List<String>.from(results[1] as List)];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load products. Check your connection.';
        _loading = false;
      });
    }
  }

  Future<void> _filterByCategory(String category) async {
    setState(() {
      _selectedCategory = category;
      _loading = true;
    });

    try {
      final products = category == 'all'
          ? await _service.fetchAll()
          : await _service.fetchByCategory(category);

      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load products.';
        _loading = false;
      });
    }
  }

  void _logout() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartState>().totalItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoppr'),
        actions: [
          Badge(
            label: Text('$cartCount'),
            isLabelVisible: cartCount > 0,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          _CategoryBar(
            categories: _categories,
            selected: _selectedCategory,
            onSelect: _filterByCategory,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            FilledButton(onPressed: _loadProducts, child: const Text('Retry')),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _products.length,
      itemBuilder: (_, i) => ProductCard(product: _products[i]),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final void Function(String) onSelect;

  const _CategoryBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = cat == selected;
          return ChoiceChip(
            label: Text(cat[0].toUpperCase() + cat.substring(1)),
            selected: isSelected,
            onSelected: (_) => onSelect(cat),
          );
        },
      ),
    );
  }
}