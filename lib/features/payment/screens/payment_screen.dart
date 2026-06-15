import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/services/payment_api_service.dart';
import '../../../core/services/api_client.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Google Pay';
  bool _isProcessing = false;
  String? _error;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Google Pay', 'icon': Icons.g_mobiledata, 'isPopular': true},
    {'name': 'PhonePe', 'icon': Icons.phone_android, 'isPopular': true},
    {'name': 'Paytm', 'icon': Icons.account_balance_wallet, 'isPopular': true},
    {'name': 'Credit Card', 'icon': Icons.credit_card, 'isPopular': false},
    {'name': 'Debit Card', 'icon': Icons.credit_card_outlined, 'isPopular': false},
    {'name': 'Net Banking', 'icon': Icons.account_balance, 'isPopular': false},
    {'name': 'Cash on Delivery', 'icon': Icons.money, 'isPopular': false},
  ];

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      await PaymentApiService.createPayment(orderId: widget.orderId);
      final txnId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      await PaymentApiService.verifyPayment(
        orderId: widget.orderId,
        transactionId: txnId,
        paymentMethod: _selectedMethod,
      );

      if (!mounted) return;
      _showSuccessDialog();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Payment failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.success, size: 28),
              ),
              const SizedBox(height: AppDimensions.md),
              Text('Payment Successful!', style: AppTextStyles.headline3),
              const SizedBox(height: AppDimensions.sm),
              Text(
                '₹${widget.amount.toStringAsFixed(2)} paid via $_selectedMethod',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xl),
              AppButton(
                label: 'View Order',
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamedAndRemoveUntil(context, '/orders', (_) => false);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
                },
                child: Text(
                  'Continue Shopping',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment', style: AppTextStyles.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Amount to Pay',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${widget.amount.toStringAsFixed(2)}',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text('Select Payment Method', style: AppTextStyles.subtitle),
          const SizedBox(height: AppDimensions.sm),
          ..._paymentMethods.map((pm) => GestureDetector(
            onTap: () => setState(() => _selectedMethod = pm['name'] as String),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedMethod == pm['name']
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: _selectedMethod == pm['name']
                      ? AppColors.primary
                      : AppColors.border,
                  width: _selectedMethod == pm['name'] ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(pm['icon'] as IconData, size: 24,
                      color: _selectedMethod == pm['name']
                          ? AppColors.primary
                          : AppColors.textHint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(pm['name'] as String, style: AppTextStyles.body),
                  ),
                  if (pm['isPopular'] as bool)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Popular',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.success, fontSize: 9)),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _selectedMethod == pm['name']
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 20,
                    color: _selectedMethod == pm['name']
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ],
              ),
            ),
          )),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          const SizedBox(height: AppDimensions.lg),
          AppButton(
            label: 'Pay ₹${widget.amount.toStringAsFixed(2)}',
            onPressed: _processPayment,
            isLoading: _isProcessing,
          ),
        ],
      ),
    );
  }
}
