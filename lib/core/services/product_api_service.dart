import 'api_client.dart';

class ProductApiService {
  static Future<List<dynamic>> listProducts({
    String? category,
    String? search,
    String? sort,
    bool? featured,
    String? gender,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (sort != null) queryParams['sort'] = sort;
    if (featured != null) queryParams['featured'] = featured.toString();
    if (gender != null && gender != 'ALL') queryParams['gender'] = gender.toLowerCase();

    return ApiClient.getList('/api/v1/products',
        queryParams: queryParams.isNotEmpty ? queryParams : null);
  }

  static Future<Map<String, dynamic>> getProduct(String productId) async {
    return ApiClient.get('/api/v1/products/$productId');
  }
}
