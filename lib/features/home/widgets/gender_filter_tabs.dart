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

  static const _tabs = ['ALL', 'MEN', 'WOMEN', 'KIDS'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Row(
        children: _tabs.map((tab) {
          final isActive = selectedGender == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    letterSpacing: 0.05,
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
