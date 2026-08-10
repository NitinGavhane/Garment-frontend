import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/order_api_service.dart';
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
          if (order.awbCode != null || order.courierName != null ||
              order.shipmentStatus != null)
            ...[
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
                    Text('Tracking', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    if (order.courierName != null)
                      _detailRow('Courier', order.courierName!),
                    if (order.awbCode != null)
                      _detailRow('AWB No.', order.awbCode!),
                    if (order.shipmentStatus != null)
                      _detailRow('Status', order.shipmentStatus!),
                    if (order.trackingUrl != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => launchUrl(
                            Uri.parse(order.trackingUrl!),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: const Icon(Icons.local_shipping_rounded),
                          label: const Text('Track on ShipRocket'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
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
          if (order.isReturnReplaceEligible || order.returnStatus != null)
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
                  if (order.returnStatus != null) ...[
                    _returnStatusLabel(order.returnStatus!),
                    if (order.returnReason != null) ...[
                      const SizedBox(height: 4),
                      Text('Reason: ${order.returnReason}',
                          style: AppTextStyles.bodySmall),
                    ],
                    if (order.returnStatus == 'rejected' &&
                        order.returnAdminNote != null) ...[
                      const SizedBox(height: 4),
                      Text('Note: ${order.returnAdminNote}',
                          style: AppTextStyles.bodySmall),
                    ],
                    if (order.returnEvidence.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.returnEvidence.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              order.returnEvidence[i],
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                  if (order.isReturnReplaceEligible &&
                      order.returnStatus == null) ...[
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
                // Inter-state orders carry IGST; intra-state orders split into
                // CGST + SGST (legacy orders fall back to an even CGST/SGST split).
                if (order.gst > 0) ...[
                  if (order.igst > 0)
                    _summaryRow('IGST',
                        '₹${order.igst.toStringAsFixed(2)}')
                  else ...[
                    _summaryRow('CGST',
                        '₹${(order.cgst > 0 ? order.cgst : order.gst / 2).toStringAsFixed(2)}'),
                    _summaryRow('SGST',
                        '₹${(order.sgst > 0 ? order.sgst : order.gst / 2).toStringAsFixed(2)}'),
                  ],
                ],
                const Divider(),
                _summaryRow('Total',
                    '₹${order.total.toStringAsFixed(2)}',
                    isTotal: true),
              ],
            ),
          ),
          if (order.paymentStatus == 'paid') ...[
            const SizedBox(height: AppDimensions.md),
            _InvoiceDownloadButton(order: order),
          ],
          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }

  Widget _returnStatusLabel(String status) {
    final (label, color) = switch (status) {
      'approved' => ('Approved — pickup OTP sent to your phone/email', AppColors.success),
      'rejected' => ('Not approved', AppColors.error),
      'picked_up' => ('Picked up — refund/replacement in progress', AppColors.success),
      'requested' => ('Return requested', AppColors.warning),
      'replace_requested' => ('Replacement requested', AppColors.warning),
      _ => ('Request submitted', AppColors.warning),
    };
    return Text(
      label,
      style: AppTextStyles.bodySmall.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _detailRow(String label, String value) {    return Padding(
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

/// Downloads the order's GST invoice PDF from the backend and hands it to the
/// platform: on Android the system save/share sheet, on web a file download.
class _InvoiceDownloadButton extends StatefulWidget {
  final Order order;

  const _InvoiceDownloadButton({required this.order});

  @override
  State<_InvoiceDownloadButton> createState() => _InvoiceDownloadButtonState();
}

class _InvoiceDownloadButtonState extends State<_InvoiceDownloadButton> {
  bool _busy = false;

  Future<void> _download() async {
    setState(() => _busy = true);
    try {
      final bytes = await OrderApiService.downloadInvoice(widget.order.id);
      // sharePdf opens the OS save/share sheet on mobile and triggers a
      // download in the browser on web, so one call covers both platforms.
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'Invoice-${widget.order.orderNumber}.pdf',
      );
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Could not download the invoice. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _busy ? null : _download,
        icon: _busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download_rounded, size: 20),
        label: Text(_busy ? 'Preparing invoice…' : 'Download Invoice'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ),
    );
  }
}
