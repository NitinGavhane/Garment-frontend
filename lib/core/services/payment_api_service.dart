import 'api_client.dart';

class PaymentApiService {
  static Future<Map<String, dynamic>> createPayment({
    required String orderId,
  }) async {
    return ApiClient.post('/api/v1/payments/create', body: {
      'order_id': orderId,
    });
  }

  static Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String transactionId,
    String? paymentMethod,
  }) async {
    return ApiClient.post('/api/v1/payments/verify', body: {
      'order_id': orderId,
      'transaction_id': transactionId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    });
  }
}
