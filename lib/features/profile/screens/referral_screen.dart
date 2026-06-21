import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/referral_api_service.dart';
import '../../../core/services/api_client.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/widgets/app_button.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReferral();
  }

  Future<void> _loadReferral() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _stats = await ReferralApiService.getStats();
      final history = await ReferralApiService.getHistory();
      _history = history.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load referral data';
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

    final referralCode = _stats?['referral_code'] as String? ?? user.referralCode ?? '';
    final totalEarnings = (_stats?['total_earnings'] as num?)?.toDouble() ?? 0;
    final successfulReferrals = _stats?['successful_referrals'] as int? ?? 0;
    final pendingReferrals = _stats?['pending_referrals'] as int? ?? 0;
    final totalClicks = _stats?['total_clicks'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Referrals', style: AppTextStyles.title),
      ),
      body: RefreshIndicator(
        onRefresh: _loadReferral,
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
                        gradient: LinearGradient(
                          colors: [AppColors.secondary,
                              AppColors.secondary.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Icon(Iconsax.share,
                              size: 48, color: AppColors.white),
                          const SizedBox(height: 12),
                          Text('Refer & Earn',
                              style: AppTextStyles.headline2.copyWith(
                                  color: AppColors.white)),
                          const SizedBox(height: 4),
                          Text('Share your code & earn rewards',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9))),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    referralCode,
                                    style: AppTextStyles.title.copyWith(
                                        color: AppColors.white,
                                        letterSpacing: 2),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: referralCode));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Referral code copied!')),
                                    );
                                  },
                                  child: const Icon(Icons.copy,
                                      color: AppColors.white, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      children: [
                        _referralStat('Total Referrals',
                            '$successfulReferrals'),
                        const SizedBox(width: 12),
                        _referralStat('Pending',
                            '$pendingReferrals'),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        _referralStat('Earnings',
                            '₹${totalEarnings.toStringAsFixed(2)}'),
                        const SizedBox(width: 12),
                        _referralStat('Total Clicks',
                            '$totalClicks'),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    if (_history.isNotEmpty) ...[
                      Text('Referral History', style: AppTextStyles.subtitle),
                      const SizedBox(height: AppDimensions.sm),
                      ..._history.map((r) => _buildHistoryItem(r)),
                      const SizedBox(height: AppDimensions.lg),
                    ],
                    Text('How it works', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppDimensions.sm),
                    _stepTile('1',
                        'Share your referral code with friends'),
                    _stepTile('2',
                        'They sign up and place their first order'),
                    _stepTile('3', 'You earn referral commission'),
                    const SizedBox(height: AppDimensions.lg),
                    AppButton(
                      label: 'Share Now',
                      onPressed: () {},
                      icon: Iconsax.share,
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(_error!,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error)),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> r) {
    final status = r['status'] as String? ?? 'pending';
    final rewardAmount = (r['reward_amount'] as num?)?.toDouble() ?? 0;
    final purchaseAmount = (r['purchase_amount'] as num?)?.toDouble() ?? 0;
    final productName = r['product_name'] as String?;
    final referredName = r['referred_user_name'] as String? ?? 'A friend';

    return Container(
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
            child: const Icon(Iconsax.user, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName != null
                      ? '$referredName bought $productName'
                      : '$referredName made a purchase',
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                ),
                if (purchaseAmount > 0)
                  Text(
                    'Purchase: ₹${purchaseAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
          if (status == 'approved')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '₹${rewardAmount.toStringAsFixed(2)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (status == 'pending')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Pending',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _referralStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.headline2.copyWith(
                color: AppColors.primary)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _stepTile(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
