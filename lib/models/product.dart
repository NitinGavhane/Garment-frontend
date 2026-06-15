import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'cart_item.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String brand;
  final String category;
  final String categoryId;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final int discountPercentage;
  final List<String> sizes;
  final List<String> colors;
  final bool isFeatured;
  final bool isNew;
  final String badge;
  final int stock;
  final String imageUrl;
  final String gender;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.brand,
    required this.category,
    required this.categoryId,
    required this.price,
    required this.originalPrice,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.discountPercentage = 0,
    this.sizes = const ['S', 'M', 'L', 'XL', 'XXL'],
    this.colors = const ['Black', 'White', 'Blue'],
    this.isFeatured = false,
    this.isNew = false,
    this.badge = '',
    this.stock = 50,
    this.imageUrl = '',
    this.gender = '',
  });

  factory Product.fromApiProduct(ApiProduct apiProduct) {
    return Product(
      id: apiProduct.id,
      title: apiProduct.title,
      description: apiProduct.description ?? '',
      brand: apiProduct.brand ?? '',
      category: '',
      categoryId: apiProduct.categoryId,
      price: apiProduct.displayPrice,
      originalPrice: apiProduct.originalPrice,
      discountPercentage: apiProduct.discountPrice != null
          ? ((apiProduct.price - apiProduct.discountPrice!) / apiProduct.price * 100).round()
          : 0,
      sizes: apiProduct.availableSizes,
      colors: apiProduct.availableColors,
      isFeatured: apiProduct.featured,
      stock: apiProduct.stock,
      imageUrl: apiProduct.primaryImage ?? '',
      gender: apiProduct.gender,
    );
  }

  factory Product.fromApiCartItem(ApiCartItem item) {
    return Product(
      id: item.productId,
      title: item.productTitle ?? '',
      description: '',
      brand: '',
      category: '',
      categoryId: '',
      price: item.price ?? 0,
      originalPrice: item.price ?? 0,
      imageUrl: item.imageUrl ?? '',
    );
  }

  List<Color> get gradientColors {
    final idx = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final i = idx % AppColors.productGradients.length;
    final next = (i + 1) % AppColors.productGradients.length;
    return [AppColors.productGradients[i], AppColors.productGradients[next]];
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? brand,
    String? category,
    String? categoryId,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    int? discountPercentage,
    List<String>? sizes,
    List<String>? colors,
    bool? isFeatured,
    bool? isNew,
    String? badge,
    int? stock,
    String? imageUrl,
    String? gender,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      badge: badge ?? this.badge,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
    );
  }
}

class ApiProductVariant {
  final String id;
  final String? size;
  final String? color;
  final int stock;
  final double? price;

  const ApiProductVariant({
    required this.id,
    this.size,
    this.color,
    required this.stock,
    this.price,
  });

  factory ApiProductVariant.fromJson(Map<String, dynamic> json) {
    return ApiProductVariant(
      id: json['id'] as String,
      size: json['size'] as String?,
      color: json['color'] as String?,
      stock: json['stock'] as int,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

class ApiProductImage {
  final String id;
  final String imageUrl;
  final bool isPrimary;

  const ApiProductImage({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
  });

  factory ApiProductImage.fromJson(Map<String, dynamic> json) {
    return ApiProductImage(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool,
    );
  }
}

class ApiProduct {
  final String id;
  final String categoryId;
  final String title;
  final String? description;
  final String? brand;
  final String sku;
  final double price;
  final double? discountPrice;
  final double gstPercentage;
  final int stock;
  final bool featured;
  final bool isActive;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ApiProductVariant> variants;
  final List<ApiProductImage> images;

  const ApiProduct({
    required this.id,
    required this.categoryId,
    required this.title,
    this.description,
    this.brand,
    required this.sku,
    required this.price,
    this.discountPrice,
    this.gstPercentage = 18.0,
    required this.stock,
    this.featured = false,
    this.isActive = true,
    this.gender = '',
    required this.createdAt,
    required this.updatedAt,
    this.variants = const [],
    this.images = const [],
  });

  String? get primaryImage =>
      images.where((i) => i.isPrimary).firstOrNull?.imageUrl ??
      images.firstOrNull?.imageUrl;

  List<String> get availableSizes =>
      variants.where((v) => v.size != null).map((v) => v.size!).toSet().toList();

  List<String> get availableColors =>
      variants.where((v) => v.color != null).map((v) => v.color!).toSet().toList();

  double get displayPrice => discountPrice ?? price;

  double get originalPrice => price;

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      gstPercentage: (json['gst_percentage'] as num?)?.toDouble() ?? 18.0,
      stock: json['stock'] as int,
      featured: json['featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      gender: json['gender'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ApiProductVariant.fromJson(v as Map<String, dynamic>))
              .toList() ?? [],
      images: (json['images'] as List<dynamic>?)
              ?.map((i) => ApiProductImage.fromJson(i as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}

class ApiProductListItem {
  final String id;
  final String title;
  final String sku;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool featured;
  final bool isActive;
  final String gender;
  final String? categoryId;
  final String? categoryName;
  final String? primaryImage;

  const ApiProductListItem({
    required this.id,
    required this.title,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.featured = false,
    this.isActive = true,
    this.gender = '',
    this.categoryId,
    this.categoryName,
    this.primaryImage,
  });

  double get displayPrice => discountPrice ?? price;

  factory ApiProductListItem.fromJson(Map<String, dynamic> json) {
    return ApiProductListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      stock: json['stock'] as int,
      featured: json['featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      gender: json['gender'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      primaryImage: json['primary_image'] as String?,
    );
  }
}
