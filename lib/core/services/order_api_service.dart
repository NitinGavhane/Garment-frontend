import 'dart:typed_data';

import 'api_client.dart';

class OrderApiService {
  static Future<Map<String, dynamic>> createOrder({
    required String shippingAddress,
    String? shippingState,
    required List<Map<String, dynamic>> items,
  }) async {
    return ApiClient.post('/api/v1/orders', body: {
      'shipping_address': shippingAddress,
      // Drives intra-state (CGST+SGST) vs inter-state (IGST) GST server-side.
      if (shippingState != null && shippingState.isNotEmpty)
        'shipping_state': shippingState,
      'items': items,
    });
  }

  static Future<List<dynamic>> listOrders() async {
    return ApiClient.getList('/api/v1/orders');
  }

  static Future<Map<String, dynamic>> getOrder(String orderId) async {
    return ApiClient.get('/api/v1/orders/$orderId');
  }

  /// The order's GST tax invoice as PDF bytes. The backend only serves it for
  /// paid orders, otherwise it throws an ApiException the caller can show.
  static Future<Uint8List> downloadInvoice(String orderId) async {
    return ApiClient.getBytes('/api/v1/orders/$orderId/invoice');
  }

  /// Uploads a customer return/replace evidence photo; returns the public URL.
  static Future<String> uploadReturnEvidence({
    required List<int> fileBytes,
    required String fileName,
    String? contentType,
  }) async {
    final res = await ApiClient.postMultipart(
      '/api/v1/upload/return-evidence',
      fileBytes: fileBytes,
      fileName: fileName,
      contentType: contentType,
    );
    return res['url'] as String;
  }
}
