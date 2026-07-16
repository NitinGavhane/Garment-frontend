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
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    return ApiClient.post('/api/v1/payments/verify', body: {
      'order_id': orderId,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    });
  }
}
