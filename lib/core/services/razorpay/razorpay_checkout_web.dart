import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'razorpay_models.dart';

/// Bindings to the global `Razorpay` constructor provided by checkout.js
/// (loaded in web/index.html).
@JS('Razorpay')
extension type _Razorpay._(JSObject _) implements JSObject {
  external factory _Razorpay(JSObject options);
  external void open();
  external void on(String event, JSFunction handler);
}

/// Web Razorpay checkout using the checkout.js script via js_interop.
class RazorpayCheckout {
  void open(
    RazorpayOptions options, {
    required RazorpaySuccessCallback onSuccess,
    required RazorpayErrorCallback onError,
  }) {
    if (!globalContext.has('Razorpay')) {
      onError('Razorpay checkout could not be loaded. Please retry.');
      return;
    }

    var done = false;

    final prefill = JSObject();
    prefill['email'] = (options.email ?? '').toJS;
    prefill['contact'] = (options.contact ?? '').toJS;

    final modal = JSObject();
    modal['ondismiss'] = (() {
      if (!done) onError('Payment cancelled');
    }).toJS;

    final config = JSObject();
    config['key'] = options.keyId.toJS;
    config['order_id'] = options.orderId.toJS;
    config['amount'] = options.amountPaise.toJS;
    config['currency'] = options.currency.toJS;
    config['name'] = options.name.toJS;
    config['description'] = (options.description ?? '').toJS;
    config['prefill'] = prefill;
    config['modal'] = modal;
    config['handler'] = ((JSObject resp) {
      done = true;
      onSuccess(RazorpaySuccess(
        paymentId: (resp['razorpay_payment_id'] as JSString?)?.toDart ?? '',
        orderId: (resp['razorpay_order_id'] as JSString?)?.toDart ?? options.orderId,
        signature: (resp['razorpay_signature'] as JSString?)?.toDart ?? '',
      ));
    }).toJS;

    final rzp = _Razorpay(config);
    rzp.on(
      'payment.failed',
      ((JSObject resp) {
        done = true;
        final err = resp['error'] as JSObject?;
        final desc = err?['description'] as JSString?;
        onError(desc?.toDart ?? 'Payment failed');
      }).toJS,
    );
    rzp.open();
  }

  void dispose() {}
}
