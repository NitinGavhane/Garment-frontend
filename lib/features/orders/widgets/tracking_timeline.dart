import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/order.dart';

class TrackingTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const TrackingTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    if (currentStatus == OrderStatus.cancelled) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, color: AppColors.error, size: 28),
              const SizedBox(width: 12),
              Text(
                'Order Cancelled',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final steps = [
      const _StepData('Order\nPlaced', Icons.receipt_long),
      const _StepData('Confirmed', Icons.verified),
      const _StepData('Processing', Icons.inventory_2),
      const _StepData('Dispatched', Icons.local_shipping),
      const _StepData('Out for\nDelivery', Icons.delivery_dining),
      const _StepData('Delivered', Icons.check_circle),
    ];

    final currentStep = currentStatus.stepIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Status', style: AppTextStyles.subtitle),
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(steps.length, (index) {
                final isCompleted = index <= currentStep;
                final isCurrent = index == currentStep;
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.border,
                          shape: BoxShape.circle,
                          border: isCurrent
                              ? Border.all(
                                  color: AppColors.primary, width: 3)
                              : null,
                        ),
                        child: Icon(
                          steps[index].icon,
                          size: 16,
                          color: isCompleted
                              ? AppColors.white
                              : AppColors.textHint,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          width: 2,
                          height: 24,
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index].label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontWeight:
                              isCurrent ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final String label;
  final IconData icon;

  const _StepData(this.label, this.icon);
}
