import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product.dart';
import '../constants/app_colors.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.nykaaLightPink,
                        child: const Center(
                          child: Icon(Icons.image,
                              size: 32,
                              color: AppColors.nykaaPink),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.nykaaLightPink,
                        child: const Center(
                          child: Icon(Icons.image,
                              size: 32,
                              color: AppColors.nykaaPink),
                        ),
                      ),
                    ),
                  ),
                ),
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.nykaaPink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onToggleWishlist,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isWishlisted
                            ? AppColors.nykaaPink
                            : AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.brand,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.nykaaBlack,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            product.title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  '\u20B9${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.nykaaBlack,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product.discountPercentage > 0) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '\u20B9${product.originalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
