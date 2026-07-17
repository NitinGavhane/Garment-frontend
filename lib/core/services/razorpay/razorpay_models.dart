// Shared types for the platform-specific Razorpay checkout implementations.

class RazorpayOptions {
  final String keyId;
  final String orderId; // Razorpay order id from POST /payments/create
  final int amountPaise;
  final String currency;
  final String name;
  final String? description;
  final String? email;
  final String? contact;

  /// The method the buyer chose on our screen (upi/card/netbanking/wallet),
  /// used to open the gateway sheet on that method instead of its menu. The
  /// buyer can still switch inside the sheet, which is why the backend re-reads
  /// the real method when verifying.
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
