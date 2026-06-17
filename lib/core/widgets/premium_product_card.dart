import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class PremiumProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double cardWidth;

  const PremiumProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.cardWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.image, size: AppDimensions.iconLg, color: AppColors.primary),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.image, size: AppDimensions.iconLg, color: AppColors.primary),
                        ),
                      ),
                    ),
                    if (product.discountPercentage > 0)
                      Positioned(
                        top: AppDimensions.sm,
                        left: AppDimensions.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.xs + 2,
                            vertical: AppDimensions.xs - 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Text(
                            '-${product.discountPercentage}%',
                            style: AppTextStyles.badge,
                          ),
                        ),
                      ),
                    if (product.rating > 0)
                      Positioned(
                        bottom: AppDimensions.sm,
                        left: AppDimensions.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.xs + 1,
                            vertical: AppDimensions.xs - 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 10, color: AppColors.rating),
                              const SizedBox(width: AppDimensions.xs - 2),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: AppTextStyles.badge.copyWith(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.cardPadding,
                  AppDimensions.sm - 2,
                  AppDimensions.cardPadding,
                  AppDimensions.cardPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.isNotEmpty ? product.brand : product.title,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs - 2),
                    Text(
                      product.brand.isNotEmpty ? product.title : '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs - 2),
                    Row(
                      children: [
                        Text(
                          '\u20B9${product.price.toStringAsFixed(0)}',
                          style: AppTextStyles.priceSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            '\u20B9${product.originalPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.oldPrice.copyWith(fontSize: 9),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
