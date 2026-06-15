import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/services/wishlist_api_service.dart';
import '../core/services/api_client.dart';

class WishlistProvider extends ChangeNotifier {
  Set<String> _wishlistedIds = {};
  bool _isLoaded = false;
  bool _isLoading = false;
  String? _error;

  Set<String> get wishlistedIds => _wishlistedIds;
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
        await _persist();
      }
    } catch (_) {}

    _isLoaded = true;
    notifyListeners();
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
      } else {
        await WishlistApiService.addToWishlist(productId);
        _wishlistedIds.add(productId);
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
