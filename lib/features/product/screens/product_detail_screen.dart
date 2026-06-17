import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../models/product.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../checkout/screens/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _fullProduct;
  bool _isLoadingDetail = true;
  String _selectedSize = '';
  String _selectedColor = '';
  final int _quantity = 1;

  Product get _product => _fullProduct ?? widget.product;

  bool get _isWishlisted =>
      context.watch<WishlistProvider>().isWishlisted(_product.id);

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.first;
    _selectedColor = widget.product.colors.first;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await context.read<ProductProvider>().fetchProductDetail(widget.product.id);
      if (mounted) {
        setState(() {
          _fullProduct = detail;
          _isLoadingDetail = false;
          if (detail != null) {
            _selectedSize = detail.sizes.isNotEmpty ? detail.sizes.first : _selectedSize;
            _selectedColor = detail.colors.isNotEmpty ? detail.colors.first : _selectedColor;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
        });
      }
    }
  }

  void _addToCart() {
    context.read<CartProvider>().addToCart(
      product: _product,
      quantity: _quantity,
      selectedSize: _selectedSize,
      selectedColor: _selectedColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _buyNow() {
    final cart = context.read<CartProvider>();
    cart.clear();
    cart.addToCart(
      product: _product,
      quantity: _quantity,
      selectedSize: _selectedSize,
      selectedColor: _selectedColor,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;

    if (_isLoadingDetail) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: _isWishlisted
                          ? AppColors.secondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  onPressed: () {
                    final auth = context.read<AuthProvider>();
                    if (!auth.isLoggedIn) {
                      Navigator.pushNamed(context, '/login');
                      return;
                    }
                    context.read<WishlistProvider>().toggle(_product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isWishlisted
                              ? 'Removed from wishlist'
                              : 'Added to wishlist',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.share, size: 18),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-${product.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: product.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const SizedBox(),
                          errorWidget: (_, __, ___) => const SizedBox(),
                        ),
                        Center(
                          child: Icon(
                            Icons.checkroom_rounded,
                            size: 160,
                            color: AppColors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brand.toUpperCase(),
                                style: AppTextStyles.caption.copyWith(
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.title,
                                style: AppTextStyles.headline3,
                              ),
                            ],
                          ),
                        ),
                        if (product.discountPercentage > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${product.discountPercentage}% OFF',
                              style: AppTextStyles.priceSmall.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: AppColors.rating),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: AppTextStyles.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${product.stock} in stock',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.secondary,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (product.discountPercentage > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '₹${product.originalPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'Includes GST',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.md),
                child: Divider(color: AppColors.divider),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Size', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.sizes.map((size) {
                        final selected = _selectedSize == size;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedSize = size),
                          child: Container(
                            width: 50,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.divider,
                              borderRadius: BorderRadius.circular(10),
                              border: selected
                                  ? Border.all(
                                      color: AppColors.primary, width: 1.5)
                                  : null,
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text('Select Color', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.colors.map((color) {
                        final selected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedColor = color),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.divider,
                              borderRadius: BorderRadius.circular(10),
                              border: selected
                                  ? Border.all(
                                      color: AppColors.primary, width: 1.5)
                                  : null,
                            ),
                            child: Text(
                              color,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.md),
                child: Divider(color: AppColors.divider),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      product.description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: [
                        _infoChip(Iconsax.box, 'SKU: ${product.id.toUpperCase()}'),
                        const SizedBox(width: 12),
                        _infoChip(Iconsax.verify, '100% Original'),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: [
                        _infoChip(Iconsax.clock, 'Free Delivery'),
                        const SizedBox(width: 12),
                        _infoChip(Iconsax.refresh_circle, '7-day Returns'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.md,
                  AppDimensions.md,
                  AppDimensions.md,
                  100,
                ),
                child: SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.md,
          AppDimensions.sm,
          AppDimensions.md,
          AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Consumer<WishlistProvider>(
                builder: (_, wishlist, __) {
                  final isWishlisted = wishlist.isWishlisted(_product.id);
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted ? Iconsax.heart : Iconsax.heart,
                        size: 22,
                        color: isWishlisted
                            ? AppColors.secondary
                            : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        final auth = context.read<AuthProvider>();
                        if (!auth.isLoggedIn) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        wishlist.toggle(_product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWishlisted
                                  ? 'Removed from wishlist'
                                  : 'Added to wishlist',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Add to Cart',
                  onPressed: _addToCart,
                  height: 48,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Buy Now',
                  onPressed: _buyNow,
                  height: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
