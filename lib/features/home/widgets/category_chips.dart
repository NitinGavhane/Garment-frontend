import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/category.dart' as models;

class CategoryChips extends StatelessWidget {
  final List<models.Category> categories;
  final ValueChanged<models.Category>? onCategoryTap;

  const CategoryChips({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 82,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () => onCategoryTap?.call(cat),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cat.color.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: cat.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: CachedNetworkImage(
                              imageUrl: cat.imageUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Icon(cat.icon, color: cat.color, size: 24),
                              errorWidget: (_, __, ___) => Icon(cat.icon, color: cat.color, size: 24),
                            ),
                          )
                        : Icon(cat.icon, color: cat.color, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.name,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
