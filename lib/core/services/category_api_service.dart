import 'api_client.dart';

class CategoryApiService {
  static Future<List<dynamic>> listCategories() async {
    return ApiClient.getList('/api/v1/categories');
  }
}
