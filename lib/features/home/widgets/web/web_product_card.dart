import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/product.dart';
import 'web_ui.dart';

/// Website-style product card: 3:4 image with hover zoom, reveal "Add to Bag"
/// bar, wishlist heart, discount + NEW badges, brand / title / price / rating.
class WebProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToBag;
  final VoidCallback onWishlist;

  const WebProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToBag,
    required this.onWishlist,
  });

  @override
  State<WebProductCard> createState() => _WebProductCardState();
}

class _WebProductCardState extends State<WebProductCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p.originalPrice > p.price;
    final discount = p.discountPercentage > 0
        ? p.discountPercentage
        : (hasDiscount ? ((p.originalPrice - p.price) / p.originalPrice * 100).round() : 0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: WebTokens.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: WebTokens.line),
            boxShadow: [
              BoxShadow(
                color: WebTokens.blueDeep.withValues(alpha: _hover ? 0.16 : 0.05),
                blurRadius: _hover ? 28 : 12,
                offset: Offset(0, _hover ? 14 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageBlock(p, discount),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.brand.isNotEmpty)
                      Text(p.brand.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: WebTokens.sans(11, color: WebTokens.muted, w: FontWeight.w600, spacing: 1)),
                    const SizedBox(height: 4),
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WebTokens.sans(15, color: WebTokens.ink, w: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('₹${p.price.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                                fontSize: 17, fontWeight: FontWeight.w700, color: WebTokens.blue)),
                        if (hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text('₹${p.originalPrice.toStringAsFixed(0)}',
                              style: WebTokens.sans(13, color: WebTokens.muted)
                                  .copyWith(decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 8),
                          if (discount > 0)
                            Text('$discount% OFF',
                                style: WebTokens.sans(12, color: WebTokens.gold, w: FontWeight.w700)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (p.reviewCount > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 15, color: WebTokens.gold),
                          const SizedBox(width: 4),
                          Text(p.rating.toStringAsFixed(1),
                              style: WebTokens.sans(12, color: WebTokens.body, w: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Text('(${p.reviewCount})', style: WebTokens.sans(12, color: WebTokens.muted)),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.star_border, size: 15, color: WebTokens.muted.withValues(alpha: 0.7)),
                          const SizedBox(width: 4),
                          Text('No reviews yet', style: WebTokens.sans(12, color: WebTokens.muted)),
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

  Widget _imageBlock(Product p, int discount) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // White backdrop + contain: product photos arrive in any aspect
            // ratio (the 3:4 in the admin form is a recommendation, not a
            // rule), so the card letterboxes them instead of cropping the
            // garment.
            Container(color: Colors.white),
            AnimatedScale(
              scale: _hover ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: WebImage(url: p.imageUrl, fit: BoxFit.contain),
            ),
            // Badges
            Positioned(
              top: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (discount > 0) _badge('$discount% OFF', WebTokens.gold, WebTokens.blueDeep),
                  if (p.isNew) ...[
                    const SizedBox(height: 6),
                    _badge('NEW', WebTokens.blue, Colors.white),
                  ],
                ],
              ),
            ),
            // Wishlist
            Positioned(
              top: 10,
              right: 10,
              child: _CircleAction(icon: Icons.favorite_border, onTap: widget.onWishlist),
            ),
            // Add to bag bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                offset: Offset(0, _hover ? 0 : 1),
                duration: const Duration(milliseconds: 200),
                child: AnimatedOpacity(
                  opacity: _hover ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: widget.onAddToBag,
                    child: Container(
                      color: WebTokens.blueDeep.withValues(alpha: 0.92),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 16, color: WebTokens.gold),
                          const SizedBox(width: 8),
                          Text('ADD TO BAG',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.5)),
    );
  }
}

class _CircleAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.onTap});

  @override
  State<_CircleAction> createState() => _CircleActionState();
}

class _CircleActionState extends State<_CircleAction> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hover ? WebTokens.gold : Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6)],
          ),
          child: Icon(widget.icon, size: 18, color: _hover ? Colors.white : WebTokens.blueDeep),
        ),
      ),
    );
  }
}
