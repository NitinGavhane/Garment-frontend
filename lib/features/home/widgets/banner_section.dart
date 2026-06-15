import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class BannerSection extends StatelessWidget {
  final String title;
  final List<String> imageUrls;

  const BannerSection({
    super.key,
    required this.title,
    this.imageUrls = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.nykaaBlack,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    width: 135,
                    height: 240,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 135,
                      height: 240,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.broken_image, color: AppColors.textHint),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 135,
                      height: 240,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.broken_image, color: AppColors.textHint),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
