import 'package:flutter/material.dart';

/// Exact color palette extracted from sword drill™ (by Flannelgraph) CSS tokens
/// (`index-CpBS3omB.css` and `brand-colors-DU7bTvcG.js`).
class AppColors {
  AppColors._();

  // Warm cream background: HSL(40, 14%, 96%)
  static const Color background = Color(0xFFF7F5F2);
  static const Color cream = Color(0xFFF7F5F2);

  // Foreground dark charcoal: HSL(0, 0%, 18%)
  static const Color foreground = Color(0xFF2E2E2E);

  // Pure white cards
  static const Color card = Color(0xFFFFFFFF);

  // Brand Primary Periwinkle Blue: HSL(233, 77%, 60%)
  static const Color primary = Color(0xFF4B5EE8);

  // Brand Primary End Purple: HSL(252, 69%, 62%)
  static const Color primaryEnd = Color(0xFF685AE0);

  // Secondary warm gray: HSL(40, 10%, 94%)
  static const Color secondary = Color(0xFFF2F0ED);

  // Muted surface & text: HSL(30, 8%, 90%) & HSL(0, 0%, 40%)
  static const Color muted = Color(0xFFE8E5E3);
  static const Color mutedForeground = Color(0xFF666666);

  // Signature Neon Lime Accent: HSL(75, 85%, 55%)
  static const Color neon = Color(0xFFB8EC2C);
  static const Color neonInk = Color(0xFF2B5916);

  // Correct / Success Forest Green: HSL(152, 30%, 37%)
  static const Color success = Color(0xFF427A5B);
  static const Color successLight = Color(0xFFE8F5EE);

  // Wrong / Destructive Crimson: HSL(0, 55%, 51%)
  static const Color wrong = Color(0xFFC63D3D);
  static const Color wrongLight = Color(0xFFFDECEC);

  // Borders: HSL(30, 10%, 88%)
  static const Color border = Color(0xFFE4E0DC);

  // Podium & Accents
  static const Color gold = Color(0xFFFACC15);
  static const Color goldDark = Color(0xFFCA8A04);
  static const Color silver = Color(0xFFCBD5E1);
  static const Color bronze = Color(0xFFD97706);
  static const Color navy = Color(0xFF0F172A);

  // Brand Gradients
  static const LinearGradient gradientBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryEnd],
  );

  static const LinearGradient gradientPurpleDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B2559),
      Color(0xFF362E73),
      Color(0xFF53368E),
    ],
  );

  static const LinearGradient gradientWarmPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5230A6),
      Color(0xFF2A256A),
      Color(0xFF131B34),
    ],
  );

  static const LinearGradient gradientFamilyWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4B5EE8),
      Color(0xFF7C3AED),
    ],
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get brandShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}
