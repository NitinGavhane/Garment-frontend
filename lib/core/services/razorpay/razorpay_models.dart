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

  const RazorpayOptions({
    required this.keyId,
    required this.orderId,
    required this.amountPaise,
    required this.currency,
    required this.name,
    this.description,
    this.email,
    this.contact,
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
