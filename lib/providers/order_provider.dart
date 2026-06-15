import 'package:flutter/foundation.dart';
import '../core/services/order_api_service.dart';
import '../core/services/api_client.dart';
import '../models/api_order.dart';

class OrderProvider extends ChangeNotifier {
  List<ApiOrder> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<ApiOrder> get orders => _orders;
  int get count => _orders.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final rawList = await OrderApiService.listOrders();
      _orders = rawList
          .map((json) => ApiOrder.fromJson(json as Map<String, dynamic>))
          .toList();
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load orders';
    }
    _isLoading = false;
    notifyListeners();
  }
}
