import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'razorpay_models.dart';

/// Mobile (Android/iOS) Razorpay checkout using the razorpay_flutter plugin.
class RazorpayCheckout {
  Razorpay? _rzp;
  RazorpaySuccessCallback? _onSuccess;
  RazorpayErrorCallback? _onError;
  String? _orderId;

  void open(
    RazorpayOptions options, {
    required RazorpaySuccessCallback onSuccess,
    required RazorpayErrorCallback onError,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;
    _orderId = options.orderId;

    _rzp = Razorpay();
    _rzp!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _rzp!.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _rzp!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleWallet);

    // If the buyer already chose a recognised method on our screen, only enable
    // that one so the sheet opens directly on it rather than the full menu.
    final chosen = options.method;
    final restrict = chosen != null && kRazorpayMethodKeys.contains(chosen);

    _rzp!.open({
      'key': options.keyId,
      'order_id': options.orderId,
      'amount': options.amountPaise,
      'currency': options.currency,
      'name': options.name,
      if (options.description != null) 'description': options.description,
      'prefill': {
        'email': options.email ?? '',
        'contact': options.contact ?? '',
        if (options.method != null) 'method': options.method,
      },
      if (restrict)
        'method': {
          for (final key in kRazorpayMethodKeys) key: key == chosen,
        },
    });
  }

  void _handleSuccess(PaymentSuccessResponse r) {
    _onSuccess?.call(RazorpaySuccess(
      paymentId: r.paymentId ?? '',
      orderId: r.orderId ?? _orderId ?? '',
      signature: r.signature ?? '',
    ));
  }

  void _handleError(PaymentFailureResponse r) {
    _onError?.call(r.message ?? 'Payment failed');
  }

  void _handleWallet(ExternalWalletResponse r) {}

  void dispose() {
    _rzp?.clear();
    _rzp = null;
  }
}
