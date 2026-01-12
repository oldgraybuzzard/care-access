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

  /// CareAccess icon only (heart-shaped pathway)
  /// Use for: App icons, favicons, small branding elements
  static const String icon = '../../assets/brand/careaccess_icon.svg';

  /// CareAccess wordmark only (text logo)
  /// Use for: Headers, navigation bars, minimal branding
  static const String wordmark = '../../assets/brand/careaccess_wordmark.svg';

  /// CareAccess full lockup (icon + wordmark)
  /// Use for: Login screens, splash screens, about pages
  static const String lockup = '../../assets/brand/careaccess_lockup.svg';
}

/// Brand information and legal
class BrandInfo {
  BrandInfo._(); // Private constructor to prevent instantiation

  /// Product name
  static const String productName = 'CareAccess';

  /// Product owner / company
  static const String owner = 'Melken TechWork';

  /// Copyright notice
  static const String copyright = '© 2026 Melken TechWork. All rights reserved.';

  /// Tagline
  static const String tagline = 'Built with care for children and families';

  /// Full attribution
  static const String attribution = 'CareAccess™ is a product of Melken TechWork';
}

