import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/product_provider.dart';
import '../../product/screens/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final products = context.watch<ProductProvider>().products;
    final items = products.where((p) => wishlist.wishlistedIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Wishlist (${wishlist.count})',
          style: AppTextStyles.title,
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.heart,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save items you love',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.md),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ProductCard(
                  product: product,
                  isWishlisted: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: product),
                    ),
                  ),
                  onToggleWishlist: () {
                    wishlist.toggle(product.id);
                  },
                );
              },
            ),
    );
  }
}
