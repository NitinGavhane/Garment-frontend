import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/wallet_api_service.dart';
import '../../../core/services/api_client.dart';
import '../../../providers/auth_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Map<String, dynamic>> _transactions = [];
  double _balance = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final balanceRes = await WalletApiService.getBalance();
      _balance = (balanceRes['balance'] as num).toDouble();
      final txns = await WalletApiService.getTransactions();
      _transactions = txns.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load wallet data';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet', style: AppTextStyles.title),
      ),
      body: RefreshIndicator(
        onRefresh: _loadWallet,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wallet Balance',
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: 8),
                          Text('₹${_balance.toStringAsFixed(2)}',
                              style: AppTextStyles.displayLarge.copyWith(
                                  color: AppColors.white)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _walletButton(Iconsax.add, 'Add Money'),
                              const SizedBox(width: 12),
                              _walletButton(Iconsax.send_sqaure_2, 'Send'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Transactions',
                            style: AppTextStyles.subtitle),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error)),
                      )
                    else if (_transactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('No transactions yet',
                            style: AppTextStyles.bodySmall),
                      )
                    else
                      ..._transactions.map((t) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: (t['transaction_type'] == 'credit'
                                        ? AppColors.success
                                        : AppColors.error)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                t['transaction_type'] == 'credit'
                                    ? Iconsax.arrow_down
                                    : Iconsax.arrow_up,
                                size: 20,
                                color: t['transaction_type'] == 'credit'
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['description'] as String? ??
                                        t['source'] as String? ??
                                        'Transaction',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    _formatDate(t['created_at'] as String),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${t['transaction_type'] == 'credit' ? '+' : '-'}₹${(t['amount'] as num).toStringAsFixed(2)}',
                              style: AppTextStyles.priceSmall.copyWith(
                                color: t['transaction_type'] == 'credit'
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      )),
                  ],
                ),
              ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  Widget _walletButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}
