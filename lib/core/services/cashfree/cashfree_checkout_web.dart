import 'dart:async';
import 'dart:js_interop';

import 'dart:js_interop_unsafe';

import 'cashfree_models.dart';

const String kCashfreeScriptSrc = 'https://sdk.cashfree.com/js/v3/cashfree.js';

/// Constructor for the global `Cashfree` function provided by cashfree.js
/// (injected on demand). Creating an instance mirrors
/// `new Cashfree({ mode: 'sandbox' })`.
@JS('Cashfree')
extension type _Cashfree._(JSObject _) implements JSObject {
  external factory _Cashfree(JSObject options);

  /// Returns a Promise resolving to the checkout result once the hosted page
  /// has been launched (or has failed to launch).
  external JSPromise<JSObject?> checkout(JSObject options);
}

/// Loads the gateway's script on demand and returns whether `Cashfree` became
/// available. A failed attempt is forgotten so a later retry re-attempts.
Future<bool> _ensureCashfreeLoaded() {
  if (globalContext.has('Cashfree')) return Future.value(true);
  final completer = Completer<bool>();
  final document = globalContext['document'] as JSObject;
  final script = document.callMethod('createElement'.toJS, 'script'.toJS) as JSObject;
  script['src'] = kCashfreeScriptSrc.toJS;
  script['async'] = true.toJS;
  script['onload'] = (() => completer.complete(true)).toJS;
  script['onerror'] = (() => completer.complete(false)).toJS;
  final body = document.callMethod('body'.toJS);
  (body as JSObject).callMethod('appendChild'.toJS, script);
  return completer.future;
}

/// Web Cashfree checkout using the cashfree.js script via js_interop.
///
/// Payment runs on Cashfree's hosted page, which then redirects the browser to
/// the configured return URL. That return page performs the server-side
/// verification, so launching the checkout (redirect) is treated as a hand-off,
/// not a completed payment: no success callback is fired here.
class CashfreeCheckout {
  Future<void> open(
    CashfreeOptions options, {
    required CashfreeSuccessCallback onSuccess,
    required CashfreeErrorCallback onError,
  }) async {
    final ready = await _ensureCashfreeLoaded();
    if (!ready || !globalContext.has('Cashfree')) {
      onError('Cashfree checkout could not be loaded. Please retry.');
      return;
    }

    final mode = options.cashfreeEnvironment.toLowerCase() == 'production'
        ? 'production'
        : 'sandbox';

    final config = JSObject();
    config['mode'] = mode.toJS;
    final cashfree = _Cashfree(config);

    final checkoutOptions = JSObject();
    checkoutOptions['paymentSessionId'] = options.paymentSessionId.toJS;
    if (options.returnUrl != null && options.returnUrl!.isNotEmpty) {
      checkoutOptions['returnUrl'] = options.returnUrl!.toJS;
    }
    checkoutOptions['redirectTarget'] = '_top'.toJS;

    try {
      final result = await cashfree.checkout(checkoutOptions).toDart;
      if (result == null) {
        onError('The payment gateway did not respond. Please try again.');
        return;
      }
      final error = result['error'] as JSObject?;
      if (error != null) {
        final message = error['message'] as JSString?;
        onError(message?.toDart ?? 'Payment failed');
        return;
      }
      // The hosted page (or the pending redirect) is now in charge. The return
      // redirect completes verification, so nothing further happens here.
    } catch (_) {
      onError('Payment cancelled before it was completed.');
    }
  }

  void dispose() {}
}