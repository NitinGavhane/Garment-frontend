import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments', style: AppTextStyles.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wallet Balance',
                    style: TextStyle(color: AppColors.white, fontSize: 13)),
                SizedBox(height: 8),
                Text('₹0.00',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text('Saved Cards', style: AppTextStyles.subtitle),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.card_add, color: AppColors.textHint),
                const SizedBox(width: 12),
                Text('Add a new card', style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          Text('Payment History', style: AppTextStyles.subtitle),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('No payment history yet',
                  style: AppTextStyles.bodySmall),
            ),
          ),
        ],
      ),
    );
  }
}
