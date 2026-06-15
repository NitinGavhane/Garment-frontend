import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onToggleWishlist;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onToggleWishlist,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    Positioned(
                      top: AppDimensions.sm,
                      left: AppDimensions.sm,
                      child: _buildBadge(),
                    ),
                    if (onToggleWishlist != null)
                      Positioned(
                        top: AppDimensions.sm,
                        right: AppDimensions.sm,
                        child: _buildWishlistButton(),
                      ),
                    if (product.rating > 0)
                      Positioned(
                        bottom: AppDimensions.sm,
                        left: AppDimensions.sm,
                        child: _buildRatingChip(),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.cardPadding,
                AppDimensions.sm,
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
                  const SizedBox(height: AppDimensions.xs),
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
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: AppDimensions.xs),
                        Flexible(
                          child: Text(
                            '\u20B9${product.originalPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.oldPrice.copyWith(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    if (product.discountPercentage > 0) {
      return Container(
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
      );
    }
    if (product.badge.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xs + 2,
          vertical: AppDimensions.xs - 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.badgeNew,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Text(
          product.badge,
          style: AppTextStyles.badge,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildWishlistButton() {
    return GestureDetector(
      onTap: onToggleWishlist,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_border,
          size: AppDimensions.iconXs,
          color: isWishlisted ? AppColors.primary : AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildRatingChip() {
    return Container(
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
          Icon(Icons.star, size: 10, color: AppColors.rating),
          const SizedBox(width: AppDimensions.xs - 2),
          Text(
            product.rating.toStringAsFixed(1),
            style: AppTextStyles.badge.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
