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

  /// Short label for a product-page chip.
  String get chipLabel {
    if (isAlwaysFree) return 'Free Delivery';
    if (freeAbove != null) return 'Free Delivery over ₹${_amount(freeAbove!)}';
    return 'Delivery ₹${_amount(fee)}';
  }

  /// Headline for the site announcement bar and assurance strips.
  ///
  /// Every storefront delivery promise is built from here, so the app can
  /// never advertise free delivery once the seller configures a charge.
  String get promoLine {
    if (isAlwaysFree) return 'FREE SHIPPING ON ALL ORDERS';
    if (freeAbove != null) {
      return 'FREE SHIPPING ON ORDERS OVER ₹${_amount(freeAbove!)}';
    }
    return 'FLAT ₹${_amount(fee)} DELIVERY ON ALL ORDERS';
  }

  /// Sentence form of [promoLine], for trust badges that read as prose.
  String get promoSentence {
    if (isAlwaysFree) return 'Free shipping on every order';
    if (freeAbove != null) {
      return 'Free shipping on orders over ₹${_amount(freeAbove!)}';
    }
    return 'Flat ₹${_amount(fee)} delivery charge';
  }

  /// Drops the decimals on whole amounts — "₹200", not "₹200.00".
  static String _amount(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
}
