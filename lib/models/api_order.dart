class ApiOrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? variantId;
  final int quantity;
  final double price;

  const ApiOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.variantId,
    required this.quantity,
    required this.price,
  });

  factory ApiOrderItem.fromJson(Map<String, dynamic> json) {
    return ApiOrderItem(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      variantId: json['variant_id'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class ApiOrder {
  final String id;
  final String userId;
  final String orderNumber;
  final double subtotal;
  final double gstAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final double discountAmount;
  final double deliveryFee;
  final double finalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String? shippingAddress;
  final String? returnReason;
  final String? returnStatus;
  final List<String> returnEvidence;
  final String? returnAdminNote;
  final DateTime? dispatchedAt;
  final DateTime? deliveredAt;
  final DateTime? estimatedDelivery;
  final DateTime createdAt;
  // ShipRocket courier tracking (populated once the order is dispatched).
  final String? awbCode;
  final String? courierName;
  final String? shipmentStatus;
  final String? trackingUrl;
  final List<ApiOrderItem> items;

  const ApiOrder({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.subtotal,
    this.gstAmount = 0,
    this.cgstAmount = 0,
    this.sgstAmount = 0,
    this.igstAmount = 0,
    this.discountAmount = 0,
    this.deliveryFee = 0,
    required this.finalAmount,
    this.orderStatus = 'placed',
    this.paymentStatus = 'pending',
    this.shippingAddress,
    this.returnReason,
    this.returnStatus,
    this.returnEvidence = const [],
    this.returnAdminNote,
    this.dispatchedAt,
    this.deliveredAt,
    this.estimatedDelivery,
    required this.createdAt,
    this.awbCode,
    this.courierName,
    this.shipmentStatus,
    this.trackingUrl,
    this.items = const [],
  });

  factory ApiOrder.fromJson(Map<String, dynamic> json) {
    return ApiOrder(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderNumber: json['order_number'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      gstAmount: (json['gst_amount'] as num?)?.toDouble() ?? 0,
      cgstAmount: (json['cgst_amount'] as num?)?.toDouble() ?? ((json['gst_amount'] as num?)?.toDouble() ?? 0) / 2,
      sgstAmount: (json['sgst_amount'] as num?)?.toDouble() ?? ((json['gst_amount'] as num?)?.toDouble() ?? 0) / 2,
      igstAmount: (json['igst_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      finalAmount: (json['final_amount'] as num).toDouble(),
      orderStatus: json['order_status'] as String? ?? 'placed',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      shippingAddress: json['shipping_address'] as String?,
      returnReason: json['return_reason'] as String?,
      returnStatus: json['return_status'] as String?,
      returnEvidence: (json['return_evidence'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      returnAdminNote: json['return_admin_note'] as String?,
      dispatchedAt: json['dispatched_at'] != null
          ? DateTime.tryParse(json['dispatched_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.tryParse(json['delivered_at'] as String)
          : null,
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      awbCode: json['awb_code'] as String?,
      courierName: json['courier_name'] as String?,
      shipmentStatus: json['shipment_status'] as String?,
      trackingUrl: json['tracking_url'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => ApiOrderItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
