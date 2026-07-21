import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../models/product.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/delivery_provider.dart';
import '../../../../providers/wishlist_provider.dart';
import 'web_ui.dart';
import 'web_footer.dart';
import 'web_shop_page.dart';
import 'web_collections_page.dart';
import 'web_product_detail_page.dart';
import 'web_info_page.dart';
import 'web_auth_page.dart';
import 'web_cart_page.dart';
import 'web_wishlist_page.dart';
import 'web_account_page.dart';

/// Centralised navigation + cart/wishlist actions for the website.
///
/// Every web page routes through here so behaviour (auth guards, snackbars,
/// destinations) stays identical across the whole site.
class WebNav {
  WebNav._();

  // ── Top-level pages ────────────────────────────────────────────────────────

  /// Returns to the home page (the first route in the stack).
  static void goHome(BuildContext context) {
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  static void goShop(BuildContext context,
      {String title = 'Shop',
      String? initialGender,
      String? initialCategoryId,
      String? initialSearch,
      bool onlyNew = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebShopPage(
          title: title,
          initialGender: initialGender,
          initialCategoryId: initialCategoryId,
          initialSearch: initialSearch,
          onlyNew: onlyNew,
        ),
      ),
    );
  }

  static void goNewArrivals(BuildContext context) =>
      goShop(context, title: 'New Arrivals', onlyNew: true);

  static void goCollections(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WebCollectionsPage()),
    );
  }

  static void goProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WebProductDetailPage(product: product)),
    );
  }

  static void goContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WebInfoPage(mode: WebInfoMode.contact)),
    );
  }

  static void goAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WebInfoPage(mode: WebInfoMode.about)),
    );
  }

  /// Maps a navbar label to its destination.
  static void handleNav(BuildContext context, String label) {
    switch (label) {
      case 'HOME':
        goHome(context);
        break;
      case 'SHOP':
        goShop(context);
        break;
      case 'NEW ARRIVALS':
        goNewArrivals(context);
        break;
      case 'COLLECTIONS':
        goCollections(context);
        break;
      case 'ABOUT US':
        goAbout(context);
        break;
      case 'CONTACT US':
        goContact(context);
        break;
    }
  }

  /// Maps the home page's design-system category labels to a Shop filter.
  static void goShopByCategoryLabel(BuildContext context, String label) {
    switch (label) {
      case 'Ladies Wear':
        goShop(context, title: label, initialGender: 'WOMEN');
        break;
      case "Men's Wear":
        goShop(context, title: label, initialGender: 'MEN');
        break;
      case 'Kids Wear':
        goShop(context, title: label, initialGender: 'KIDS');
        break;
      case 'Ethnic Wear':
        goShop(context, title: label, initialSearch: 'ethnic');
        break;
      case 'Western Wear':
        goShop(context, title: label, initialSearch: 'western');
        break;
      default:
        goShop(context, title: label, initialSearch: label);
    }
  }

  /// Routes a footer link label to a sensible destination.
  static void footerLink(BuildContext context, String label) {
    switch (label) {
      case 'Ladies Wear':
      case "Men's Wear":
      case 'Kids Wear':
      case 'Ethnic Wear':
      case 'Western Wear':
        goShopByCategoryLabel(context, label);
        break;
      case 'About Us':
        goAbout(context);
        break;
      case 'Contact Us':
        goContact(context);
        break;
      case 'Track Order':
        goProfile(context);
        break;
      default:
        // Careers, Blog, Store Locator, Shipping & Returns, Size Guide, FAQs,
        // Privacy Policy — all handled via the Contact/Help page for now.
        goContact(context);
    }
  }

  // ── Icon actions ───────────────────────────────────────────────────────────

  static void goSearch(BuildContext context) =>
      goShop(context, title: 'Search Products');

  static void goAuth(BuildContext context, {bool register = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WebAuthPage(startOnRegister: register)),
    );
  }

  static void goWishlist(BuildContext context) =>
      _guarded(context, const WebWishlistPage());

  static void goCart(BuildContext context) =>
      _guarded(context, const WebCartPage());

  static void goProfile(BuildContext context) =>
      _guarded(context, const WebAccountPage());

  static void _guarded(BuildContext context, Widget page) {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      goAuth(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  // ── Cart / wishlist ────────────────────────────────────────────────────────

  static Future<void> addToBag(BuildContext context, Product product,
      {String? size, String? color, int quantity = 1}) async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      goAuth(context);
      return;
    }
    await context.read<CartProvider>().addToCart(
          product: product,
          quantity: quantity,
          selectedSize: size ?? (product.sizes.isNotEmpty ? product.sizes.first : 'M'),
          selectedColor: color ?? (product.colors.isNotEmpty ? product.colors.first : ''),
        );
    if (!context.mounted) return;
    _toast(context, '${product.title} added to bag');
  }

  static Future<void> toggleWishlist(BuildContext context, Product product) async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      goAuth(context);
      return;
    }
    final wishlist = context.read<WishlistProvider>();
    final wasWishlisted = wishlist.isWishlisted(product.id);
    await wishlist.toggle(product.id);
    if (!context.mounted) return;
    _toast(context, wasWishlisted ? 'Removed from wishlist' : 'Added to wishlist');
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: WebTokens.blueDeep,
      ),
    );
  }
}

/// Full-page website scaffold: announcement bar + navbar (with live cart
/// badge) + scrollable body + footer. Shared by every web page except the
/// home page (which composes the same chrome around its bespoke hero).
class WebScaffold extends StatelessWidget {
  /// The label of the active navbar link, e.g. 'SHOP'. Empty for none.
  final String activeNav;

  /// Page content, placed inside the scrolling area above the footer.
  final Widget body;

  /// When true (default) the shared [WebFooter] is appended below [body].
  final bool showFooter;

  const WebScaffold({
    super.key,
    required this.body,
    this.activeNav = '',
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    return Scaffold(
      backgroundColor: WebTokens.surface,
      body: Column(
        children: [
          const WebAnnouncementBar(),
          WebNavbar(
            cartCount: cartCount,
            activeLabel: activeNav,
            onSearchTap: () => WebNav.goSearch(context),
            onProfileTap: () => WebNav.goProfile(context),
            onWishlistTap: () => WebNav.goWishlist(context),
            onCartTap: () => WebNav.goCart(context),
            onNavTap: (label) => WebNav.handleNav(context, label),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  body,
                  if (showFooter) const WebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Announcement bar ────────────────────────────────────────────────────────

class WebAnnouncementBar extends StatelessWidget {
  const WebAnnouncementBar({super.key});

  @override
  Widget build(BuildContext context) {
    // The delivery line comes from the store's configured policy, so the bar
    // never promises free shipping once a delivery charge is set up.
    final delivery = context.watch<DeliveryProvider>().settings;
    return Container(
      height: 38,
      width: double.infinity,
      color: WebTokens.blueDeep,
      alignment: Alignment.center,
      child: Text(
        '${delivery.promoLine}   •   EASY 7-DAY RETURNS   •   NEW ETHNIC COLLECTION NOW LIVE',
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: WebTokens.goldBright,
            letterSpacing: 1),
      ),
    );
  }
}

// ─── Navbar ──────────────────────────────────────────────────────────────────

class WebNavbar extends StatelessWidget {
  final int cartCount;
  final String activeLabel;
  final VoidCallback onSearchTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;
  final void Function(String label) onNavTap;

  const WebNavbar({
    super.key,
    required this.cartCount,
    required this.onSearchTap,
    required this.onWishlistTap,
    required this.onCartTap,
    required this.onProfileTap,
    required this.onNavTap,
    this.activeLabel = '',
  });

  static const List<String> _links = [
    'HOME',
    'SHOP',
    'NEW ARRIVALS',
    'COLLECTIONS',
    'ABOUT US',
    'CONTACT US',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: WebTokens.line)),
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: WebContainer(
        child: LayoutBuilder(builder: (context, constraints) {
          // Below ~1150px the tagline is dropped and the links auto-scale so
          // the navbar never overflows on smaller desktop windows.
          final compact = constraints.maxWidth < 1150;
          return Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onNavTap('HOME'),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/logo.jpg',
                          width: 46, height: 46, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DRISTI FASHIONS',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: WebTokens.blue,
                                letterSpacing: 1.5)),
                        if (!compact)
                          Text('Fashion That Reflects Your Personality',
                              style: WebTokens.sans(10, color: WebTokens.muted, spacing: 0.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      for (final label in _links)
                        _NavLink(
                          label: label,
                          active: label == activeLabel,
                          onTap: () => onNavTap(label),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _NavIcon(Icons.search, onSearchTap),
            _NavIcon(Icons.person_outline, onProfileTap),
            _NavIcon(Icons.favorite_border, onWishlistTap),
            _CartIcon(count: cartCount, onTap: onCartTap),
          ],
          );
        }),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _NavLink({required this.label, required this.active, this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final on = widget.active || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: on ? WebTokens.gold : WebTokens.ink)),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 2,
                width: on ? widget.label.length * 7.0 : 0,
                color: WebTokens.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIcon(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 22,
      icon: Icon(icon, color: WebTokens.ink, size: 22),
    );
  }
}

class _CartIcon extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _CartIcon({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 22,
      icon: Badge(
        label: Text('$count'),
        backgroundColor: WebTokens.gold,
        textColor: WebTokens.blueDeep,
        child: const Icon(Icons.shopping_bag_outlined, color: WebTokens.ink, size: 22),
      ),
    );
  }
}

// ─── Page header ─────────────────────────────────────────────────────────────

/// Shared gradient page-header band used by every inner website page, so all
/// pages open with the same look: gold eyebrow, serif title, optional subtitle.
/// [centered] switches to the centered hero variant with a gold divider.
class WebPageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool centered;

  const WebPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [WebTokens.blueDeep, WebTokens.blue]),
      ),
      child: WebContainer(
        padding: EdgeInsets.symmetric(
            horizontal: WebTokens.gutter, vertical: centered ? 56 : 46),
        child: Column(
          crossAxisAlignment:
              centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(eyebrow.toUpperCase(),
                style: WebTokens.overline(WebTokens.goldBright)),
            const SizedBox(height: 12),
            Text(title,
                textAlign: centered ? TextAlign.center : TextAlign.start,
                style: WebTokens.display(centered ? 44 : 40, color: Colors.white)),
            if (centered) ...[
              const SizedBox(height: 14),
              Container(width: 60, height: 3, color: WebTokens.gold),
            ],
            if (subtitle != null) ...[
              SizedBox(height: centered ? 16 : 8),
              if (centered)
                SizedBox(
                  width: 600,
                  child: Text(subtitle!,
                      textAlign: TextAlign.center,
                      style: WebTokens.sans(15, color: Colors.white70, height: 1.6)),
                )
              else
                Text(subtitle!, style: WebTokens.sans(14, color: Colors.white70)),
            ],
          ],
        ),
      ),
    );
  }
}
