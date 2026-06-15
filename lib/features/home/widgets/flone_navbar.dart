import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class FloneNavbar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onShopTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;
  final int cartCount;

  const FloneNavbar({
    super.key,
    this.onMenuTap,
    this.onSearchTap,
    this.onShopTap,
    this.onWishlistTap,
    this.onCartTap,
    this.onProfileTap,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.navHeight,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Row(
            children: [
              _Logo(),
              if (!isMobile) ...[
                const SizedBox(width: 48),
                Expanded(child: _NavLinks(onShopTap: onShopTap)),
              ],
              const Spacer(),
              _NavIcons(
                isMobile: isMobile,
                cartCount: cartCount,
                onMenuTap: isMobile ? onMenuTap : null,
                onSearchTap: onSearchTap,
                onWishlistTap: onWishlistTap,
                onCartTap: onCartTap,
                onProfileTap: onProfileTap,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Flone.',
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }
}

class _NavLinks extends StatelessWidget {
  final VoidCallback? onShopTap;

  const _NavLinks({this.onShopTap});

  @override
  Widget build(BuildContext context) {
    final links = [
      'Home', 'Shop', 'Collection', 'Pages', 'Blog', 'About', 'Contact'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: links.map((link) {
        final hasDropdown = ['Home', 'Shop', 'Pages'].contains(link);
        return _NavLink(
          label: link,
          hasDropdown: hasDropdown,
          isActive: link == 'Home',
          onTap: link == 'Shop' ? onShopTap : null,
        );
      }).toList(),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool hasDropdown;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavLink({
    required this.label,
    this.hasDropdown = false,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.navLink.copyWith(
                  color: widget.isActive
                      ? AppColors.textPrimary
                      : _isHovered
                          ? AppColors.textPrimary
                          : const Color(0xFF333333),
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (widget.isActive || _isHovered)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  height: 2,
                  width: widget.label.length * 7.0,
                  color: AppColors.textPrimary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcons extends StatelessWidget {
  final bool isMobile;
  final int cartCount;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const _NavIcons({
    required this.isMobile,
    required this.cartCount,
    this.onMenuTap,
    this.onSearchTap,
    this.onWishlistTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile)
          _IconButton(
            icon: Icons.menu,
            onTap: onMenuTap,
          )
        else ...[
          _IconButton(icon: Icons.search, onTap: onSearchTap),
          const SizedBox(width: 4),
          _IconButton(icon: Icons.person_outline, onTap: onProfileTap),
          const SizedBox(width: 4),
          _IconButton(icon: Icons.favorite_border, onTap: onWishlistTap),
          const SizedBox(width: 4),
          _CartIconButton(count: cartCount, onTap: onCartTap),
        ],
      ],
    );
  }
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButton({required this.icon, this.onTap});

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(widget.icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _CartIconButton extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _CartIconButton({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: count > 0
          ? Badge(
              label: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.textPrimary,
              smallSize: 18,
              padding: const EdgeInsets.all(0),
              child: const Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.textPrimary),
            )
          : const Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.textPrimary),
    );
  }
}
