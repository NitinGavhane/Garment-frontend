import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/category.dart' as models;
import '../../../../providers/category_provider.dart';
import '../../../../providers/product_provider.dart';
import 'web_chrome.dart';
import 'web_ui.dart';

/// Website collections page: a grid of every live category from
/// [CategoryProvider]. Each card opens the Shop page filtered to that category.
class WebCollectionsPage extends StatefulWidget {
  const WebCollectionsPage({super.key});

  @override
  State<WebCollectionsPage> createState() => _WebCollectionsPageState();
}

class _WebCollectionsPageState extends State<WebCollectionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cats = context.read<CategoryProvider>();
      if (cats.categories.isEmpty && !cats.isLoading) cats.fetchCategories();
      final products = context.read<ProductProvider>();
      if (products.products.isEmpty && !products.isLoading) products.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final products = context.watch<ProductProvider>().products;
    final categories = provider.categories;

    int countFor(String id) => products.where((p) => p.categoryId == id).length;

    return WebScaffold(
      activeNav: 'COLLECTIONS',
      body: Column(
        children: [
          const WebPageHeader(
            centered: true,
            eyebrow: 'Explore Our',
            title: 'Collections',
            subtitle:
                'Browse our curated collections — from timeless ethnic wear to '
                'contemporary western styles for every member of the family.',
          ),
          WebSection(
            background: WebTokens.surface,
            topPad: 56,
            bottomPad: 80,
            child: _buildBody(context, provider, categories, countFor),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CategoryProvider provider,
    List<models.Category> categories,
    int Function(String) countFor,
  ) {
    if (provider.isLoading && categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator(color: WebTokens.blue)),
      );
    }
    if (categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            const Icon(Icons.category_outlined, size: 56, color: WebTokens.muted),
            const SizedBox(height: 16),
            Text('No collections available yet',
                style: WebTokens.display(24, color: WebTokens.ink)),
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        final columns = constraints.maxWidth >= 1000 ? 3 : 2;
        final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: categories
              .map((c) => SizedBox(
                    width: cardWidth,
                    child: _CategoryCard(
                      category: c,
                      count: countFor(c.id),
                      onTap: () => WebNav.goShop(context,
                          title: c.name, initialCategoryId: c.id),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}


class _CategoryCard extends StatefulWidget {
  final models.Category category;
  final int count;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.count, required this.onTap});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.category;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 320,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedScale(
                    scale: _hover ? 1.07 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: c.imageUrl != null && c.imageUrl!.isNotEmpty
                        ? WebImage(url: c.imageUrl!)
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [WebTokens.blueMid, WebTokens.blueDeep],
                              ),
                            ),
                            child: Center(
                                child: Icon(c.icon,
                                    size: 64, color: WebTokens.gold.withValues(alpha: 0.7))),
                          ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xE60C1547)],
                        stops: [0.4, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (c.gender.isNotEmpty && c.gender.toLowerCase() != 'unisex')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: WebTokens.gold,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(c.gender.toUpperCase(),
                                  style: WebTokens.sans(10,
                                      color: WebTokens.blueDeep, w: FontWeight.w700, spacing: 1)),
                            ),
                          ),
                        Text(c.name, style: WebTokens.display(24, color: Colors.white, w: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                                widget.count > 0
                                    ? '${widget.count} product${widget.count == 1 ? '' : 's'}'
                                    : 'Shop now',
                                style: WebTokens.sans(13, color: Colors.white70)),
                            const Spacer(),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.translationValues(_hover ? 4 : 0, 0, 0),
                              child: const Icon(Icons.arrow_forward,
                                  size: 18, color: WebTokens.goldBright),
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
        ),
      ),
    );
  }
}
