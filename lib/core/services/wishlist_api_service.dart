import 'api_client.dart';

class WishlistApiService {
  static Future<List<dynamic>> getWishlist() async {
    return ApiClient.getList('/api/v1/wishlist');
  }

  static Future<Map<String, dynamic>> addToWishlist(String productId) async {
    return ApiClient.post('/api/v1/wishlist/add', body: {
      'product_id': productId,
    });
  }

  static Future<Map<String, dynamic>> removeFromWishlist(String productId) async {
    return ApiClient.delete('/api/v1/wishlist/remove/$productId');
  }
}
