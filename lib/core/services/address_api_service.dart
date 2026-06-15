import 'api_client.dart';

class AddressApiService {
  static Future<List<dynamic>> listAddresses() async {
    return ApiClient.getList('/api/v1/addresses');
  }

  static Future<Map<String, dynamic>> createAddress({
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String state,
    required String pincode,
    String type = 'Home',
    bool isDefault = false,
  }) async {
    return ApiClient.post('/api/v1/addresses', body: {
      'full_name': fullName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'type': type,
      'is_default': isDefault,
    });
  }

  static Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? pincode,
    String? type,
    bool? isDefault,
  }) async {
    return ApiClient.put('/api/v1/addresses/$addressId', body: {
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (type != null) 'type': type,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  static Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    return ApiClient.delete('/api/v1/addresses/$addressId');
  }
}
