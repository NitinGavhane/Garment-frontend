import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class PolicySection {
  const PolicySection({
    required this.heading,
    this.paragraph,
    this.bullets = const [],
    this.subBullets = const [],
  });

  final String heading;
  final String? paragraph;
  final List<String> bullets;
  final List<String> subBullets;
}

class ContactDetail {
  const ContactDetail({
    required this.label,
    required this.value,
    this.icon = Icons.info_outline,
  });

  final String label;
  final String value;
  final IconData icon;
}

/// Shared layout for legal / policy pages (Privacy, Terms, Loyalty programme).
class PolicyScaffold extends StatelessWidget {
  const PolicyScaffold({
    super.key,
    required this.title,
    required this.intro,
    required this.sections,
    this.contactHeading,
    this.contactIntro,
    this.contactDetails = const [],
    this.securityNotice,
  });

  final String title;
  final String intro;
  final List<PolicySection> sections;

  final String? contactHeading;
  final String? contactIntro;
  final List<ContactDetail> contactDetails;

  /// Optional highlighted safety note rendered at the bottom.
  final String? securityNotice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.brandGoldLight)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intro,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.lg),
            for (final section in sections) _SectionCard(section: section),
            if (contactHeading != null) ...[
              const SizedBox(height: AppDimensions.md),
              _ContactCard(
                heading: contactHeading!,
                intro: contactIntro,
                details: contactDetails,
              ),
            ],
            if (securityNotice != null) ...[
              const SizedBox(height: AppDimensions.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  securityNotice!,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6, color: AppColors.brandGoldLight),
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.xxl),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final PolicySection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          if (section.paragraph != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              section.paragraph!,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6, color: AppColors.textSecondary),
            ),
          ],
          if (section.bullets.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.sm),
            for (final bullet in section.bullets) _Bullet(text: bullet, nested: false),
            for (final sub in section.subBullets) _Bullet(text: sub, nested: true),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.nested});

  final String text;
  final bool nested;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: nested ? 16 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.festiveGold,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.6,
                color: AppColors.textSecondary,
                fontWeight: nested ? FontWeight.w400 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.heading,
    required this.intro,
    required this.details,
  });

  final String heading;
  final String? intro;
  final List<ContactDetail> details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          if (intro != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              intro!,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6, color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: AppDimensions.sm),
          for (final detail in details)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(detail.icon, size: 16, color: AppColors.brandGoldDark),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6, color: AppColors.textSecondary),
                        children: [
                          TextSpan(text: '${detail.label}: ', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          TextSpan(text: detail.value),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}