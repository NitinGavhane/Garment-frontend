import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/constants/app_colors.dart';

class NykaaTopBar extends StatelessWidget {
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;

  const NykaaTopBar({
    super.key,
    this.cartCount = 0,
    this.onSearchTap,
    this.onWishlistTap,
    this.onCartTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 28,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            _IconButton(
              icon: Icons.notifications_outlined,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 4),
            _IconButton(
              icon: Icons.favorite_outline,
              onTap: onWishlistTap,
            ),
            const SizedBox(width: 4),
            badges.Badge(
              showBadge: cartCount > 0,
              badgeContent: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: AppColors.nykaaPink,
                padding: EdgeInsets.all(3),
                elevation: 0,
              ),
              child: _IconButton(
                icon: Icons.shopping_bag_outlined,
                onTap: onCartTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: AppColors.nykaaBlack),
      ),
    );
  }
}
