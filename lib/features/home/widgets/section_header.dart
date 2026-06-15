import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtext;
  final bool hasDashes;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtext,
    this.hasDashes = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDashes)
          Text(
            '— $title —',
            style: AppTextStyles.sectionHeading.copyWith(
              fontSize: 22,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          )
        else ...[
          Text(
            title,
            style: AppTextStyles.sectionHeading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 2,
            color: AppColors.textPrimary,
          ),
        ],
        if (subtext != null) ...[
          const SizedBox(height: 6),
          Text(
            subtext!,
            style: AppTextStyles.sectionSubtext,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
