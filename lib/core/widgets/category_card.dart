import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.categoryImageSize,
            height: AppDimensions.categoryImageSize,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: isSelected
                  ? Border.all(color: color, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.white : color,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: AppDimensions.categoryImageSize + 8,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
