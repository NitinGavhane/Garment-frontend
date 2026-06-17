import 'package:flutter/foundation.dart';
import '../core/services/product_api_service.dart';
import '../core/services/api_client.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({
    String? category,
    String? search,
    String? sort,
    bool? featured,
    String? gender,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final rawList = await ProductApiService.listProducts(
        category: category,
        search: search,
        sort: sort,
        featured: featured,
        gender: gender,
      );
      _products = rawList.map((json) {
        final apiProduct = ApiProductListItem.fromJson(json as Map<String, dynamic>);
        return Product(
          id: apiProduct.id,
          title: apiProduct.title,
          description: apiProduct.description ?? '',
          brand: apiProduct.brand ?? '',
          category: apiProduct.categoryName ?? '',
          categoryId: apiProduct.categoryId ?? '',
          price: apiProduct.displayPrice,
          originalPrice: apiProduct.price,
          discountPercentage: apiProduct.discountPrice != null
              ? ((apiProduct.price - apiProduct.discountPrice!) / apiProduct.price * 100).round()
              : 0,
          sizes: apiProduct.sizes,
          colors: apiProduct.colors,
          isFeatured: apiProduct.featured,
          stock: apiProduct.stock,
          imageUrl: apiProduct.primaryImage ?? '',
          gender: apiProduct.gender,
        );
      }).toList();
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load products';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Product?> fetchProductDetail(String productId) async {
    try {
      final data = await ProductApiService.getProduct(productId);
      final apiProduct = ApiProduct.fromJson(data);
      final product = Product.fromApiProduct(apiProduct);

      final existingIdx = _products.indexWhere((p) => p.id == productId);
      if (existingIdx != -1) {
        _products[existingIdx] = product;
        notifyListeners();
      }

      return product;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load product details';
    }
    return null;
  }

  List<Product> filterByGender(String gender) {
    if (gender == 'ALL') return _products;
    return _products.where((p) {
      if (p.gender.isEmpty) return false;
      if (p.gender == 'unisex') return true;
      return p.gender.toUpperCase() == gender;
    }).toList();
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  List<Product> searchProducts(String query) {
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> get newProducts =>
      _products.where((p) => p.isNew).toList();

  List<Product> filterBySize(String size) =>
      _products.where((p) => p.sizes.contains(size)).toList();

  List<Product> filterByColor(String color) =>
      _products.where((p) => p.colors.contains(color)).toList();

  List<Product> filterByMaxPrice(double maxPrice) =>
      _products.where((p) => p.price <= maxPrice).toList();

  List<Product> sortByPriceLowToHigh() {
    final sorted = List<Product>.from(_products);
    sorted.sort((a, b) => a.price.compareTo(b.price));
    return sorted;
  }

  List<Product> sortByPriceHighToLow() {
    final sorted = List<Product>.from(_products);
    sorted.sort((a, b) => b.price.compareTo(a.price));
    return sorted;
  }

  List<Product> sortByRating() {
    final sorted = List<Product>.from(_products);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }
}
