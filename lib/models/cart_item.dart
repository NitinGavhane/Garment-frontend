import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  final String selectedSize;
  final String selectedColor;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}

class ApiCartItem {
  final String id;
  final String productId;
  final String? productTitle;
  final String? variantId;
  final String? variantInfo;
  int quantity;
  final double? price;
  final String? imageUrl;

  ApiCartItem({
    required this.id,
    required this.productId,
    this.productTitle,
    this.variantId,
    this.variantInfo,
    required this.quantity,
    this.price,
    this.imageUrl,
  });

  double get totalPrice => (price ?? 0) * quantity;

  factory ApiCartItem.fromJson(Map<String, dynamic> json) {
    return ApiCartItem(
      id: (json['id'] as String?) ?? '',
      productId: (json['product_id'] as String?) ?? '',
      productTitle: json['product_title'] as String?,
      variantId: json['variant_id'] as String?,
      variantInfo: json['variant_info'] as String?,
      quantity: (json['quantity'] as int?) ?? 1,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }
}

class ApiCartResponse {
  final List<ApiCartItem> items;
  final double total;

  const ApiCartResponse({required this.items, required this.total});

  factory ApiCartResponse.fromJson(Map<String, dynamic> json) {
    return ApiCartResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => ApiCartItem.fromJson(i as Map<String, dynamic>))
              .toList() ?? [],
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}
