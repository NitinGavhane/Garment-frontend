import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/wishlist_provider.dart';
import 'web_chrome.dart';
import 'web_product_card.dart';
import 'web_ui.dart';

/// Website wishlist: a grid of saved products from [WishlistProvider].
class WebWishlistPage extends StatefulWidget {
  const WebWishlistPage({super.key});

  @override
  State<WebWishlistPage> createState() => _WebWishlistPageState();
}

class _WebWishlistPageState extends State<WebWishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = context.read<WishlistProvider>();
      if (!w.isLoaded && !w.isLoading) w.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final products = wishlist.wishlistProducts;
    return WebScaffold(
      body: Column(
        children: [
          WebPageHeader(
            eyebrow: 'Saved For Later',
            title: 'My Wishlist',
            subtitle: '${products.length} item${products.length == 1 ? '' : 's'} saved',
          ),
          WebSection(
            background: WebTokens.surface,
            topPad: 48,
            bottomPad: 80,
            child: products.isEmpty ? _empty(context, wishlist) : _grid(context, products),
          ),
        ],
      ),
    );
  }

  Widget _grid(BuildContext context, List products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        final columns = constraints.maxWidth >= 1000 ? 4 : constraints.maxWidth >= 720 ? 3 : 2;
        final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final p in products)
              SizedBox(
                width: cardWidth,
                child: WebProductCard(
                  product: p,
                  onTap: () => WebNav.goProduct(context, p),
                  onAddToBag: () => WebNav.addToBag(context, p),
                  onWishlist: () => WebNav.toggleWishlist(context, p),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _empty(BuildContext context, WishlistProvider wishlist) {
    if (wishlist.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Center(child: CircularProgressIndicator(color: WebTokens.blue)),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          const Icon(Icons.favorite_border, size: 64, color: WebTokens.muted),
          const SizedBox(height: 20),
          Text('Your wishlist is empty', style: WebTokens.display(26, color: WebTokens.ink)),
          const SizedBox(height: 10),
          Text('Tap the heart on any product to save it here.',
              style: WebTokens.sans(15, color: WebTokens.muted)),
          const SizedBox(height: 28),
          WebGoldButton(
              label: 'DISCOVER PRODUCTS', icon: Icons.arrow_forward, onTap: () => WebNav.goShop(context)),
        ],
      ),
    );
  }
}

