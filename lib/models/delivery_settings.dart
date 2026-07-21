class DeliverySettings {
  final bool enabled;
  final double fee;
  final double? freeAbove;

  const DeliverySettings({
    this.enabled = false,
    this.fee = 0.0,
    this.freeAbove,
  });

  factory DeliverySettings.fromJson(Map<String, dynamic> json) {
    return DeliverySettings(
      enabled: json['enabled'] as bool? ?? false,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      freeAbove: (json['free_above'] as num?)?.toDouble(),
    );
  }

  /// Delivery charge for an order with this [subtotal]. Mirrors the backend
  /// rule exactly so the checkout total matches what will be charged.
  double feeFor(double subtotal) {
    if (!enabled || fee <= 0) return 0.0;
    if (freeAbove != null && subtotal >= freeAbove!) return 0.0;
    return fee;
  }

  /// True when delivery is free for every order (no charge configured).
  bool get isAlwaysFree => !enabled || fee <= 0;
}
