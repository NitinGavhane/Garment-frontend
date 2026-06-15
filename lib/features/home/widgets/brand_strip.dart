import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class BrandStrip extends StatelessWidget {
  const BrandStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          _PrimaryStrip(),
          _SecondaryStrip(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PrimaryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFbd003b), Color(0xFFe8144d)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _BrandItem('LIBAS'),
          _BrandItem('RARE RABBIT'),
          _BrandItem('LIBAS'),
        ],
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final String name;

  const _BrandItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 20),
          Container(width: 1, height: 16, color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

class _SecondaryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: AppColors.surfaceContainer,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _SecondaryBrand('Miraggio'),
          _SecondaryBrand('Jack & Jones'),
          _SecondaryBrand('Timex'),
          _SecondaryBrand('Miraggio'),
        ],
      ),
    );
  }
}

class _SecondaryBrand extends StatelessWidget {
  final String name;

  const _SecondaryBrand(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 18),
          Container(width: 1, height: 12, color: AppColors.outlineVariant),
        ],
      ),
    );
  }
}
