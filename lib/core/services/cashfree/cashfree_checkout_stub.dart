import 'cashfree_models.dart';

/// Fallback used when neither dart:io nor dart:html is available.
class CashfreeCheckout {
  void open(
    CashfreeOptions options, {
    required CashfreeSuccessCallback onSuccess,
    required CashfreeErrorCallback onError,
  }) {
    onError('Payments are not supported on this platform');
  }

  void dispose() {}
}