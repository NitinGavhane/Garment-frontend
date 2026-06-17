import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/location_provider.dart';

class TopBar extends StatelessWidget {
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onAddressTap;

  const TopBar({
    super.key,
    this.cartCount = 0,
    this.onSearchTap,
    this.onWishlistTap,
    this.onCartTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          _AddressBar(onTap: onAddressTap),
          _SearchHeader(
            cartCount: cartCount,
            onSearchTap: onSearchTap,
            onNotificationTap: onNotificationTap,
            onWishlistTap: onWishlistTap,
            onProfileTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _AddressBar extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddressBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final location = context.watch<LocationProvider>();

    if (!auth.isLoggedIn) {
      final locText = location.isLoading
          ? 'Detecting location...'
          : location.address.isNotEmpty
              ? location.address
              : 'Your location';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.location_on, size: 18, color: AppColors.primaryContainer),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                locText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final displayText = location.isLoading
        ? 'Detecting location...'
        : location.address.isNotEmpty
            ? 'Deliver to ${location.address}'
            : 'Set your location';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.location_on, size: 18, color: AppColors.primaryContainer),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                displayText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.expand_more, size: 20, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onProfileTap;

  const _SearchHeader({
    this.cartCount = 0,
    this.onSearchTap,
    this.onNotificationTap,
    this.onWishlistTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.surface.withValues(alpha: 0.95),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(
                        'G',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"Joggers"',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Icon(Icons.search, size: 22, color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _IconBtn(Icons.notifications_outlined, onNotificationTap),
          _IconBtn(Icons.favorite_outline, onWishlistTap),
          _IconBtn(Icons.person_outline, onProfileTap),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: AppColors.onSurface),
      ),
    );
  }
}
