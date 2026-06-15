import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onReturn;
  final VoidCallback? onReplace;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onReturn,
    this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.label.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: item.product.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.checkroom_rounded,
                        size: 20,
                        color: AppColors.white.withValues(alpha: 0.5)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: ${item.quantity} • ${item.size}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.priceSmall,
                  ),
                ],
              ),
            )),
            if (order.items.length > 2)
              Text(
                '+${order.items.length - 2} more items',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${dateFormat.format(order.createdAt)}',
                  style: AppTextStyles.caption,
                ),
                Text(
                  '₹${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.priceSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (onReturn != null || onReplace != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onReturn != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReturn,
                        icon: const Icon(Icons.undo_rounded, size: 16),
                        label: const Text('Return',
                            style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  if (onReturn != null && onReplace != null)
                    const SizedBox(width: 8),
                  if (onReplace != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReplace,
                        icon: const Icon(Icons.swap_horiz_rounded,
                            size: 16),
                        label: const Text('Replace',
                            style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.placed:
      case OrderStatus.confirmed:
      case OrderStatus.processing:
        return AppColors.warning;
      case OrderStatus.dispatched:
      case OrderStatus.outForDelivery:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }
}
