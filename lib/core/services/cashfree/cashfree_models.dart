// Shared types for the platform-specific Cashfree checkout implementations.

class CashfreeOptions {
  /// Payment session id from POST /payments/create; the gateway opens a
  /// checkout for the order bound to this session.
  final String paymentSessionId;

  /// Merchant order id returned alongside the session (`cashfree_order_id`).
  /// The gateway echoes it back on completion so the order's status can be
  /// verified server-side.
  final String cashfreeOrderId;

  /// Gateway environment the order was created in ("sandbox" or "production").
  final String cashfreeEnvironment;

  /// Where the customer is sent back to after paying on Cashfree's hosted
  /// page. The backend fills this in; used by the web build's redirect flow.
  final String? returnUrl;

  const CashfreeOptions({
    required this.paymentSessionId,
    required this.cashfreeOrderId,
    required this.cashfreeEnvironment,
    this.returnUrl,
  });
}

class CashfreeSuccess {
  /// Merchant order id the gateway reported as completing.
  final String cashfreeOrderId;

  const CashfreeSuccess({required this.cashfreeOrderId});
}

typedef CashfreeSuccessCallback = void Function(CashfreeSuccess result);
typedef CashfreeErrorCallback = void Function(String message);