import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'web_ui.dart';
import 'web_chrome.dart';

/// Rich multi-column website footer with newsletter, link columns, socials.
class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [WebTokens.blueDeep, WebTokens.blueAbyss],
        ),
      ),
      child: Column(
        children: [
          const _Newsletter(),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          WebContainer(
            padding: const EdgeInsets.symmetric(horizontal: WebTokens.gutter, vertical: 56),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 4, child: _BrandColumn()),
                const SizedBox(width: 40),
                const Expanded(flex: 2, child: _LinkColumn('SHOP', [
                  'Ladies Wear', "Men's Wear", 'Kids Wear', 'Ethnic Wear', 'Western Wear',
                ])),
                const Expanded(flex: 2, child: _LinkColumn('COMPANY', [
                  'About Us', 'Contact Us', 'Careers', 'Blog', 'Store Locator',
                ])),
                const Expanded(flex: 2, child: _LinkColumn('HELP', [
                  'Shipping & Returns', 'Size Guide', 'Track Order', 'FAQs', 'Privacy Policy',
                ])),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          WebContainer(
            padding: const EdgeInsets.symmetric(horizontal: WebTokens.gutter, vertical: 24),
            child: Row(
              children: [
                Text('© 2026 Dristi Fashions. All Rights Reserved.',
                    style: WebTokens.sans(13, color: Colors.white54)),
                const Spacer(),
                Text('Fashion That Reflects Your Personality',
                    style: WebTokens.serifItalic(14, color: WebTokens.goldBright)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Newsletter extends StatefulWidget {
  const _Newsletter();

  @override
  State<_Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<_Newsletter> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _subscribe() {
    final email = _email.text.trim();
    final valid = email.contains('@') && email.contains('.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(valid
          ? 'Thanks for subscribing — check your inbox for member offers!'
          : 'Please enter a valid email address.'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: WebTokens.blueDeep,
    ));
    if (valid) _email.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WebContainer(
      padding: const EdgeInsets.symmetric(horizontal: WebTokens.gutter, vertical: 44),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Join the Dristi circle',
                    style: WebTokens.display(26, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Get early access to new collections and exclusive member offers.',
                    style: WebTokens.sans(14, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: TextField(
                      controller: _email,
                      onSubmitted: (_) => _subscribe(),
                      style: WebTokens.sans(14, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: WebTokens.sans(14, color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: WebTokens.goldBright, width: 1.4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                WebGoldButton(label: 'SUBSCRIBE', onTap: _subscribe),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/logo.jpg', width: 46, height: 46, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Text('DRISTI FASHIONS',
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: WebTokens.goldBright,
                    letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: 300,
          child: Text(
            'Premium ladies, men\'s, kids and ethnic collections crafted with '
            'perfection, comfort and elegance.',
            style: WebTokens.sans(14, color: Colors.white70, height: 1.7),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            _Social(Icons.facebook, 'Facebook'),
            _Social(Icons.camera_alt_outlined, 'Instagram'),
            _Social(Icons.alternate_email, 'X (Twitter)'),
            _Social(Icons.play_circle_outline, 'YouTube'),
          ],
        ),
      ],
    );
  }
}

class _Social extends StatelessWidget {
  final IconData icon;
  final String name;
  const _Social(this.icon, this.name);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Follow Dristi Fashions on $name'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: WebTokens.blueDeep,
        )),
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: WebTokens.gold.withValues(alpha: 0.5)),
          ),
          child: Icon(icon, size: 18, color: WebTokens.goldBright),
        ),
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const _LinkColumn(this.title, this.links);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: WebTokens.overline(WebTokens.goldBright)),
        const SizedBox(height: 20),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FooterLink(link, onTap: () => WebNav.footerLink(context, link)),
          ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(this.label, {required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: WebTokens.sans(14,
              color: _hover ? WebTokens.goldBright : Colors.white70,
              w: _hover ? FontWeight.w500 : FontWeight.w400),
        ),
      ),
    );
  }
}
