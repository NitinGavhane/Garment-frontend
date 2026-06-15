import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onShopNow;

  const HeroSection({super.key, this.onShopNow});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _isCtaHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return SizedBox(
          height: isMobile ? 440 : 500,
          child: Container(
            color: AppColors.heroBg,
            child: isMobile ? _buildMobile() : _buildDesktop(),
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: 'https://ucarecdn.com/fe7cee05-e2d6-4fa4-9f50-f152da9bab79/Tshirts_para_Homem__Massimo_Dutti__PTremovebgpreview.png',
              fit: BoxFit.cover,
              height: 500,
              placeholder: (_, __) => Container(
                color: AppColors.heroBg,
                height: 500,
                child: Center(
                  child: Icon(Icons.person, size: 120, color: Colors.grey[300]),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.heroBg,
                height: 500,
                child: Center(
                  child: Icon(Icons.person, size: 120, color: Colors.grey[300]),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(),
                const SizedBox(height: 16),
                Text(
                  'Male Clothes',
                  style: AppTextStyles.heroTitle,
                ),
                const SizedBox(height: 12),
                Text(
                  '30% off Summer Vacation',
                  style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildCtaButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Stack(
      fit: StackFit.loose,
      children: [
        CachedNetworkImage(
          imageUrl: 'https://ucarecdn.com/fe7cee05-e2d6-4fa4-9f50-f152da9bab79/Tshirts_para_Homem__Massimo_Dutti__PTremovebgpreview.png',
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.heroBg),
          errorWidget: (_, __, ___) => Container(color: AppColors.heroBg),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(),
              const SizedBox(height: 8),
              Text(
                'Male Clothes',
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '30% off Summer Vacation',
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              _buildCtaButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 30, height: 1, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          'STYLISH',
          style: AppTextStyles.topBar.copyWith(
            fontSize: 14,
            letterSpacing: 2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 30, height: 1, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _buildCtaButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isCtaHovered = true),
      onExit: (_) => setState(() => _isCtaHovered = false),
      child: GestureDetector(
        onTap: widget.onShopNow,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: _isCtaHovered ? AppColors.textPrimary : Colors.transparent,
            border: Border.all(color: AppColors.textPrimary, width: 2),
          ),
          child: Text(
            'SHOP NOW',
            style: AppTextStyles.ctaButton.copyWith(
              color: _isCtaHovered ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
