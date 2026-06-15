import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxl,
        horizontal: 24,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          if (isMobile) {
            return Column(
              children: [
                _TrustBadge(
                  icon: Icons.local_shipping_outlined,
                  title: 'Free Shipping',
                  description: 'Free shipping on all orders over ₹100',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Divider(color: AppColors.border),
                ),
                _TrustBadge(
                  icon: Icons.support_agent_outlined,
                  title: 'Support 24/7',
                  description: 'We support 24 hours a day, 7 days a week',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Divider(color: AppColors.border),
                ),
                _TrustBadge(
                  icon: Icons.money_off_outlined,
                  title: 'Money Return',
                  description: '30-day money-back guarantee on all items',
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: _TrustBadge(
                icon: Icons.local_shipping_outlined,
                title: 'Free Shipping',
                description: 'Free shipping on all orders over ₹100',
              )),
              SizedBox(
                height: 60,
                child: VerticalDivider(color: AppColors.border, thickness: 1),
              ),
              Expanded(child: _TrustBadge(
                icon: Icons.support_agent_outlined,
                title: 'Support 24/7',
                description: 'We support 24 hours a day, 7 days a week',
              )),
              SizedBox(
                height: 60,
                child: VerticalDivider(color: AppColors.border, thickness: 1),
              ),
              Expanded(child: _TrustBadge(
                icon: Icons.money_off_outlined,
                title: 'Money Return',
                description: '30-day money-back guarantee on all items',
              )),
            ],
          );
        },
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TrustBadge({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textPrimary),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionSubtext.copyWith(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
