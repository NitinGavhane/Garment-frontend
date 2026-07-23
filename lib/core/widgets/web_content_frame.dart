import 'package:flutter/material.dart';

import '../platform.dart';

/// Centres an app screen in a readable column when it is shown on the website.
///
/// Five screens are shared between the two front-ends — Checkout, My Orders,
/// Addresses, Wallet and Refer & Earn. Stretched across a 1440px desktop
/// browser a phone-shaped form looks broken; this keeps them at a comfortable
/// measure without maintaining a second copy of each screen.
///
/// On the installed app it does nothing at all.
class WebContentFrame extends StatelessWidget {
  final Widget child;

  /// Widest the content is allowed to get on the website.
  final double maxWidth;

  const WebContentFrame({super.key, required this.child, this.maxWidth = 760});

  @override
  Widget build(BuildContext context) {
    if (!isWebsite) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
