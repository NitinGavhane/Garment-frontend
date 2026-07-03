import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../orders/screens/order_list_screen.dart';
import '../../../profile/screens/address_list_screen.dart';
import 'web_chrome.dart';
import 'web_ui.dart';

/// Website account area: profile summary + quick links to orders, wishlist,
/// bag and addresses, plus sign-out. Wired to [AuthProvider].
class WebAccountPage extends StatelessWidget {
  const WebAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return WebScaffold(
      body: Column(
        children: [
          WebPageHeader(
            eyebrow: 'My Account',
            title: 'Hello, ${user?.fullName ?? 'Guest'}',
            subtitle: user?.email,
          ),
          WebSection(
            background: WebTokens.surface,
            topPad: 48,
            bottomPad: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _ProfileCard(context: context)),
                const SizedBox(width: 32),
                Expanded(flex: 6, child: _Links(context: context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ProfileCard extends StatelessWidget {
  final BuildContext context;
  const _ProfileCard({required this.context});

  @override
  Widget build(BuildContext _) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
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
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: WebTokens.blue,
                child: Text(
                  (user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'G').toUpperCase(),
                  style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.fullName ?? 'Guest',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: WebTokens.sans(18, color: WebTokens.ink, w: FontWeight.w700)),
                    if (user?.isVerified == true)
                      Row(
                        children: [
                          const Icon(Icons.verified, size: 14, color: WebTokens.gold),
                          const SizedBox(width: 4),
                          Text('Verified', style: WebTokens.sans(12, color: WebTokens.muted)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _info(Icons.email_outlined, 'Email', user?.email ?? '—'),
          _info(Icons.phone_outlined, 'Phone', user?.phone ?? '—'),
          _info(Icons.account_balance_wallet_outlined, 'Wallet', '₹${(user?.walletBalance ?? 0).toStringAsFixed(0)}'),
          if ((user?.referralCode ?? '').isNotEmpty)
            _info(Icons.card_giftcard_outlined, 'Referral code', user!.referralCode),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) WebNav.goHome(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFC0392B),
                side: const BorderSide(color: Color(0x33C0392B)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: Text('SIGN OUT',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: WebTokens.muted),
          const SizedBox(width: 12),
          Text('$label:', style: WebTokens.sans(13, color: WebTokens.muted)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: WebTokens.sans(14, color: WebTokens.ink, w: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _Links extends StatelessWidget {
  final BuildContext context;
  const _Links({required this.context});

  @override
  Widget build(BuildContext _) {
    final tiles = <(IconData, String, String, VoidCallback)>[
      (Icons.receipt_long_outlined, 'My Orders', 'Track & manage your orders',
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderListScreen()))),
      (Icons.favorite_border, 'Wishlist', 'Products you\'ve saved', () => WebNav.goWishlist(context)),
      (Icons.shopping_bag_outlined, 'Shopping Bag', 'Review items in your bag', () => WebNav.goCart(context)),
      (Icons.location_on_outlined, 'Addresses', 'Manage delivery addresses',
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressListScreen()))),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 2.6,
      children: [for (final t in tiles) _LinkTile(icon: t.$1, title: t.$2, subtitle: t.$3, onTap: t.$4)],
    );
  }
}

class _LinkTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _LinkTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  State<_LinkTile> createState() => _LinkTileState();
}

class _LinkTileState extends State<_LinkTile> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: WebTokens.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _hover ? WebTokens.gold : WebTokens.line),
            boxShadow: [
              BoxShadow(
                  color: WebTokens.blueDeep.withValues(alpha: _hover ? 0.10 : 0.04),
                  blurRadius: _hover ? 20 : 10,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: WebTokens.cream, borderRadius: BorderRadius.circular(12)),
                child: Icon(widget.icon, color: WebTokens.gold, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.title, style: WebTokens.sans(16, color: WebTokens.ink, w: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: WebTokens.sans(12, color: WebTokens.muted)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, size: 18, color: _hover ? WebTokens.gold : WebTokens.muted),
            ],
          ),
        ),
      ),
    );
  }
}
