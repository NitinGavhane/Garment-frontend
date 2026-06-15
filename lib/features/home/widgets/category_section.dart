import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/category_card.dart';
import '../../../models/category.dart';
import '../../product/screens/product_list_screen.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: AppTextStyles.title,
              ),
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
          height: AppDimensions.categoryImageSize + 30,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.md),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryCard(
                title: cat.name,
                icon: cat.icon,
                color: cat.color,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(category: cat),
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
