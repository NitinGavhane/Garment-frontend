import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/product_api_service.dart';
import '../../../../models/product.dart';
import '../../../../providers/delivery_provider.dart';
import '../../../../providers/product_provider.dart';
import '../../../../providers/wishlist_provider.dart';
import 'web_chrome.dart';
import 'web_product_card.dart';
import 'web_ui.dart';

/// Website product detail page. Shows the list-level [product] instantly, then
/// enriches it with the full record (gallery, variants, description) from the
/// live API.
class WebProductDetailPage extends StatefulWidget {
  final Product product;
  const WebProductDetailPage({super.key, required this.product});

  @override
  State<WebProductDetailPage> createState() => _WebProductDetailPageState();
}

class _WebProductDetailPageState extends State<WebProductDetailPage> {
  ApiProduct? _detail;
  bool _loading = true;
  int _imageIndex = 0;
  String? _size;
  String? _color;
  int _qty = 1;

  @override
  void initState() {
    super.initState();
    _loadDetail();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final products = context.read<ProductProvider>();
      if (products.products.isEmpty && !products.isLoading) {
        products.fetchProducts();
      }
    });
  }

  Future<void> _loadDetail() async {
    try {
      final data = await ProductApiService.getProduct(widget.product.id);
      final api = ApiProduct.fromJson(data);
      if (!mounted) return;
      setState(() {
        _detail = api;
        _size = api.availableSizes.isNotEmpty
            ? api.availableSizes.first
            : (widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null);
        _color = api.availableColors.isNotEmpty
            ? api.availableColors.first
            : (widget.product.colors.isNotEmpty ? widget.product.colors.first : null);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _size = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null;
        _color = widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
        _loading = false;
      });
    }
  }

  List<String> get _gallery {
    final imgs = _detail?.images.map((i) => i.imageUrl).toList() ?? const [];
    if (imgs.isNotEmpty) return imgs;
    if (widget.product.imageUrl.isNotEmpty) return [widget.product.imageUrl];
    return const [];
  }

  List<String> get _sizes =>
      _detail?.availableSizes.isNotEmpty == true ? _detail!.availableSizes : widget.product.sizes;
  List<String> get _colors =>
      _detail?.availableColors.isNotEmpty == true ? _detail!.availableColors : widget.product.colors;

  double get _price => _detail?.displayPrice ?? widget.product.price;
  double get _original => _detail?.originalPrice ?? widget.product.originalPrice;
  String get _description =>
      (_detail?.description?.isNotEmpty == true ? _detail!.description! : widget.product.description);
  int get _stock => _detail?.stock ?? widget.product.stock;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<ProductProvider>().products;
    final related = all
        .where((p) => p.categoryId == widget.product.categoryId && p.id != widget.product.id)
        .take(4)
        .toList();

    return WebScaffold(
      body: Column(
        children: [
          _Breadcrumb(product: widget.product),
          WebSection(
            background: WebTokens.surface,
            topPad: 40,
            bottomPad: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _Gallery(images: _gallery, index: _imageIndex, onSelect: (i) => setState(() => _imageIndex = i))),
                const SizedBox(width: 56),
                Expanded(flex: 5, child: _buildInfo(context)),
              ],
            ),
          ),
          if (related.isNotEmpty) _RelatedProducts(products: related),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final p = widget.product;
    final hasDiscount = _original > _price;
    final discount = hasDiscount ? ((_original - _price) / _original * 100).round() : 0;
    final wished = context.watch<WishlistProvider>().isWishlisted(p.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.brand.isNotEmpty)
          Text(p.brand.toUpperCase(),
              style: WebTokens.sans(13, color: WebTokens.gold, w: FontWeight.w700, spacing: 1.5)),
        const SizedBox(height: 8),
        Text(p.title, style: WebTokens.display(34, color: WebTokens.ink)),
        const SizedBox(height: 16),
        Row(
          children: [
            if (p.reviewCount > 0) ...[
              const Icon(Icons.star, size: 18, color: WebTokens.gold),
              const SizedBox(width: 4),
              Text(p.rating.toStringAsFixed(1),
                  style: WebTokens.sans(14, color: WebTokens.body, w: FontWeight.w600)),
              const SizedBox(width: 6),
              Text('(${p.reviewCount} reviews)', style: WebTokens.sans(13, color: WebTokens.muted)),
            ] else
              Text('New Arrival', style: WebTokens.sans(13, color: WebTokens.gold, w: FontWeight.w600)),
            const SizedBox(width: 16),
            Container(width: 1, height: 16, color: WebTokens.line),
            const SizedBox(width: 16),
            Text(_stock > 0 ? 'In Stock' : 'Out of Stock',
                style: WebTokens.sans(13,
                    color: _stock > 0 ? WebTokens.success : WebTokens.dangerBright,
                    w: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${_price.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                    fontSize: 34, fontWeight: FontWeight.w700, color: WebTokens.blue)),
            if (hasDiscount) ...[
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('₹${_original.toStringAsFixed(0)}',
                    style: WebTokens.sans(17, color: WebTokens.muted)
                        .copyWith(decoration: TextDecoration.lineThrough)),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: WebTokens.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('$discount% OFF',
                      style: WebTokens.sans(13, color: WebTokens.gold, w: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text('Inclusive of all taxes', style: WebTokens.sans(12, color: WebTokens.muted)),
        const SizedBox(height: 28),
        Container(height: 1, color: WebTokens.line),
        const SizedBox(height: 24),
        if (_sizes.isNotEmpty) ...[
          const _SelectorLabel('Select Size'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in _sizes)
                _OptionBox(
                  label: s,
                  selected: _size == s,
                  onTap: () => setState(() => _size = s),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (_colors.isNotEmpty) ...[
          const _SelectorLabel('Select Colour'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in _colors)
                _OptionBox(
                  label: c[0].toUpperCase() + c.substring(1),
                  selected: _color == c,
                  onTap: () => setState(() => _color = c),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        const _SelectorLabel('Quantity'),
        const SizedBox(height: 12),
        _QtyStepper(
          value: _qty,
          max: _stock <= 0 ? 1 : _stock,
          onChanged: (v) => setState(() => _qty = v),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: _stock <= 0
                      ? null
                      : () => WebNav.addToBag(context, p,
                          size: _size, color: _color, quantity: _qty),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebTokens.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: WebTokens.muted,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text(_stock <= 0 ? 'OUT OF STOCK' : 'ADD TO BAG',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 58,
              height: 58,
              child: OutlinedButton(
                onPressed: () => WebNav.toggleWishlist(context, p),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: wished ? WebTokens.gold : WebTokens.line, width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(wished ? Icons.favorite : Icons.favorite_border,
                    color: wished ? WebTokens.gold : WebTokens.body),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const _AssuranceRow(),
        const SizedBox(height: 32),
        if (_loading)
          Row(
            children: [
              const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 10),
              Text('Loading full details…', style: WebTokens.sans(13, color: WebTokens.muted)),
            ],
          )
        else if (_description.isNotEmpty) ...[
          Text('Description',
              style: WebTokens.sans(16, color: WebTokens.ink, w: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(_description, style: WebTokens.sans(15, color: WebTokens.body, height: 1.8)),
        ],
      ],
    );
  }
}

// ─── Breadcrumb ──────────────────────────────────────────────────────────────

class _Breadcrumb extends StatelessWidget {
  final Product product;
  const _Breadcrumb({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: WebTokens.surfaceAlt,
      child: WebContainer(
        padding: const EdgeInsets.symmetric(horizontal: WebTokens.gutter, vertical: 18),
        child: Row(
          children: [
            _Crumb('Home', onTap: () => WebNav.goHome(context)),
            _sep(),
            _Crumb('Shop', onTap: () => WebNav.goShop(context)),
            _sep(),
            Flexible(
              child: Text(product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: WebTokens.sans(13, color: WebTokens.ink, w: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sep() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(Icons.chevron_right, size: 16, color: WebTokens.muted),
      );
}

class _Crumb extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Crumb(this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(label, style: WebTokens.sans(13, color: WebTokens.muted)),
      ),
    );
  }
}

// ─── Gallery ─────────────────────────────────────────────────────────────────

class _Gallery extends StatelessWidget {
  final List<String> images;
  final int index;
  final void Function(int) onSelect;
  const _Gallery({required this.images, required this.index, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final safeIndex = images.isEmpty ? 0 : index.clamp(0, images.length - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: WebTokens.line),
                borderRadius: BorderRadius.circular(18),
              ),
              // Contain, not cover: sellers upload photos in whatever aspect
              // ratio they have (square, portrait, landscape) and the whole
              // garment must stay visible instead of being cropped to fit.
              child: images.isEmpty
                  ? const WebImage(url: '')
                  : WebImage(url: images[safeIndex], fit: BoxFit.contain),
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final active = i == safeIndex;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onSelect(i),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: active ? WebTokens.gold : WebTokens.line,
                            width: active ? 2 : 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: WebImage(url: images[i], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Small pieces ────────────────────────────────────────────────────────────

class _SelectorLabel extends StatelessWidget {
  final String text;
  const _SelectorLabel(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: WebTokens.sans(14, color: WebTokens.ink, w: FontWeight.w700));
}

class _OptionBox extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionBox({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? WebTokens.blue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? WebTokens.blue : WebTokens.line, width: 1.4),
          ),
          child: Text(label,
              style: WebTokens.sans(14,
                  color: selected ? Colors.white : WebTokens.ink,
                  w: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int value;
  final int max;
  final void Function(int) onChanged;
  const _QtyStepper({required this.value, required this.max, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WebTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, value > 1 ? () => onChanged(value - 1) : null),
          Container(
            width: 56,
            alignment: Alignment.center,
            child: Text('$value',
                style: WebTokens.sans(16, color: WebTokens.ink, w: FontWeight.w600)),
          ),
          _btn(Icons.add, value < max ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return MouseRegion(
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: onTap == null ? WebTokens.muted : WebTokens.ink),
        ),
      ),
    );
  }
}

class _AssuranceRow extends StatelessWidget {
  const _AssuranceRow();

  @override
  Widget build(BuildContext context) {
    // The delivery promise mirrors the store's configured policy rather than a
    // fixed "free shipping" claim.
    final delivery = context.watch<DeliveryProvider>().settings;
    final items = <(IconData, String)>[
      (Icons.local_shipping_outlined, delivery.promoSentence),
      (Icons.autorenew, '7-day easy returns'),
      (Icons.verified_user_outlined, 'Secure checkout'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WebTokens.cream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Icon(items[i].$1, size: 24, color: WebTokens.gold),
                  const SizedBox(height: 8),
                  Text(items[i].$2,
                      textAlign: TextAlign.center,
                      style: WebTokens.sans(12, color: WebTokens.body, w: FontWeight.w500)),
                ],
              ),
            ),
            if (i != items.length - 1)
              Container(width: 1, height: 40, color: WebTokens.gold.withValues(alpha: 0.25)),
          ],
        ],
      ),
    );
  }
}

// ─── Related products ────────────────────────────────────────────────────────

class _RelatedProducts extends StatelessWidget {
  final List<Product> products;
  const _RelatedProducts({required this.products});

  @override
  Widget build(BuildContext context) {
    return WebSection(
      background: WebTokens.surfaceAlt,
      child: Column(
        children: [
          const WebHeading(
            eyebrow: 'You May Also Like',
            title: 'Related Products',
          ),
          const SizedBox(height: 44),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 24.0;
              final columns = constraints.maxWidth >= 1000 ? 4 : 2;
              final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: products
                    .map((p) => SizedBox(
                          width: cardWidth,
                          child: WebProductCard(
                            product: p,
                            onTap: () => WebNav.goProduct(context, p),
                            onAddToBag: () => WebNav.addToBag(context, p),
                            onWishlist: () => WebNav.toggleWishlist(context, p),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
