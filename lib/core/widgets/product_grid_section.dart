import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import 'premium_product_card.dart';
import 'animations.dart';
import '../../features/product/screens/product_detail_screen.dart';

class ProductGridSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Product> products;
  final VoidCallback? onViewAll;

  const ProductGridSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.products,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md + 4,
        AppDimensions.md,
        AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.sectionLabel.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimensions.xs - 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.sectionSubtext,
                    ),
                  ],
                ],
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: AppTextStyles.ctaButton.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm + 6),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.cardGap - 4),
              itemBuilder: (context, index) {
                final product = products[index];
                return StaggeredEntrance(
                  index: index,
                  child: PremiumProductCard(
                    product: product,
                    cardWidth: 150,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
