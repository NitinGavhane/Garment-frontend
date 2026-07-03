import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/category.dart' as models;
import '../../../../models/product.dart';
import '../../../../providers/category_provider.dart';
import '../../../../providers/product_provider.dart';
import 'web_chrome.dart';
import 'web_product_card.dart';
import 'web_ui.dart';

/// Website product-listing page. Reads live products from [ProductProvider]
/// and categories from [CategoryProvider], then filters/sorts them client-side
/// so navigating here never disturbs the home page's loaded data.
class WebShopPage extends StatefulWidget {
  final String title;
  final String? initialGender;
  final String? initialCategoryId;
  final String? initialSearch;
  final bool onlyNew;

  const WebShopPage({
    super.key,
    this.title = 'Shop',
    this.initialGender,
    this.initialCategoryId,
    this.initialSearch,
    this.onlyNew = false,
  });

  @override
  State<WebShopPage> createState() => _WebShopPageState();
}

enum _Sort { featured, priceLow, priceHigh, newest, rating }

class _WebShopPageState extends State<WebShopPage> {
  late String _gender;
  String? _categoryId;
  late String _search;
  _PriceBand _price = _PriceBand.all;
  _Sort _sort = _Sort.featured;

  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gender = widget.initialGender ?? 'ALL';
    _categoryId = widget.initialCategoryId;
    _search = widget.initialSearch ?? '';
    _searchCtrl.text = _search;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final products = context.read<ProductProvider>();
      if (products.products.isEmpty && !products.isLoading) {
        products.fetchProducts();
      }
      final cats = context.read<CategoryProvider>();
      if (cats.categories.isEmpty && !cats.isLoading) {
        cats.fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> _apply(List<Product> all) {
    Iterable<Product> out = all;
    if (widget.onlyNew) out = out.where((p) => p.isNew);
    if (_gender != 'ALL') {
      out = out.where((p) => p.gender.toUpperCase() == _gender);
    }
    if (_categoryId != null) {
      out = out.where((p) => p.categoryId == _categoryId);
    }
    out = out.where(_price.contains);
    if (_search.trim().isNotEmpty) {
      final q = _search.toLowerCase().trim();
      out = out.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q));
    }
    final list = out.toList();
    switch (_sort) {
      case _Sort.featured:
        list.sort((a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0));
        break;
      case _Sort.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _Sort.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _Sort.newest:
        list.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
        break;
      case _Sort.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final categories = context.watch<CategoryProvider>().categories;
    final results = _apply(provider.products);

    return WebScaffold(
      activeNav: widget.onlyNew ? 'NEW ARRIVALS' : 'SHOP',
      body: Column(
        children: [
          WebPageHeader(
            eyebrow: 'Dristi Fashions  /  ${widget.title}',
            title: widget.title,
            subtitle:
                '${results.length} product${results.length == 1 ? '' : 's'} available',
          ),
          WebSection(
            background: WebTokens.surface,
            topPad: 40,
            bottomPad: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: _FilterSidebar(
                    categories: categories,
                    gender: _gender,
                    categoryId: _categoryId,
                    price: _price,
                    onGender: (g) => setState(() => _gender = g),
                    onCategory: (id) => setState(() => _categoryId = id),
                    onPrice: (p) => setState(() => _price = p),
                    onClear: () => setState(() {
                      _gender = 'ALL';
                      _categoryId = null;
                      _price = _PriceBand.all;
                      _search = '';
                      _searchCtrl.clear();
                    }),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _ResultsArea(
                    provider: provider,
                    results: results,
                    searchCtrl: _searchCtrl,
                    sort: _sort,
                    onSearch: (v) => setState(() => _search = v),
                    onSort: (s) => setState(() => _sort = s),
                    onRetry: () => context.read<ProductProvider>().fetchProducts(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter sidebar ──────────────────────────────────────────────────────────

class _FilterSidebar extends StatelessWidget {
  final List<models.Category> categories;
  final String gender;
  final String? categoryId;
  final _PriceBand price;
  final void Function(String) onGender;
  final void Function(String?) onCategory;
  final void Function(_PriceBand) onPrice;
  final VoidCallback onClear;

  const _FilterSidebar({
    required this.categories,
    required this.gender,
    required this.categoryId,
    required this.price,
    required this.onGender,
    required this.onCategory,
    required this.onPrice,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WebTokens.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WebTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FILTERS', style: WebTokens.overline(WebTokens.gold)),
              GestureDetector(
                onTap: onClear,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text('Clear all',
                      style: WebTokens.sans(12, color: WebTokens.blue, w: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _FilterGroup(
            label: 'Gender',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final g in const ['ALL', 'MEN', 'WOMEN', 'KIDS'])
                  _Chip(
                    label: g == 'ALL' ? 'All' : g[0] + g.substring(1).toLowerCase(),
                    selected: gender == g,
                    onTap: () => onGender(g),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _FilterGroup(
            label: 'Price',
            child: Column(
              children: [
                for (final band in _PriceBand.values)
                  _RadioRow(
                    label: band.label,
                    selected: price == band,
                    onTap: () => onPrice(band),
                  ),
              ],
            ),
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 24),
            _FilterGroup(
              label: 'Category',
              child: Column(
                children: [
                  _RadioRow(
                    label: 'All Categories',
                    selected: categoryId == null,
                    onTap: () => onCategory(null),
                  ),
                  for (final c in categories)
                    _RadioRow(
                      label: c.name,
                      selected: categoryId == c.id,
                      onTap: () => onCategory(c.id),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FilterGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WebTokens.sans(14, color: WebTokens.ink, w: FontWeight.w700)),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? WebTokens.blue : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? WebTokens.blue : WebTokens.line),
          ),
          child: Text(label,
              style: WebTokens.sans(13,
                  color: selected ? Colors.white : WebTokens.body,
                  w: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioRow({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  size: 18, color: selected ? WebTokens.gold : WebTokens.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: WebTokens.sans(13,
                        color: selected ? WebTokens.ink : WebTokens.body,
                        w: selected ? FontWeight.w600 : FontWeight.w400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Results area ────────────────────────────────────────────────────────────

class _ResultsArea extends StatelessWidget {
  final ProductProvider provider;
  final List<Product> results;
  final TextEditingController searchCtrl;
  final _Sort sort;
  final void Function(String) onSearch;
  final void Function(_Sort) onSort;
  final VoidCallback onRetry;

  const _ResultsArea({
    required this.provider,
    required this.results,
    required this.searchCtrl,
    required this.sort,
    required this.onSearch,
    required this.onSort,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _SearchField(controller: searchCtrl, onChanged: onSearch)),
            const SizedBox(width: 16),
            _SortDropdown(value: sort, onChanged: onSort),
          ],
        ),
        const SizedBox(height: 28),
        _buildBody(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (provider.isLoading && provider.products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator(color: WebTokens.blue)),
      );
    }
    if (provider.error != null && provider.products.isEmpty) {
      return _EmptyState(
        icon: Icons.cloud_off,
        title: 'Couldn\'t load products',
        subtitle: provider.error!,
        actionLabel: 'RETRY',
        onAction: onRetry,
      );
    }
    if (results.isEmpty) {
      return const _EmptyState(
        icon: Icons.search_off,
        title: 'No products match your filters',
        subtitle: 'Try adjusting or clearing your filters to see more.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        final columns = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 720
                ? 3
                : 2;
        final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: results
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
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: WebTokens.sans(14, color: WebTokens.ink),
        decoration: InputDecoration(
          hintText: 'Search products, brands…',
          hintStyle: WebTokens.sans(14, color: WebTokens.muted),
          prefixIcon: const Icon(Icons.search, color: WebTokens.muted, size: 20),
          filled: true,
          fillColor: WebTokens.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: WebTokens.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: WebTokens.blue, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final _Sort value;
  final void Function(_Sort) onChanged;
  const _SortDropdown({required this.value, required this.onChanged});

  static const Map<_Sort, String> _labels = {
    _Sort.featured: 'Featured',
    _Sort.newest: 'Newest',
    _Sort.priceLow: 'Price: Low to High',
    _Sort.priceHigh: 'Price: High to Low',
    _Sort.rating: 'Top Rated',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: WebTokens.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WebTokens.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_Sort>(
          value: value,
          icon: const Icon(Icons.expand_more, color: WebTokens.muted),
          style: WebTokens.sans(14, color: WebTokens.ink, w: FontWeight.w500),
          borderRadius: BorderRadius.circular(10),
          onChanged: (v) => v == null ? null : onChanged(v),
          items: [
            for (final e in _labels.entries)
              DropdownMenuItem(value: e.key, child: Text('Sort: ${e.value}')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 90),
      child: Column(
        children: [
          Icon(icon, size: 56, color: WebTokens.muted),
          const SizedBox(height: 18),
          Text(title, style: WebTokens.display(24, color: WebTokens.ink)),
          const SizedBox(height: 10),
          SizedBox(
            width: 420,
            child: Text(subtitle,
                textAlign: TextAlign.center,
                style: WebTokens.sans(14, color: WebTokens.muted, height: 1.6)),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            WebOutlineButton(label: actionLabel!, onTap: onAction!),
          ],
        ],
      ),
    );
  }
}

// ─── Price bands ─────────────────────────────────────────────────────────────

enum _PriceBand {
  all('All Prices', 0, double.infinity),
  under999('Under ₹999', 0, 999),
  mid('₹999 – ₹1,999', 999, 1999),
  upper('₹1,999 – ₹2,999', 1999, 2999),
  premium('₹2,999 & above', 2999, double.infinity);

  final String label;
  final double min;
  final double max;
  const _PriceBand(this.label, this.min, this.max);

  bool contains(Product p) => p.price >= min && p.price < max;
}
