import 'api_client.dart';

class OrderApiService {
  static Future<Map<String, dynamic>> createOrder({
    required String shippingAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    return ApiClient.post('/api/v1/orders', body: {
      'shipping_address': shippingAddress,
      'items': items,
    });
  }

  static Future<List<dynamic>> listOrders() async {
    return ApiClient.getList('/api/v1/orders');
  }

  static Future<Map<String, dynamic>> getOrder(String orderId) async {
    return ApiClient.get('/api/v1/orders/$orderId');
  }
}
