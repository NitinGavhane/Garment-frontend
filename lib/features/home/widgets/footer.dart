import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DRISTI FASHIONS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.brandGold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fashion That Reflects Your Personality',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.brandGoldLight.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          const _FooterLinksSection(
            title: 'SHOP',
            links: ['Women', 'Men', 'Kids', 'Home', 'Brands'],
          ),
          const SizedBox(height: 16),
          const _FooterLinksSection(
            title: 'HELP',
            links: ['About Us', 'Shipping & Return Policy', 'Help Center', 'Terms & Conditions', 'Privacy Policy'],
          ),
          const SizedBox(height: 16),
          const _FooterLinksSection(
            title: 'FOLLOW US',
            links: ['Instagram', 'Facebook', 'Twitter', 'YouTube'],
          ),
          const SizedBox(height: 16),
          Text(
            'For any help, call us at 1800-266-3333',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.brandGoldLight.withValues(alpha: 0.7)),
          ),
          Text(
            'Mon-Sat: 10 AM - 10 PM, Sun: 10 AM - 7 PM',
            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.brandGoldLight.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.brandGoldLight.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 12),
          Text(
            '© 2026 Dristi Fashions. All Rights Reserved.',
            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.brandGoldLight.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

class _FooterLinksSection extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterLinksSection({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.brandGoldLight,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 20,
          runSpacing: 4,
          children: links.map((link) => Text(
            link,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.brandGoldLight.withValues(alpha: 0.7)),
          )).toList(),
        ),
      ],
    );
  }
}
