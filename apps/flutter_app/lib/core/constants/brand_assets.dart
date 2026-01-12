/// CareAccess Brand Assets
///
/// Centralized constants for brand logos and visual assets.
/// All assets are located in assets/brand/ folder.
///
/// Usage:
/// ```dart
/// import 'package:fcf_app/core/constants/brand_assets.dart';
///
/// SvgPicture.asset(BrandAssets.icon, height: 48);
/// ```

class BrandAssets {
  BrandAssets._(); // Private constructor to prevent instantiation

  // Light mode logos (default)

  /// CareAccess icon only (heart-shaped pathway) - Light mode
  /// Use for: App icons, favicons, small branding elements
  static const String icon = 'assets/brand/careaccess_icon.svg';

  /// CareAccess wordmark only (text logo) - Light mode
  /// Use for: Headers, navigation bars, minimal branding
  static const String wordmark = 'assets/brand/careaccess_wordmark.svg';

  /// CareAccess full lockup (icon + wordmark) - Light mode
  /// Use for: Login screens, splash screens, about pages
  static const String lockup = 'assets/brand/careaccess_lockup.svg';

  // Dark mode logos

  /// CareAccess icon only (heart-shaped pathway) - Dark mode
  /// Use for: App icons, favicons, small branding elements on dark backgrounds
  static const String iconDark = 'assets/brand/careaccess_icon_dark.svg';

  /// CareAccess wordmark only (text logo) - Dark mode
  /// Use for: Headers, navigation bars, minimal branding on dark backgrounds
  static const String wordmarkDark =
      'assets/brand/careaccess_wordmark_dark.svg';

  /// CareAccess full lockup (icon + wordmark) - Dark mode
  /// Use for: Login screens, splash screens, about pages on dark backgrounds
  static const String lockupDark = 'assets/brand/careaccess_lockup_dark.svg';

  // Favicons

  /// Favicon ICO file (multi-resolution)
  /// Use for: Web browsers, bookmarks
  static const String favicon = 'assets/brand/favicon.ico';

  /// Favicon 16x16 PNG
  static const String favicon16 = 'assets/brand/favicon_16x16.png';

  /// Favicon 32x32 PNG
  static const String favicon32 = 'assets/brand/favicon_32x32.png';

  /// Favicon 48x48 PNG
  static const String favicon48 = 'assets/brand/favicon_48x48.png';

  /// Favicon 64x64 PNG
  static const String favicon64 = 'assets/brand/favicon_64x64.png';
}

/// Brand information and legal
class BrandInfo {
  BrandInfo._(); // Private constructor to prevent instantiation

  /// Product name
  static const String productName = 'CareAccess';

  /// Product owner / company
  static const String owner = 'Melken TechWork';

  /// Copyright notice
  static const String copyright =
      '© 2026 Melken TechWork. All rights reserved.';

  /// Tagline
  static const String tagline = 'Built with care for children and families';

  /// Full attribution
  static const String attribution =
      'CareAccess™ is a product of Melken TechWork';
}
