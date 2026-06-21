import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/wallet_api_service.dart';
import '../../../core/services/referral_api_service.dart';
import '../../../core/services/api_client.dart';
import '../../../core/widgets/app_button.dart';
import '../../../providers/auth_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 0;
  List<Map<String, dynamic>> _transactions = [];
  Map<String, dynamic>? _referralStats;
  List<Map<String, dynamic>> _referralHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final balanceRes = await WalletApiService.getBalance();
      _balance = (balanceRes['balance'] as num).toDouble();

      final txnRes = await WalletApiService.getTransactions();
      _transactions = txnRes.cast<Map<String, dynamic>>();

      final statsRes = await ReferralApiService.getStats();
      _referralStats = statsRes;

      final histRes = await ReferralApiService.getHistory();
      _referralHistory = histRes.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load data';
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

    final referralCode = _referralStats?['referral_code'] as String? ?? user.referralCode ?? '';
    final totalEarnings = (_referralStats?['total_earnings'] as num?)?.toDouble() ?? 0;
    final successfulReferrals = _referralStats?['successful_referrals'] as int? ?? 0;
    final pendingReferrals = _referralStats?['pending_referrals'] as int? ?? 0;
    final totalReferrals = _referralStats?['total_referrals'] as int? ?? successfulReferrals;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards & Wallet', style: AppTextStyles.title),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _walletBalanceCard(),
                    const SizedBox(height: AppDimensions.lg),
                    _referralCard(referralCode),
                    const SizedBox(height: AppDimensions.lg),
                    _statsRow(totalEarnings, successfulReferrals, totalReferrals),
                    const SizedBox(height: AppDimensions.lg),
                    _referralHistorySection(),
                    const SizedBox(height: AppDimensions.lg),
                    _transactionsSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _walletBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.wallet, color: AppColors.white, size: 22),
              const SizedBox(width: 8),
              Text('Wallet Balance',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8))),
            ],
          ),
          const SizedBox(height: 12),
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
    );
  }

  Widget _walletButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }

  Widget _referralCard(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Iconsax.share, color: AppColors.white, size: 28),
                  const SizedBox(height: 8),
                  Text('Refer & Earn',
                      style: AppTextStyles.title.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Share your code & earn rewards',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code,
                    style: AppTextStyles.title.copyWith(
                        color: AppColors.white, letterSpacing: 2),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral code copied!')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.copy,
                        color: AppColors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Share Now',
            onPressed: () {},
            icon: Iconsax.share,
            color: AppColors.white,
            textColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _statsRow(double earnings, int successful, int total) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Iconsax.moneys,
            '₹${earnings.toStringAsFixed(2)}',
            'Referral Earnings',
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            Iconsax.people,
            '$successful',
            'Successful',
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            Iconsax.link,
            '$total',
            'Total Referrals',
            AppColors.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(value,
              style: AppTextStyles.headline2.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _referralHistorySection() {
    if (_referralHistory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Iconsax.people, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text('Referral History', style: AppTextStyles.subtitle),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        ..._referralHistory.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.user,
                        size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['referred_user_name'] as String? ??
                              r['name'] as String? ??
                              'Friend',
                          style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          r['status'] as String? ?? 'Pending',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  if (r['status'] == 'approved' || r['status'] == 'credited')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹${(r['reward_amount'] as num?)?.toStringAsFixed(2) ?? '0'}',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  else if (r['status'] == 'pending')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Pending',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _transactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Iconsax.receipt, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text('Recent Transactions', style: AppTextStyles.subtitle),
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
            child: Center(
              child: Text('No transactions yet',
                  style: AppTextStyles.bodySmall),
            ),
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
                      width: 40,
                      height: 40,
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
}
