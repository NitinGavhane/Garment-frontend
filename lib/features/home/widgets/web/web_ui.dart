import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dristi Fashions — website design system.
///
/// A cohesive token + primitive set used only by the desktop/website layout.
/// The mobile app never imports this; its UI is independent.
class WebTokens {
  WebTokens._();

  // Brand
  static const Color blue = Color(0xFF1A2A80);
  static const Color blueDeep = Color(0xFF0C1547);
  static const Color blueMid = Color(0xFF243AA0);
  static const Color gold = Color(0xFFC9A227);
  static const Color goldBright = Color(0xFFD9AF4E);

  // Neutrals / surfaces
  static const Color ink = Color(0xFF15172A);
  static const Color body = Color(0xFF4A4D63);
  static const Color muted = Color(0xFF8A8FA3);
  static const Color line = Color(0xFFE6E7F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF7F8FD);
  static const Color cream = Color(0xFFFAF6EC);

  // Layout
  static const double maxWidth = 1240;
  static const double gutter = 40;
  static const double sectionY = 72;

  // Type
  static TextStyle display(double size, {Color? color, FontWeight w = FontWeight.w700}) =>
      GoogleFonts.playfairDisplay(fontSize: size, fontWeight: w, color: color ?? ink, height: 1.1);

  static TextStyle serifItalic(double size, {Color? color}) =>
      GoogleFonts.playfairDisplay(fontSize: size, fontStyle: FontStyle.italic, color: color ?? gold);

  static TextStyle sans(double size,
          {Color? color, FontWeight w = FontWeight.w400, double spacing = 0, double height = 1.5}) =>
      GoogleFonts.poppins(
          fontSize: size, fontWeight: w, color: color ?? body, letterSpacing: spacing, height: height);

  static TextStyle overline(Color color) =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: color, letterSpacing: 3);
}

/// Centers content and caps it at the site max width.
class WebContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const WebContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: WebTokens.gutter),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: WebTokens.maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Full-bleed section band with a background, capped inner content, vertical rhythm.
class WebSection extends StatelessWidget {
  final Widget child;
  final Color background;
  final double topPad;
  final double bottomPad;
  const WebSection({
    super.key,
    required this.child,
    this.background = WebTokens.surface,
    this.topPad = WebTokens.sectionY,
    this.bottomPad = WebTokens.sectionY,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
      child: WebContainer(child: child),
    );
  }
}

/// Centered eyebrow + serif heading + optional subtitle.
class WebHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Color onDark;
  final bool dark;
  const WebHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.dark = false,
    this.onDark = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = dark ? onDark : WebTokens.ink;
    final subColor = dark ? onDark.withValues(alpha: 0.7) : WebTokens.muted;
    return Column(
      children: [
        Text(eyebrow.toUpperCase(), style: WebTokens.overline(WebTokens.gold)),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: WebTokens.display(38, color: titleColor)),
        const SizedBox(height: 14),
        Container(width: 60, height: 3, color: WebTokens.gold),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: 620,
            child: Text(subtitle!,
                textAlign: TextAlign.center, style: WebTokens.sans(15, color: subColor, height: 1.6)),
          ),
        ],
      ],
    );
  }
}

/// Gold filled button. Built with GestureDetector + Container (not a Material
/// button) so it renders reliably in the CanvasKit release build and matches
/// the rest of the website's interactive elements.
class WebGoldButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  const WebGoldButton({super.key, required this.label, this.icon, required this.onTap});

  @override
  State<WebGoldButton> createState() => _WebGoldButtonState();
}

class _WebGoldButtonState extends State<WebGoldButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          decoration: BoxDecoration(
            color: _hover ? WebTokens.goldBright : WebTokens.gold,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: WebTokens.blueDeep),
                const SizedBox(width: 10),
              ],
              Text(widget.label,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: WebTokens.blueDeep)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined button (gold border), adapts to light/dark backgrounds. Built with
/// GestureDetector + Container for reliable rendering (see [WebGoldButton]).
class WebOutlineButton extends StatefulWidget {
  final String label;
  final IconData? trailing;
  final VoidCallback onTap;
  final Color foreground;
  const WebOutlineButton({
    super.key,
    required this.label,
    this.trailing,
    required this.onTap,
    this.foreground = WebTokens.ink,
  });

  @override
  State<WebOutlineButton> createState() => _WebOutlineButtonState();
}

class _WebOutlineButtonState extends State<WebOutlineButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: _hover ? WebTokens.gold.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: WebTokens.gold, width: 1.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: widget.foreground)),
              if (widget.trailing != null) ...[
                const SizedBox(width: 10),
                Icon(widget.trailing, size: 18, color: widget.foreground),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Network image that fades in and degrades to a branded placeholder.
class WebImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  const WebImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (c, child, progress) =>
          progress == null ? child : Container(color: WebTokens.surfaceAlt),
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [WebTokens.blueMid, WebTokens.blueDeep],
          ),
        ),
        child: const Center(child: Icon(Icons.checkroom, color: WebTokens.gold, size: 48)),
      ),
    );
  }
}
