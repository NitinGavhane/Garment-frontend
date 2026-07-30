import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class GenderFilterTabs extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String>? onTabChanged;

  const GenderFilterTabs({
    super.key,
    this.selectedGender = 'ALL',
    this.onTabChanged,
  });

  static const _tabs = ['ALL', 'WOMEN', 'MEN', 'KIDS'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: _tabs.map((tab) {
          final isActive = selectedGender == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(tab),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.brandGoldLight : AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
