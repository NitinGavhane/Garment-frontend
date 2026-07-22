import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Public storefront origin. Shared links must be absolute so a customer can
/// paste them into WhatsApp. Keep in step with `SITE_URL` in the backend config.
const String kSiteUrl = 'https://dristifashions.com';

/// Builds and remembers referral links.
///
/// The flow this supports: A shares `…/product/<id>?ref=CODE` → B opens it →
/// the code is remembered on B's device → B signs up (possibly minutes later,
/// after browsing) → the code travels with the registration → B's first order
/// credits A. Before this, the web app never even read `?ref=`, so no referral
/// could ever pay out.
class ReferralLink {
  ReferralLink._();

  static const _prefsKey = 'pending_referral_code';
  static String? _code;

  /// The referral code this device arrived with, if any.
  static String? get pendingCode => _code;

  /// A shareable product link, carrying [referralCode] when the sharer has one.
  static String productUrl(String productId, {String? referralCode}) {
    final base = '$kSiteUrl/product/$productId';
    if (referralCode == null || referralCode.isEmpty) return base;
    return '$base?ref=$referralCode';
  }

  /// A shareable link to the storefront itself, for "share my code" actions.
  static String inviteUrl(String referralCode) => '$kSiteUrl/?ref=$referralCode';

  /// Reads `?ref=` from the launch URL and remembers it.
  ///
  /// On web [Uri.base] is the address bar, which is how a shared link is
  /// actually opened; on Android/iOS the deep-link handler passes the URI in.
  /// Returns the product id in the path (`/product/<id>`) when there is one, so
  /// the caller can open that product.
  static Future<String?> capture(Uri uri) async {
    final code = uri.queryParameters['ref'];
    if (code != null && code.trim().isNotEmpty) {
      _code = code.trim().toUpperCase();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _code!);
    }
    final segments = uri.pathSegments;
    final productId = segments.length >= 2 && segments[0] == 'product'
        ? segments[1]
        : null;
    if (_code != null) _trackClick(productId, _code!);
    return productId;
  }

  /// Restores a code captured on an earlier visit (the user may browse first
  /// and only sign up later, or come back the next day).
  static Future<void> restore() async {
    if (_code != null) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.isNotEmpty) _code = saved;
  }

  /// Called once the code has been used on a registration.
  static Future<void> clear() async {
    _code = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  /// Best-effort click attribution; a failure here must never block the app.
  static void _trackClick(String? productId, String code) {
    if (productId == null) return;
    ApiClient.post(
      '/api/v1/referral/track-click',
      body: {'product_id': productId, 'referral_code': code},
    ).catchError((_) => <String, dynamic>{});
  }
}
