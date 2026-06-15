import 'api_client.dart';

class ReviewApiService {
  static Future<List<dynamic>> getProductReviews(String productId) async {
    return ApiClient.getList('/api/v1/products/$productId/reviews');
  }

  static Future<Map<String, dynamic>> createReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    return ApiClient.post('/api/v1/products/$productId/reviews', body: {
      'rating': rating,
      if (comment != null) 'comment': comment,
    });
  }
}
