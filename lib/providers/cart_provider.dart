import 'package:flutter/foundation.dart';
import '../core/services/cart_api_service.dart';
import '../core/services/api_client.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => _items;
  int get count => _items.length;
  double get subtotal => _items.fold<double>(0, (sum, item) => sum + item.totalPrice);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await CartApiService.getCart();
      final apiItems = (response['items'] as List<dynamic>?)
              ?.map((i) => ApiCartItem.fromJson(i as Map<String, dynamic>))
              .toList() ?? [];

      for (final apiItem in apiItems) {
        final localIndex = _items.indexWhere(
          (item) => item.product.id == apiItem.productId,
        );
        if (localIndex >= 0) {
          _items[localIndex].quantity = apiItem.quantity;
        } else {
          final product = Product.fromApiCartItem(apiItem);
          _items.add(CartItem(
            id: apiItem.id,
            product: product,
            quantity: apiItem.quantity,
            selectedSize: '',
            selectedColor: '',
          ));
        }
      }
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToCart({
    required Product product,
    required int quantity,
    required String selectedSize,
    required String selectedColor,
  }) async {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
    }
    notifyListeners();
    try {
      await CartApiService.addToCart(
        productId: product.id,
        quantity: quantity,
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
    }
    return true;
  }

  Future<void> updateQuantity(int index, int delta) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    final newQty = item.quantity + delta;
    if (newQty > 0) {
      try {
        await CartApiService.updateCart(
          cartItemId: item.id,
          quantity: newQty,
        );
        _items[index].quantity = newQty;
      } catch (_) {
        _items[index].quantity = newQty;
      }
    } else {
      await removeItem(index);
      return;
    }
    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= _items.length) return;
    final itemId = _items[index].id;
    _items.removeAt(index);
    notifyListeners();
    try {
      await CartApiService.removeFromCart(itemId);
    } catch (_) {}
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
