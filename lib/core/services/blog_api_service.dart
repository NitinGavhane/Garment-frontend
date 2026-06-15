import 'api_client.dart';

class BlogApiService {
  static Future<List<dynamic>> listPosts() async {
    return ApiClient.getList('/api/v1/blog');
  }
}
