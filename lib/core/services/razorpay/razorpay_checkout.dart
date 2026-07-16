// Cross-platform Razorpay checkout.
//
// Mobile builds use the `razorpay_flutter` plugin; web builds use the Razorpay
// `checkout.js` script via JS interop. The correct implementation is selected
// at compile time by the conditional export below.
export 'razorpay_models.dart';
export 'razorpay_checkout_stub.dart'
    if (dart.library.io) 'razorpay_checkout_mobile.dart'
    if (dart.library.html) 'razorpay_checkout_web.dart';
