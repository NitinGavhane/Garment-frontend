import 'api_client.dart';

class WalletApiService {
  static Future<Map<String, dynamic>> getBalance() async {
    return ApiClient.get('/api/v1/wallet/balance');
  }

  static Future<List<dynamic>> getTransactions() async {
    return ApiClient.getList('/api/v1/wallet/transactions');
  }
}
