import 'api_client.dart';

class PaymentMethodsApiService {
  static Future<List<dynamic>> listPaymentMethods() async {
    return ApiClient.getList('/api/v1/payment-methods');
  }
}
