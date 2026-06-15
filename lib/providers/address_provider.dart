import 'package:flutter/foundation.dart';
import '../core/services/address_api_service.dart';
import '../core/services/api_client.dart';
import '../models/address.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _error;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  Future<void> fetchAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await AddressApiService.listAddresses();
      _addresses = data.map((json) => Address.fromJson(json as Map<String, dynamic>)).toList();
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load addresses';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createAddress({
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String state,
    required String pincode,
    String type = 'Home',
    bool isDefault = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AddressApiService.createAddress(
        fullName: fullName,
        phone: phone,
        street: street,
        city: city,
        state: state,
        pincode: pincode,
        type: type,
        isDefault: isDefault,
      );
      _addresses.add(Address.fromJson(result));
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to save address';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress({
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AddressApiService.updateAddress(
        addressId: addressId,
        fullName: fullName,
        phone: phone,
        street: street,
        city: city,
        state: state,
        pincode: pincode,
        type: type,
        isDefault: isDefault,
      );
      final updated = Address.fromJson(result);
      final index = _addresses.indexWhere((a) => a.id == addressId);
      if (index != -1) _addresses[index] = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to update address';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    _error = null;

    try {
      await AddressApiService.deleteAddress(addressId);
      _addresses.removeWhere((a) => a.id == addressId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to delete address';
      notifyListeners();
      return false;
    }
  }
}
