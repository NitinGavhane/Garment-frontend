import 'api_client.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    return ApiClient.post('/api/v1/auth/register', body: {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      if (referralCode != null && referralCode.isNotEmpty)
        'referral_code': referralCode,
    });
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return ApiClient.post('/api/v1/auth/verify-otp', body: {
      'phone': phone,
      'otp': otp,
    });
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await ApiClient.post('/api/v1/auth/login', body: {
      'email': email,
      'password': password,
    });
    await ApiClient.setTokens(
      result['access_token'] as String,
      result['refresh_token'] as String,
    );
    return result;
  }

  static Future<Map<String, dynamic>> refreshToken() async {
    final rt = ApiClient.refreshToken;
    if (rt == null) throw ApiException(statusCode: 401, message: 'No refresh token');
    final result = await ApiClient.post('/api/v1/auth/refresh-token', body: {
      'refresh_token': rt,
    });
    await ApiClient.setTokens(
      result['access_token'] as String,
      result['refresh_token'] as String,
    );
    return result;
  }

  static Future<Map<String, dynamic>> getProfile() async {
    return ApiClient.get('/api/v1/auth/me');
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    return ApiClient.post('/api/v1/auth/reset-password', body: {
      'phone': phone,
      'otp': otp,
      'new_password': newPassword,
    });
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
    String? phone,
  }) async {
    return ApiClient.put('/api/v1/auth/me', body: {
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    });
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return ApiClient.post('/api/v1/auth/change-password', body: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  static Future<void> logout() async {
    await ApiClient.clearTokens();
  }
}
