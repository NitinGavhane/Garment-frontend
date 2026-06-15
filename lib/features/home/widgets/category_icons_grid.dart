import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/category.dart' as models;

class CategoryIconsRow extends StatelessWidget {
  final List<models.Category> categories;
  final ValueChanged<models.Category>? onCategoryTap;

  const CategoryIconsRow({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _CategoryIconItem(
            category: cat,
            onTap: () => onCategoryTap?.call(cat),
          );
        },
      ),
    );
  }
}

class _CategoryIconItem extends StatelessWidget {
  final models.Category category;
  final VoidCallback? onTap;

  const _CategoryIconItem({required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                size: 22,
                color: category.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
