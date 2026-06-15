import 'api_client.dart';

class CartApiService {
  static Future<Map<String, dynamic>> getCart() async {
    return ApiClient.get('/api/v1/cart');
  }

  static Future<Map<String, dynamic>> addToCart({
    required String productId,
    String? variantId,
    int quantity = 1,
  }) async {
    return ApiClient.post('/api/v1/cart/add', body: {
      'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      'quantity': quantity,
    });
  }

  static Future<Map<String, dynamic>> updateCart({
    required String cartItemId,
    required int quantity,
  }) async {
    return ApiClient.put('/api/v1/cart/update', body: {
      'cart_item_id': cartItemId,
      'quantity': quantity,
    });
  }

  static Future<Map<String, dynamic>> removeFromCart(
      String cartItemId) async {
    return ApiClient.delete('/api/v1/cart/remove/$cartItemId');
  }
}
