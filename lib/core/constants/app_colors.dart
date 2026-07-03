import 'package:flutter/material.dart';

/// Dristi Fashions brand palette.
///
/// Derived from the logo: a deep **royal blue** field with **gold** accents.
/// Royal blue drives primary actions/branding; gold is the luxury accent used
/// for highlights, ratings, festive callouts and premium badges. Surfaces stay
/// light and cool for readability in a shopping context.
class AppColors {
  AppColors._();

  // ── Primary · Royal Blue ────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A2A80);
  static const Color primaryDark = Color(0xFF10195E);
  static const Color primaryLight = Color(0xFFDDE2F8);
  static const Color primaryContainer = Color(0xFF243AA0);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color onPrimaryContainer = Color(0xFFffffff);
  static const Color inversePrimary = Color(0xFFAFB8EE);

  // ── Secondary · Slate neutral ───────────────────────────────────────────
  static const Color secondary = Color(0xFF5b5f73);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color secondaryContainer = Color(0xFFe0e2ec);
  static const Color onSecondaryContainer = Color(0xFF454858);

  // ── Tertiary · Gold accent ──────────────────────────────────────────────
  static const Color tertiary = Color(0xFFB8901F);
  static const Color onTertiary = Color(0xFFffffff);
  static const Color tertiaryContainer = Color(0xFFF3E4B2);
  static const Color onTertiaryContainer = Color(0xFF4A3B00);

  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFffffff);
  static const Color errorContainer = Color(0xFFffdad6);
  static const Color onErrorContainer = Color(0xFF93000a);

  // ── Surfaces · cool light ───────────────────────────────────────────────
  static const Color surface = Color(0xFFFBFBFE);
  static const Color surfaceDim = Color(0xFFDBDCE6);
  static const Color surfaceBright = Color(0xFFFBFBFE);
  static const Color surfaceContainerLowest = Color(0xFFffffff);
  static const Color surfaceContainerLow = Color(0xFFF3F4FB);
  static const Color surfaceContainer = Color(0xFFEDEEF7);
  static const Color surfaceContainerHigh = Color(0xFFE7E9F4);
  static const Color surfaceContainerHighest = Color(0xFFE1E3F0);
  static const Color surfaceVariant = Color(0xFFE1E3F0);
  static const Color surfaceWarm = Color(0xFFEEF1FF);
  static const Color onSurface = Color(0xFF181A2C);
  static const Color onSurfaceVariant = Color(0xFF44465A);
  static const Color inverseSurface = Color(0xFF2E3042);
  static const Color inverseOnSurface = Color(0xFFEFF0FB);

  static const Color outline = Color(0xFF757892);
  static const Color outlineVariant = Color(0xFFC5C7D8);
  static const Color surfaceTint = Color(0xFF1A2A80);

  static const Color background = Color(0xFFF7F8FD);
  static const Color onBackground = Color(0xFF181A2C);
  static const Color scaffoldBg = Color(0xFFF7F8FD);

  // ── Semantic accents ────────────────────────────────────────────────────
  static const Color urgencyOrange = Color(0xFFFF6B00);
  static const Color discountGreen = Color(0xFF27AE60);
  static const Color festiveGold = Color(0xFFC9A227);
  static const Color grayText = Color(0xFF6B6E7E);
  static const Color grayDivider = Color(0xFFE2E3ED);

  static const Color textPrimary = Color(0xFF181A2C);
  static const Color textSecondary = Color(0xFF44465A);
  static const Color textMuted = Color(0xFF757892);
  static const Color textHint = Color(0xFF9AA0B4);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  static const Color rating = Color(0xFFE0A81E);

  static const Color border = Color(0xFFD5D7E4);
  static const Color divider = Color(0xFFE2E3ED);

  // ── Brand tokens (kept for legacy widget references) ─────────────────────
  static const Color brandRed = Color(0xFF1A2A80);
  static const Color brandDark = Color(0xFF181A2C);
  static const Color saleOrange = Color(0xFFFF6B00);
  static const Color trustGreen = Color(0xFF27AE60);
  static const Color brandGold = Color(0xFFC9A227);
  static const Color brandGoldLight = Color(0xFFE6C766);

  static const Color nykaaBlack = Color(0xFF181A2C);
  static const Color nykaaPink = Color(0xFF1A2A80);
  static const Color nykaaDarkPink = Color(0xFF10195E);
  static const Color nykaaLightPink = Color(0xFFDDE2F8);
  static const Color nykaaGold = Color(0xFFC9A227);
  static const Color nykaaBg = Color(0xFFFBFBFE);

  static const Color topBarBg = Color(0xFFFBFBFE);
  static const Color ctaPink = Color(0xFF1A2A80);
  static const Color badgeNew = Color(0xFFC9A227);
  static const Color heroBg = Color(0xFFEEF1FF);

  // ── Category accents ────────────────────────────────────────────────────
  static const Color categoryWomen = Color(0xFF1A2A80);
  static const Color categoryMen = Color(0xFF3F51B5);
  static const Color categoryKids = Color(0xFFFF9800);
  static const Color categoryHome = Color(0xFF4CAF50);
  static const Color categoryFootwear = Color(0xFF9C27B0);
  static const Color categoryAccessories = Color(0xFF009688);
  static const Color categoryBeauty = Color(0xFFC9A227);

  static const List<Color> productGradients = [
    Color(0xFF1A2A80),
    Color(0xFF243AA0),
    Color(0xFF3D51B5),
    Color(0xFF1A2A80),
    Color(0xFF243AA0),
    Color(0xFF3D51B5),
    Color(0xFF1A2A80),
    Color(0xFF243AA0),
    Color(0xFF3D51B5),
    Color(0xFF1A2A80),
    Color(0xFF243AA0),
    Color(0xFF3D51B5),
    Color(0xFF1A2A80),
    Color(0xFF243AA0),
    Color(0xFF3D51B5),
    Color(0xFF1A2A80),
  ];
}
