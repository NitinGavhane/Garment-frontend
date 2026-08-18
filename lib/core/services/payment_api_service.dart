import 'api_client.dart';

class PaymentApiService {
  static Future<Map<String, dynamic>> createPayment({
    required String orderId,
    String? paymentMethod,
  }) async {
    return ApiClient.post('/api/v1/payments/create', body: {
      'order_id': orderId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    });
  }

  static Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String cashfreeOrderId,
  }) async {
    return ApiClient.post('/api/v1/payments/verify', body: {
      'order_id': orderId,
      'cashfree_order_id': cashfreeOrderId,
    });
  }
}
