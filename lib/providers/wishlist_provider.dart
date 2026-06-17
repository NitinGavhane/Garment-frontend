import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/services/wishlist_api_service.dart';
import '../core/services/product_api_service.dart';
import '../core/services/api_client.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  Set<String> _wishlistedIds = {};
  List<Product> _wishlistProducts = [];
  bool _isLoaded = false;
  bool _isLoading = false;
  String? _error;

  Set<String> get wishlistedIds => _wishlistedIds;
  List<Product> get wishlistProducts => _wishlistProducts;
  int get count => _wishlistedIds.length;
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('wishlist_ids');
    if (stored != null) {
      final list = jsonDecode(stored) as List<dynamic>;
      _wishlistedIds = list.map((e) => e as String).toSet();
    }

    try {
      final data = await WishlistApiService.getWishlist();
      if (data.isNotEmpty) {
        _wishlistedIds = data.map((item) => item['product_id'] as String).toSet();
      }
    } catch (_) {}

    _isLoaded = true;
    notifyListeners();
    await _fetchWishlistProductDetails();
  }

  Future<void> _fetchWishlistProductDetails() async {
    if (_wishlistedIds.isEmpty) return;
    try {
      final results = await Future.wait(
        _wishlistedIds.map((id) => ProductApiService.getProduct(id)),
        eagerError: false,
      );
      _wishlistProducts = results.map((data) {
        final apiProduct = ApiProduct.fromJson(data);
        return Product.fromApiProduct(apiProduct);
      }).toList();
      notifyListeners();
    } catch (_) {}
  }

  bool isWishlisted(String productId) {
    return _wishlistedIds.contains(productId);
  }

  Future<void> toggle(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_wishlistedIds.contains(productId)) {
        await WishlistApiService.removeFromWishlist(productId);
        _wishlistedIds.remove(productId);
        _wishlistProducts.removeWhere((p) => p.id == productId);
      } else {
        await WishlistApiService.addToWishlist(productId);
        _wishlistedIds.add(productId);
        try {
          final data = await ProductApiService.getProduct(productId);
          final apiProduct = ApiProduct.fromJson(data);
          _wishlistProducts.add(Product.fromApiProduct(apiProduct));
        } catch (_) {}
      }
      _error = null;
      await _persist();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to update wishlist';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wishlist_ids', jsonEncode(_wishlistedIds.toList()));
  }
}
