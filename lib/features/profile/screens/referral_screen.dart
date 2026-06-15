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
                        _referralStat('Earnings',
                            '₹${totalEarnings.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),
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
