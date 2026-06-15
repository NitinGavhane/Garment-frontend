import 'api_client.dart';

class HomeApiService {
  static Future<Map<String, dynamic>> getHomeContent() async {
    return ApiClient.get('/api/v1/home');
  }
}
