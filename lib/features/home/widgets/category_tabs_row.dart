import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class CategoryTabsRow extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onTabChanged;

  const CategoryTabsRow({
    super.key,
    required this.categories,
    this.onTabChanged,
  });

  @override
  State<CategoryTabsRow> createState() => _CategoryTabsRowState();
}

class _CategoryTabsRowState extends State<CategoryTabsRow> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final category = widget.categories[index];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onTabChanged?.call(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.nykaaPink : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.nykaaPink : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
