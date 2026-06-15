import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static final List<Map<String, dynamic>> _notifications = [
    {'icon': Iconsax.truck, 'title': 'Order Shipped', 'subtitle': 'Your order ORD-2026-001 has been shipped', 'time': '2 hours ago', 'isNew': true},
    {'icon': Iconsax.discount_shape, 'title': 'Summer Sale!', 'subtitle': 'Get up to 50% off on summer collection', 'time': '5 hours ago', 'isNew': true},
    {'icon': Iconsax.heart, 'title': 'Wishlist Alert', 'subtitle': 'Premium Cotton T-Shirt is back in stock', 'time': '1 day ago', 'isNew': true},
    {'icon': Iconsax.receipt, 'title': 'Order Delivered', 'subtitle': 'Your order ORD-2026-003 was delivered', 'time': '2 days ago', 'isNew': false},
    {'icon': Iconsax.wallet, 'title': 'Refund Processed', 'subtitle': 'Refund of ₹49.99 has been credited', 'time': '3 days ago', 'isNew': false},
    {'icon': Iconsax.star, 'title': 'Review Request', 'subtitle': 'Rate your recent purchase of Silk Evening Gown', 'time': '5 days ago', 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.title),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark All Read', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondary)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: n['isNew'] ? AppColors.primary.withValues(alpha: 0.03) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: n['isNew'] ? Border.all(color: AppColors.primary.withValues(alpha: 0.1)) : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(n['icon'] as IconData, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(n['title'] as String, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
                          if (n['isNew'] as bool)
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(n['subtitle'] as String, style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(n['time'] as String, style: AppTextStyles.caption.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
