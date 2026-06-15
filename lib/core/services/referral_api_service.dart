import 'api_client.dart';

class ReferralApiService {
  static Future<Map<String, dynamic>> getStats() async {
    return ApiClient.get('/api/v1/referral/me');
  }

  static Future<List<dynamic>> getHistory() async {
    return ApiClient.getList('/api/v1/referral/history');
  }
}
