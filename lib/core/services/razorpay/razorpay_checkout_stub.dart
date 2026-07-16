import 'razorpay_models.dart';

/// Fallback used when neither dart:io nor dart:html is available.
class RazorpayCheckout {
  void open(
    RazorpayOptions options, {
    required RazorpaySuccessCallback onSuccess,
    required RazorpayErrorCallback onError,
  }) {
    onError('Payments are not supported on this platform');
  }

  void dispose() {}
}
