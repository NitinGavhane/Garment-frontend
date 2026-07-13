import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../models/cart_item.dart';
import '../../../../providers/cart_provider.dart';
import '../../../checkout/screens/checkout_screen.dart';
import 'web_chrome.dart';
import 'web_ui.dart';

/// Website shopping bag. Line items + live quantity controls on the left, an
/// order summary with totals + checkout CTA on the right. Wired to
/// [CartProvider].
class WebCartPage extends StatefulWidget {
  const WebCartPage({super.key});

  @override
  State<WebCartPage> createState() => _WebCartPageState();
}

class _WebCartPageState extends State<WebCartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return WebScaffold(
      body: Column(
        children: [
          WebPageHeader(
            eyebrow: 'Your Bag',
            title: 'Shopping Bag',
            subtitle: cart.isEmpty
                ? null
                : '${cart.count} item${cart.count == 1 ? '' : 's'} in your bag',
          ),
          WebSection(
            background: WebTokens.surface,
            topPad: 40,
            bottomPad: 80,
            child: cart.isEmpty ? _empty(context) : _content(context, cart),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, CartProvider cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              for (int i = 0; i < cart.items.length; i++) ...[
                _CartRow(
                  item: cart.items[i],
                  onInc: () => context.read<CartProvider>().updateQuantity(i, 1),
                  onDec: () => context.read<CartProvider>().updateQuantity(i, -1),
                  onRemove: () => context.read<CartProvider>().removeItem(i),
                ),
                if (i != cart.items.length - 1)
                  const Divider(height: 1, color: WebTokens.line),
              ],
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(flex: 3, child: _Summary(cart: cart)),
      ],
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 64, color: WebTokens.muted),
          const SizedBox(height: 20),
          Text('Your bag is empty', style: WebTokens.display(26, color: WebTokens.ink)),
          const SizedBox(height: 10),
          Text('Looks like you haven\'t added anything yet.',
              style: WebTokens.sans(15, color: WebTokens.muted)),
          const SizedBox(height: 28),
          WebGoldButton(
              label: 'CONTINUE SHOPPING',
              icon: Icons.arrow_forward,
              onTap: () => WebNav.goShop(context)),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;
  const _CartRow({
    required this.item,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 96,
              height: 120,
              child: WebImage(url: p.imageUrl),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p.brand.isNotEmpty)
                  Text(p.brand.toUpperCase(),
                      style: WebTokens.sans(11, color: WebTokens.muted, w: FontWeight.w600, spacing: 1)),
                const SizedBox(height: 4),
                Text(p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: WebTokens.sans(16, color: WebTokens.ink, w: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  [
                    if (item.selectedSize.isNotEmpty) 'Size: ${item.selectedSize}',
                    if (item.selectedColor.isNotEmpty) 'Colour: ${item.selectedColor}',
                  ].join('   •   '),
                  style: WebTokens.sans(13, color: WebTokens.muted),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _Stepper(qty: item.quantity, onInc: onInc, onDec: onDec),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: onRemove,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 16, color: WebTokens.muted),
                            const SizedBox(width: 4),
                            Text('Remove', style: WebTokens.sans(13, color: WebTokens.muted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text('₹${item.totalPrice.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: WebTokens.blue)),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int qty;
  final VoidCallback onInc;
  final VoidCallback onDec;
  const _Stepper({required this.qty, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WebTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onDec),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text('$qty', style: WebTokens.sans(14, color: WebTokens.ink, w: FontWeight.w600)),
          ),
          _btn(Icons.add, onInc),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              width: 38, height: 38, alignment: Alignment.center, child: Icon(icon, size: 16, color: WebTokens.ink)),
        ),
      );
}

class _Summary extends StatelessWidget {
  final CartProvider cart;
  const _Summary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.subtotal;
    // Flat 18% GST, no shipping — matches the backend's final_amount.
    final gst = subtotal * 0.18;
    final total = subtotal + gst;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: WebTokens.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WebTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: WebTokens.display(22, color: WebTokens.ink)),
          const SizedBox(height: 22),
          _row('Subtotal (${cart.count} item${cart.count == 1 ? '' : 's'})', '₹${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          _row('GST (18%)', '₹${gst.toStringAsFixed(0)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1, color: WebTokens.line),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: WebTokens.sans(16, color: WebTokens.ink, w: FontWeight.w700)),
              Text('₹${total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: WebTokens.blue)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: cart.isEmpty
                  ? null
                  : () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: WebTokens.gold,
                foregroundColor: WebTokens.blueDeep,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('PROCEED TO CHECKOUT',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: () => WebNav.goShop(context),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text('or continue shopping',
                    style: WebTokens.sans(13, color: WebTokens.blue, w: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: WebTokens.sans(14, color: WebTokens.body)),
        Text(value,
            style: WebTokens.sans(14,
                color: highlight ? WebTokens.success : WebTokens.ink, w: FontWeight.w600)),
      ],
    );
  }
}
