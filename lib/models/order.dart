import 'product.dart';
import 'address.dart';
import '../features/orders/models/order_return_replace_request.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  dispatched,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.processing:
        return 2;
      case OrderStatus.dispatched:
        return 3;
      case OrderStatus.outForDelivery:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

class OrderItem {
  final String id;
  final Product product;
  final int quantity;
  final double price;
  final String size;
  final String color;

  const OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.size,
    required this.color,
  });
}

class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double discount;
  final double gst;
  final double cgst;
  final double sgst;
  final double igst;
  final double total;
  final OrderStatus status;
  final Address address;
  final String paymentMethod;
  /// Backend payment_status ('pending' | 'paid' | 'failed' | 'refunded').
  /// The invoice is only offered once this is 'paid'.
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime estimatedDelivery;
  final String? trackingId;
  /// ShipRocket courier AWB once the order is dispatched.
  final String? awbCode;
  final String? courierName;
  final String? shipmentStatus;
  final String? trackingUrl;
  final String? returnReason;
  final String? returnStatus;
  final List<String> returnEvidence;
  final String? returnAdminNote;
  final List<OrderReturnReplaceRequest> returnReplaceRequests;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    this.shipping = 0,
    this.discount = 0,
    this.gst = 0,
    this.cgst = 0,
    this.sgst = 0,
    this.igst = 0,
    required this.total,
    required this.status,
    required this.address,
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    required this.createdAt,
    required this.estimatedDelivery,
    this.trackingId,
    this.awbCode,
    this.courierName,
    this.shipmentStatus,
    this.trackingUrl,
    this.returnReason,
    this.returnStatus,
    this.returnEvidence = const [],
    this.returnAdminNote,
    this.returnReplaceRequests = const [],
  });

  bool get isReturnReplaceEligible => status == OrderStatus.delivered;
}
