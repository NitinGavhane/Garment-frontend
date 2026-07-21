import '../../models/delivery_settings.dart';
import 'api_client.dart';

class DeliveryApiService {
  /// The store-wide delivery policy (fee + free-over threshold), configured in
  /// the Admin app. Used by checkout to show the delivery charge.
  static Future<DeliverySettings> getSettings() async {
    final raw = await ApiClient.get('/api/v1/delivery');
    return DeliverySettings.fromJson(raw);
  }
}
