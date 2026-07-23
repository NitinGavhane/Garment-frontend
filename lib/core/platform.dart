import 'package:flutter/foundation.dart' show kIsWeb;

/// Which of the two front-ends the customer is looking at.
///
/// The website is whatever runs in a browser; the installed app is everything
/// else. This is decided by **platform, never by window width** — a phone
/// browser must still get the website (resized to fit), and a tablet running
/// the installed app must still get the app design.
///
/// Before this existed, both surfaces were chosen by `width >= 900`, which gave
/// phone and tablet browsers the app design and gave tablet app users the
/// website. Screen width now only decides *layout* within the website; it never
/// decides *which* front-end you get.
bool get isWebsite => kIsWeb;

/// True for the installed Android/iOS app.
bool get isInstalledApp => !kIsWeb;
