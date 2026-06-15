import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class AnnouncementBar extends StatelessWidget {
  const AnnouncementBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.topBarHeight,
      color: AppColors.topBarBg,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          if (isMobile) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _TopBarItem(
                    text: 'English',
                    icon: Icons.language,
                    showDropdown: true,
                  ),
                  const SizedBox(width: 20),
                  _TopBarItem(
                    text: 'INR',
                    icon: Icons.attach_money,
                    showDropdown: true,
                  ),
                  const SizedBox(width: 20),
                  _TopBarItem(
                    text: '+1 (555) 123-4567',
                    icon: Icons.phone,
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.topBar,
                  children: [
                    const TextSpan(text: 'Free delivery on order over '),
                    TextSpan(
                      text: '₹200',
                      style: AppTextStyles.topBar.copyWith(
                        color: AppColors.ctaPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBarItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool showDropdown;

  const _TopBarItem({
    required this.text,
    required this.icon,
    this.showDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF555555)),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.topBar),
        if (showDropdown) ...[
          const SizedBox(width: 2),
          const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF555555)),
        ],
      ],
    );
  }
}
