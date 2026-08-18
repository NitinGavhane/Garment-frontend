// Cross-platform Cashfree checkout.
//
// Mobile builds use the `flutter_cashfree_pg_sdk` plugin; web builds use the
// Cashfree `cashfree.js` script via JS interop. The correct implementation is
// selected at compile time by the conditional export below.
export 'cashfree_models.dart';
export 'cashfree_checkout_stub.dart'
    if (dart.library.io) 'cashfree_checkout_mobile.dart'
    if (dart.library.html) 'cashfree_checkout_web.dart';