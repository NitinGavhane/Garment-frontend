import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../mock/mock_data.dart';
import '../../orders/screens/order_list_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import 'payments_screen.dart';
import 'wallet_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'settings_screen.dart';
import '../../auth/screens/register_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        final user = auth.user;

        if (user == null) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Iconsax.user,
                            size: 40, color: AppColors.textHint),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      Text(
                        'Sign in to your account',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        'Access your orders, wishlist & more',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppDimensions.xxl),
                      AppButton(
                        label: 'Sign In',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/login'),
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Create Account',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        isOutline: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.sm),
                  Stack(
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.fullName.split(' ').map((n) => n[0]).join(),
                            style: AppTextStyles.headline1.copyWith(
                              color: AppColors.white, fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.surface, width: 2),
                            ),
                            child: const Icon(Icons.edit,
                                size: 14, color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(user.fullName, style: AppTextStyles.headline3),
                  const SizedBox(height: 4),
                  Text(user.email, style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statBadge('Orders', '${context.watch<OrderProvider>().count}'),
                      const SizedBox(width: AppDimensions.lg),
                      _statBadge('Wishlist', '${context.watch<WishlistProvider>().count}'),
                      const SizedBox(width: AppDimensions.lg),
                      _statBadge('Wallet', '₹${user.walletBalance.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xxl),
                  ...MockData.profileOptions.map((opt) {
                    final title = opt['title'] as String;
                    String? count;
                    switch (title) {
                      case 'My Orders':
                        count = '${context.watch<OrderProvider>().count}';
                        break;
                      case 'Wishlist':
                        count = '${context.watch<WishlistProvider>().count}';
                        break;
                      case 'Rewards':
                        count = user.walletBalance > 0
                            ? '${user.walletBalance.toStringAsFixed(0)} pts'
                            : null;
                        break;
                    }
                    return ListTile(
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          opt['icon'] as IconData,
                          size: 20, color: AppColors.textPrimary,
                        ),
                      ),
                      title: Text(
                        title,
                        style: AppTextStyles.body,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (count != null)
                            Text(
                              count,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right,
                              color: AppColors.textHint, size: 20),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      onTap: () {
                        Widget screen;
                        switch (title) {
                          case 'My Orders':
                            screen = const OrderListScreen(); break;
                          case 'Wishlist':
                            screen = const WishlistScreen(); break;
                          case 'Rewards':
                            screen = const WalletScreen(); break;
                          case 'Payments':
                            screen = const PaymentsScreen(); break;
                          case 'Manage Account':
                            screen = const SettingsScreen(); break;
                          case 'Help':
                            screen = const HelpScreen(); break;
                          case 'Legal & Policies':
                            _showLegalPolicies(context);
                            return;
                          default:
                            return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => screen),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: AppDimensions.lg),
                  AppButton(
                    label: 'Sign Out',
                    onPressed: () {
                      auth.logout();
                      context.read<CartProvider>().clear();
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    isOutline: true,
                    color: AppColors.error,
                    textColor: AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLegalPolicies(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              Text('Legal & Policies',
                  style: AppTextStyles.headline3),
              const SizedBox(height: AppDimensions.md),
              _legalItem('Terms of Service'),
              _legalItem('Privacy Policy'),
              _legalItem('Return & Refund Policy'),
              _legalItem('Shipping Policy'),
              _legalItem('Cancellation Policy'),
              const SizedBox(height: AppDimensions.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legalItem(String title) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _statBadge(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headline2.copyWith(
            color: AppColors.primary)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
