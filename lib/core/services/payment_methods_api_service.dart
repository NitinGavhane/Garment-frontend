import '../../models/payment_method.dart';
import 'api_client.dart';

class PaymentMethodsApiService {
  /// Methods available in [region] (an ISO alpha-2 code taken from the delivery
  /// address), already filtered and ordered by the backend.
  static Future<List<PaymentMethod>> listPaymentMethods({String region = 'IN'}) async {
    final raw = await ApiClient.getList(
      '/api/v1/payment-methods',
      queryParams: {'region': region},
    );
    return raw
        .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
