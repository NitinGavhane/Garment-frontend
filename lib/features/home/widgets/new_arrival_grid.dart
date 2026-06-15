import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/product_card.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../product/screens/product_detail_screen.dart';
import 'section_header.dart';

class NewArrivalGrid extends StatelessWidget {
  final VoidCallback? onWishlistChanged;

  const NewArrivalGrid({super.key, this.onWishlistChanged});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().newProducts.take(8).toList();
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.sectionPadding,
        horizontal: 24,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          int crossAxisCount;
          if (width > 900) {
            crossAxisCount = 5;
          } else if (width > 600) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }

          final childAspectRatio = (width / crossAxisCount - 24) / 320;

          return Column(
            children: [
              SectionHeader(
                title: 'New Arrival',
                subtext: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor.',
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppDimensions.productGridGap,
                  mainAxisSpacing: AppDimensions.productGridGap,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isWishlisted = context.watch<WishlistProvider>().isWishlisted(product.id);
                  return ProductCard(
                    product: product,
                    isWishlisted: isWishlisted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                    onToggleWishlist: () {
                      context.read<WishlistProvider>().toggle(product.id);
                      onWishlistChanged?.call();
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
