import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/order.dart';
import '../widgets/tracking_timeline.dart';
import 'order_return_replace_sheet.dart';
import '../models/order_return_replace_request.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.orderNumber,
          style: AppTextStyles.title,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: TrackingTimeline(currentStatus: order.status),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Details', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                _detailRow('Order Number', order.orderNumber),
                _detailRow('Order Date',
                    dateFormat.format(order.createdAt)),
                _detailRow('Estimated Delivery',
                    dateFormat.format(order.estimatedDelivery)),
                if (order.trackingId != null)
                  _detailRow('Tracking ID', order.trackingId!),
                _detailRow('Payment', order.paymentMethod),
                _detailRow('Status', order.status.label),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item.product.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.checkroom_rounded,
                                size: 26,
                                color:
                                    AppColors.white.withValues(alpha: 0.5)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  style: AppTextStyles.bodySmall
                                      .copyWith(
                                          fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Size: ${item.size} • Color: ${item.color}',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  'Qty: ${item.quantity}',
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
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Address', style: AppTextStyles.subtitle),
                const SizedBox(height: 8),
                Text(
                  '${order.address.fullName} - ${order.address.type}',
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.address.street}, ${order.address.city}, ${order.address.state} - ${order.address.pincode}',
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  order.address.phone,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          if (order.isReturnReplaceEligible)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Return / Replace', style: AppTextStyles.subtitle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(16),
child: OrderReturnReplaceSheet(
                                order: order,
                                type: ReturnReplaceType.returnRequest,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.undo_rounded),
                          label: const Text('Return'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(16),
child: OrderReturnReplaceSheet(
                                order: order,
                                type: ReturnReplaceType.replaceRequest,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.swap_horiz_rounded),
                          label: const Text('Replace'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select items and submit your request.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price Summary', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                _summaryRow('Subtotal',
                    '₹${order.subtotal.toStringAsFixed(2)}'),
                if (order.discount > 0)
                  _summaryRow(
                      'Discount', '-₹${order.discount.toStringAsFixed(2)}'),
                _summaryRow('Shipping',
                    order.shipping == 0 ? 'Free' : '₹${order.shipping.toStringAsFixed(2)}'),
                if (order.gst > 0)
                  _summaryRow('GST',
                      '₹${order.gst.toStringAsFixed(2)}'),
                const Divider(),
                _summaryRow('Total',
                    '₹${order.total.toStringAsFixed(2)}',
                    isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.title
                : AppTextStyles.bodySmall,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.headline3.copyWith(
                    color: AppColors.secondary, fontSize: 18)
                : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
