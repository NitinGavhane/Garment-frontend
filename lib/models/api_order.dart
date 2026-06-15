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
  final double discountAmount;
  final double finalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String? shippingAddress;
  final DateTime? estimatedDelivery;
  final DateTime createdAt;
  final List<ApiOrderItem> items;

  const ApiOrder({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.subtotal,
    this.gstAmount = 0,
    this.discountAmount = 0,
    required this.finalAmount,
    this.orderStatus = 'placed',
    this.paymentStatus = 'pending',
    this.shippingAddress,
    this.estimatedDelivery,
    required this.createdAt,
    this.items = const [],
  });

  factory ApiOrder.fromJson(Map<String, dynamic> json) {
    return ApiOrder(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderNumber: json['order_number'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      gstAmount: (json['gst_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      finalAmount: (json['final_amount'] as num).toDouble(),
      orderStatus: json['order_status'] as String? ?? 'placed',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      shippingAddress: json['shipping_address'] as String?,
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => ApiOrderItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
