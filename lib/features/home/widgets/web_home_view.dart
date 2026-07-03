import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/product.dart';
import '../../../models/category.dart' as models;
import 'web/web_ui.dart';
import 'web/web_product_card.dart';
import 'web/web_footer.dart';
import 'web/web_chrome.dart';

/// Desktop / website experience for Dristi Fashions.
///
/// Rendered only on wide viewports. The mobile app never reaches this widget,
/// so the application UI is completely independent of this design system.
class WebHomeView extends StatelessWidget {
  final int cartCount;
  final VoidCallback onSearchTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;
  final VoidCallback onShopNow;
  final VoidCallback onExplore;
  final void Function(String label) onCategoryTap;
  final void Function(String label) onNavTap;

  final List<Product> products;
  final void Function(Product) onProductTap;
  final void Function(Product) onAddToBag;
  final void Function(Product) onWishlistProduct;

  final List<models.Category> categories;
  final void Function(models.Category) onCategoryOpen;

  const WebHomeView({
    super.key,
    required this.cartCount,
    required this.onSearchTap,
    required this.onWishlistTap,
    required this.onCartTap,
    required this.onProfileTap,
    required this.onShopNow,
    required this.onExplore,
    required this.onCategoryTap,
    required this.onNavTap,
    required this.products,
    required this.onProductTap,
    required this.onAddToBag,
    required this.onWishlistProduct,
    required this.categories,
    required this.onCategoryOpen,
  });

  @override
  Widget build(BuildContext context) {
    final newArrivals = _pick(products, preferNew: true, count: 8);
    final bestSellers = _pick(products, preferFeatured: true, count: 8, exclude: newArrivals);

    return Scaffold(
      backgroundColor: WebTokens.surface,
      body: Column(
        children: [
          const WebAnnouncementBar(),
          WebNavbar(
            cartCount: cartCount,
            activeLabel: 'HOME',
            onSearchTap: onSearchTap,
            onWishlistTap: onWishlistTap,
            onCartTap: onCartTap,
            onProfileTap: onProfileTap,
            onNavTap: onNavTap,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Hero(onShopNow: onShopNow, onExplore: onExplore),
                  const _TrustStrip(),
                  if (categories.isNotEmpty)
                    _ShopByCategory(
                      categories: categories,
                      onCategory: onCategoryOpen,
                      onViewAll: onExplore,
                    ),
                  if (newArrivals.isNotEmpty)
                    _ProductShowcase(
                      eyebrow: 'Just In',
                      title: 'New Arrivals',
                      subtitle: 'The latest additions to our premium collection, curated for the season.',
                      background: WebTokens.surface,
                      products: newArrivals,
                      onProductTap: onProductTap,
                      onAddToBag: onAddToBag,
                      onWishlist: onWishlistProduct,
                      onViewAll: onShopNow,
                    ),
                  _PromoBanners(onCategoryTap: onCategoryTap),
                  if (bestSellers.isNotEmpty)
                    _ProductShowcase(
                      eyebrow: 'Most Loved',
                      title: 'Best Sellers',
                      subtitle: 'Customer favourites that define elegance and everyday comfort.',
                      background: WebTokens.surfaceAlt,
                      products: bestSellers,
                      onProductTap: onProductTap,
                      onAddToBag: onAddToBag,
                      onWishlist: onWishlistProduct,
                      onViewAll: onShopNow,
                    ),
                  const _BrandStory(),
                  const _Testimonials(),
                  const WebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _pick(List<Product> all,
      {bool preferNew = false,
      bool preferFeatured = false,
      int count = 8,
      List<Product> exclude = const []}) {
    final excludeIds = exclude.map((e) => e.id).toSet();
    final pool = all.where((p) => !excludeIds.contains(p.id)).toList();
    pool.sort((a, b) {
      int score(Product p) =>
          (preferNew && p.isNew ? 2 : 0) + (preferFeatured && p.isFeatured ? 2 : 0);
      return score(b).compareTo(score(a));
    });
    return pool.take(count).toList();
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final VoidCallback onShopNow;
  final VoidCallback onExplore;
  const _Hero({required this.onShopNow, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.5, -0.3),
          radius: 1.3,
          colors: [WebTokens.blue, WebTokens.blueDeep],
        ),
      ),
      child: WebContainer(
        padding: const EdgeInsets.fromLTRB(WebTokens.gutter, 64, WebTokens.gutter, 72),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 5, child: _HeroCopy(onShopNow: onShopNow, onExplore: onExplore)),
            const SizedBox(width: 40),
            const Expanded(flex: 5, child: _HeroImage()),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final VoidCallback onShopNow;
  final VoidCallback onExplore;
  const _HeroCopy({required this.onShopNow, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('LOOK GOOD  •  FEEL CONFIDENT  •  BE YOU', style: WebTokens.overline(WebTokens.goldBright)),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Elevate Your\n', style: WebTokens.display(58, color: Colors.white)),
            TextSpan(text: 'Style', style: WebTokens.serifItalic(64, color: WebTokens.goldBright)),
          ]),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: 480,
          child: Text(
            'Discover premium ladies wear, men\'s wear, kids wear and ethnic '
            'collections crafted with perfection, comfort and elegance.',
            style: WebTokens.sans(16, color: const Color(0xFFC6CCE8), height: 1.7),
          ),
        ),
        const SizedBox(height: 34),
        Row(
          children: [
            WebGoldButton(label: 'SHOP NOW', icon: Icons.shopping_bag_outlined, onTap: onShopNow),
            const SizedBox(width: 18),
            WebOutlineButton(
                label: 'EXPLORE COLLECTIONS',
                trailing: Icons.arrow_forward,
                foreground: Colors.white,
                onTap: onExplore),
          ],
        ),
        const SizedBox(height: 40),
        const Row(
          children: [
            _HeroStat('15K+', 'Happy Customers'),
            _HeroStatDivider(),
            _HeroStat('500+', 'Premium Styles'),
            _HeroStatDivider(),
            _HeroStat('4.8★', 'Average Rating'),
          ],
        ),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.playfairDisplay(
                fontSize: 30, fontWeight: FontWeight.w700, color: WebTokens.goldBright)),
        const SizedBox(height: 2),
        Text(label, style: WebTokens.sans(12, color: Colors.white60)),
      ],
    );
  }
}

class _HeroStatDivider extends StatelessWidget {
  const _HeroStatDivider();
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      width: 1,
      height: 40,
      color: Colors.white24);
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WebTokens.gold.withValues(alpha: 0.55), width: 2),
        boxShadow: [BoxShadow(color: WebTokens.blueDeep.withValues(alpha: 0.5), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset('assets/logo.jpg', fit: BoxFit.cover),
      ),
    );
  }
}

// ─── Trust strip ─────────────────────────────────────────────────────────────

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  static const List<(IconData, String, String)> _items = [
    (Icons.workspace_premium_outlined, 'Premium Quality', 'Finest fabrics & finishing'),
    (Icons.local_shipping_outlined, 'Fast & Safe Delivery', 'Pan-India shipping'),
    (Icons.autorenew, 'Easy Returns', '7-day hassle-free returns'),
    (Icons.verified_user_outlined, '100% Secure', 'Trusted checkout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WebTokens.cream,
      padding: const EdgeInsets.symmetric(vertical: 34),
      width: double.infinity,
      child: WebContainer(
        child: Row(
          children: [
            for (int i = 0; i < _items.length; i++) ...[
              Expanded(
                child: Row(
                  children: [
                    Icon(_items[i].$1, size: 34, color: WebTokens.gold),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_items[i].$2,
                            style: WebTokens.sans(15, color: WebTokens.ink, w: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(_items[i].$3, style: WebTokens.sans(12, color: WebTokens.muted)),
                      ],
                    ),
                  ],
                ),
              ),
              if (i != _items.length - 1)
                Container(width: 1, height: 44, color: WebTokens.gold.withValues(alpha: 0.25)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Shop by category ────────────────────────────────────────────────────────

class _ShopByCategory extends StatelessWidget {
  final List<models.Category> categories;
  final void Function(models.Category) onCategory;
  final VoidCallback onViewAll;
  const _ShopByCategory({
    required this.categories,
    required this.onCategory,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    // Real categories from the database (first five for the row layout).
    final cats = categories.take(5).toList();
    return WebSection(
      background: WebTokens.surface,
      child: Column(
        children: [
          const WebHeading(
            eyebrow: 'Browse',
            title: 'Shop by Category',
            subtitle: 'From everyday essentials to statement ethnic wear — find your fit across our collections.',
          ),
          const SizedBox(height: 44),
          SizedBox(
            height: 380,
            child: Row(
              children: [
                for (int i = 0; i < cats.length; i++) ...[
                  Expanded(
                    child: _CategoryCard(
                      label: cats[i].name,
                      imageUrl: cats[i].imageUrl ?? '',
                      onTap: () => onCategory(cats[i]),
                    ),
                  ),
                  if (i != cats.length - 1) const SizedBox(width: 18),
                ],
              ],
            ),
          ),
          if (categories.length > 5) ...[
            const SizedBox(height: 36),
            WebOutlineButton(
                label: 'VIEW ALL CATEGORIES', trailing: Icons.arrow_forward, onTap: onViewAll),
          ],
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;
  const _CategoryCard({required this.label, required this.imageUrl, required this.onTap});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: _hover ? 1.07 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: WebImage(url: widget.imageUrl),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC0C1547)],
                    stops: [0.45, 1],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: WebTokens.display(20, color: Colors.white, w: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('SHOP NOW',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: WebTokens.goldBright,
                                letterSpacing: 1)),
                        const SizedBox(width: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          transform: Matrix4.translationValues(_hover ? 4 : 0, 0, 0),
                          child: const Icon(Icons.arrow_forward, size: 14, color: WebTokens.goldBright),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Product showcase ────────────────────────────────────────────────────────

class _ProductShowcase extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Color background;
  final List<Product> products;
  final void Function(Product) onProductTap;
  final void Function(Product) onAddToBag;
  final void Function(Product) onWishlist;
  final VoidCallback onViewAll;

  const _ProductShowcase({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.products,
    required this.onProductTap,
    required this.onAddToBag,
    required this.onWishlist,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return WebSection(
      background: background,
      child: Column(
        children: [
          WebHeading(eyebrow: eyebrow, title: title, subtitle: subtitle),
          const SizedBox(height: 44),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 24.0;
              final columns = constraints.maxWidth >= 1100 ? 4 : 3;
              final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: products
                    .map((p) => SizedBox(
                          width: cardWidth,
                          child: WebProductCard(
                            product: p,
                            onTap: () => onProductTap(p),
                            onAddToBag: () => onAddToBag(p),
                            onWishlist: () => onWishlist(p),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 44),
          Center(child: WebOutlineButton(label: 'VIEW ALL PRODUCTS', trailing: Icons.arrow_forward, onTap: onViewAll)),
        ],
      ),
    );
  }
}

// ─── Promo split banners ─────────────────────────────────────────────────────

class _PromoBanners extends StatelessWidget {
  final void Function(String) onCategoryTap;
  const _PromoBanners({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return WebSection(
      background: WebTokens.surface,
      topPad: 0,
      child: Row(
        children: [
          Expanded(
            child: _PromoCard(
              tag: 'FOR HER',
              title: 'Ethnic Elegance',
              subtitle: 'Up to 40% off on festive wear',
              imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&q=80',
              onTap: () => onCategoryTap('Ladies Wear'),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _PromoCard(
              tag: 'FOR HIM',
              title: 'Sharp & Refined',
              subtitle: 'New season menswear',
              imageUrl: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&q=80',
              onTap: () => onCategoryTap("Men's Wear"),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatefulWidget {
  final String tag;
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  const _PromoCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<_PromoCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _hover ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: WebImage(url: widget.imageUrl),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xE60C1547), Color(0x330C1547)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.tag, style: WebTokens.overline(WebTokens.goldBright)),
                      const SizedBox(height: 12),
                      Text(widget.title, style: WebTokens.display(32, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(widget.subtitle, style: WebTokens.sans(15, color: Colors.white70)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('SHOP COLLECTION',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: WebTokens.goldBright,
                                  letterSpacing: 1)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 16, color: WebTokens.goldBright),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Brand story band ────────────────────────────────────────────────────────

class _BrandStory extends StatelessWidget {
  const _BrandStory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [WebTokens.blueDeep, WebTokens.blue]),
      ),
      child: WebContainer(
        padding: const EdgeInsets.symmetric(horizontal: WebTokens.gutter, vertical: 72),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const SizedBox(
                  height: 360,
                  child: WebImage(
                      url: 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800&q=80'),
                ),
              ),
            ),
            const SizedBox(width: 56),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OUR STORY', style: WebTokens.overline(WebTokens.goldBright)),
                  const SizedBox(height: 16),
                  Text('Fashion That Reflects\nYour Personality',
                      style: WebTokens.display(38, color: Colors.white)),
                  const SizedBox(height: 20),
                  Text(
                    'At Dristi Fashions, we believe clothing is a form of self-expression. '
                    'Every piece in our collection is thoughtfully designed and crafted with '
                    'premium fabrics — blending timeless elegance with modern comfort, so you '
                    'always look and feel your best.',
                    style: WebTokens.sans(15, color: const Color(0xFFC6CCE8), height: 1.8),
                  ),
                  const SizedBox(height: 28),
                  const Row(
                    children: [
                      _StoryPoint('Ethically Sourced'),
                      SizedBox(width: 32),
                      _StoryPoint('Handcrafted Detail'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryPoint extends StatelessWidget {
  final String text;
  const _StoryPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 20, color: WebTokens.goldBright),
        const SizedBox(width: 10),
        Text(text, style: WebTokens.sans(14, color: Colors.white, w: FontWeight.w500)),
      ],
    );
  }
}

// ─── Testimonials ────────────────────────────────────────────────────────────

class _Testimonials extends StatelessWidget {
  const _Testimonials();

  static const List<(String, String, String)> _reviews = [
    ('Aarohi S.', 'The fabric quality is exceptional and the fit is perfect. My festive lehenga got so many compliments!', 'Ethnic Collection'),
    ('Rohan M.', 'Sharp, premium menswear that actually fits well. Fast delivery and great packaging too.', "Men's Wear"),
    ('Neha K.', 'Elegant designs at a fair price. Dristi has become my go-to for every occasion.', 'Western Wear'),
  ];

  @override
  Widget build(BuildContext context) {
    return WebSection(
      background: WebTokens.surfaceAlt,
      child: Column(
        children: [
          const WebHeading(
            eyebrow: 'Loved by Thousands',
            title: 'What Our Customers Say',
          ),
          const SizedBox(height: 44),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _reviews.length; i++) ...[
                Expanded(
                  child: _ReviewCard(
                    name: _reviews[i].$1,
                    text: _reviews[i].$2,
                    tag: _reviews[i].$3,
                  ),
                ),
                if (i != _reviews.length - 1) const SizedBox(width: 24),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String text;
  final String tag;
  const _ReviewCard({required this.name, required this.text, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: WebTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WebTokens.line),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
                5, (_) => const Icon(Icons.star, size: 18, color: WebTokens.gold)),
          ),
          const SizedBox(height: 18),
          Text('“$text”', style: WebTokens.sans(15, color: WebTokens.body, height: 1.7)),
          const SizedBox(height: 22),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: WebTokens.blue,
                child: Text(name.substring(0, 1),
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: WebTokens.sans(15, color: WebTokens.ink, w: FontWeight.w700)),
                  Text(tag, style: WebTokens.sans(12, color: WebTokens.muted)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
