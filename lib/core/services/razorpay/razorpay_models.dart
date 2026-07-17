// Shared types for the platform-specific Razorpay checkout implementations.

/// Razorpay's own payment-method keys. When the buyer has already picked a
/// method on our screen we restrict the gateway sheet to just that one (enable
/// it, disable the rest) so it opens straight onto it instead of re-showing the
/// full "menu" of every option. Only codes in this set are safe to restrict on;
/// an admin-defined code we don't recognise falls back to prefill-only.
const List<String> kRazorpayMethodKeys = [
  'upi',
  'card',
  'netbanking',
  'wallet',
  'emi',
  'paylater',
  'cardless_emi',
  'banktransfer',
  'qr',
];

class RazorpayOptions {
  final String keyId;
  final String orderId; // Razorpay order id from POST /payments/create
  final int amountPaise;
  final String currency;
  final String name;
  final String? description;
  final String? email;
  final String? contact;

  /// The method the buyer chose on our screen (upi/card/netbanking/wallet).
  /// When it is one of [kRazorpayMethodKeys] the gateway sheet is restricted to
  /// just that method so it opens directly on it; an unrecognised (admin-added)
  /// code only prefills, leaving the full menu. The backend still re-reads the
  /// method actually used when verifying, as a safety net.
  final String? method;

  const RazorpayOptions({
    required this.keyId,
    required this.orderId,
    required this.amountPaise,
    required this.currency,
    required this.name,
    this.description,
    this.email,
    this.contact,
    this.method,
  });
}

class RazorpaySuccess {
  final String paymentId;
  final String orderId;
  final String signature;

  const RazorpaySuccess({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });
}

typedef RazorpaySuccessCallback = void Function(RazorpaySuccess result);
typedef RazorpayErrorCallback = void Function(String message);
