import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartState extends ChangeNotifier {
  final List<CartItem> items = [];

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => items.fold(0, (sum, i) => sum + i.subtotal);

  CartItem? _find(int productId) {
    try {
      return items.firstWhere((i) => i.product.id == productId);
    } catch (_) {
      return null;
    }
  }

  bool has(int productId) => _find(productId) != null;

  void add(Product product) {
    final existing = _find(product.id);
    if (existing != null) {
      existing.quantity++;
    } else {
      items.add(CartItem(product));
    }
    notifyListeners();
  }

  void decrease(int productId) {
    final item = _find(productId);
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }
    notifyListeners();
  }

  void remove(int productId) {
    items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}
