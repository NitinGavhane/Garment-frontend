import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class FloneFooter extends StatelessWidget {
  const FloneFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final isTablet = constraints.maxWidth < 900;

                if (isMobile) {
                  return Column(
                    children: [
                      _LogoColumn(),
                      const SizedBox(height: 32),
                      _FooterColumn(
                        title: 'ABOUT US',
                        links: ['About us', 'Store location', 'Contact', 'Orders tracking'],
                      ),
                      const SizedBox(height: 24),
                      _FooterColumn(
                        title: 'USEFUL LINKS',
                        links: ['Returns', 'Support Policy', 'Size guide', 'FAQs'],
                      ),
                      const SizedBox(height: 24),
                      _FooterColumn(
                        title: 'FOLLOW US',
                        links: ['Facebook', 'Twitter', 'Instagram', 'Youtube'],
                      ),
                      const SizedBox(height: 24),
                      _SubscribeColumn(),
                    ],
                  );
                }

                if (isTablet) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _LogoColumn()),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _FooterColumn(
                              title: 'ABOUT US',
                              links: ['About us', 'Store location', 'Contact', 'Orders tracking'],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _FooterColumn(
                              title: 'USEFUL LINKS',
                              links: ['Returns', 'Support Policy', 'Size guide', 'FAQs'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _FooterColumn(
                              title: 'FOLLOW US',
                              links: ['Facebook', 'Twitter', 'Instagram', 'Youtube'],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _SubscribeColumn()),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _LogoColumn()),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _FooterColumn(
                        title: 'ABOUT US',
                        links: ['About us', 'Store location', 'Contact', 'Orders tracking'],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _FooterColumn(
                        title: 'USEFUL LINKS',
                        links: ['Returns', 'Support Policy', 'Size guide', 'FAQs'],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _FooterColumn(
                        title: 'FOLLOW US',
                        links: ['Facebook', 'Twitter', 'Instagram', 'Youtube'],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: _SubscribeColumn()),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Divider(color: AppColors.border, thickness: 1),
          const SizedBox(height: 20),
          Text(
            '© 2026 Flone. All rights reserved.',
            style: AppTextStyles.footerLink.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flone.',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          style: AppTextStyles.footerLink.copyWith(
            height: 1.6,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.footerHeading),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(link, style: AppTextStyles.footerLink),
        )),
      ],
    );
  }
}

class _SubscribeColumn extends StatefulWidget {
  @override
  State<_SubscribeColumn> createState() => _SubscribeColumnState();
}

class _SubscribeColumnState extends State<_SubscribeColumn> {
  bool _isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUBSCRIBE', style: AppTextStyles.footerHeading),
        const SizedBox(height: 12),
        Text(
          'Subscribe to our newsletter to get updates on new arrivals and exclusive sales.',
          style: AppTextStyles.footerLink.copyWith(height: 1.6),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Your email address',
                    hintStyle: AppTextStyles.footerLink.copyWith(
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: AppTextStyles.footerLink,
                ),
              ),
              MouseRegion(
                onEnter: (_) => setState(() => _isButtonHovered = true),
                onExit: (_) => setState(() => _isButtonHovered = false),
                child: GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _isButtonHovered
                          ? AppColors.textPrimary
                          : Colors.transparent,
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'SUBSCRIBE',
                      style: AppTextStyles.ctaButton.copyWith(
                        fontSize: 11,
                        color: _isButtonHovered
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
