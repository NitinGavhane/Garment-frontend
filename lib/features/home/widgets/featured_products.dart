import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../../../models/product.dart';
import '../../product/screens/product_detail_screen.dart';
import '../../product/screens/product_list_screen.dart';

class FeaturedProducts extends StatelessWidget {
  final List<Product> products;
  final String title;

  const FeaturedProducts({
    super.key,
    required this.products,
    this.title = 'Featured Products',
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.title),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductListScreen(),
                  ),
                ),
                child: Text(
                  'See All',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          height: 290,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.sm),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
