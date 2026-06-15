import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class BrandSpotlight extends StatelessWidget {
  final List<Map<String, dynamic>> brands;
  final ValueChanged<Map<String, dynamic>>? onBrandTap;

  const BrandSpotlight({
    super.key,
    required this.brands,
    this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'In The Spotlight',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.nykaaBlack,
                  ),
                ),
              ),
              Text(
                'Hottest brands on offer',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return GestureDetector(
                onTap: () => onBrandTap?.call(brand),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: brand['imageUrl'] ?? '',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 140,
                            color: AppColors.nykaaLightPink,
                            child: const Icon(Icons.store, color: AppColors.nykaaPink, size: 36),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 140,
                            color: AppColors.nykaaLightPink,
                            child: const Icon(Icons.store, color: AppColors.nykaaPink, size: 36),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brand['offer'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.nykaaPink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              brand['name'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.nykaaBlack,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              brand['tag'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
