import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:careaccess/core/constants/brand_assets.dart';

/// Theme-aware CareAccess logo widget that automatically switches between
/// light and dark mode logos based on the current theme brightness.
///
/// Usage:
/// ```dart
/// BrandLogo.icon(height: 48)
/// BrandLogo.wordmark(height: 32)
/// BrandLogo.lockup(height: 80)
/// ```
class BrandLogo extends StatelessWidget {
  final String lightAsset;
  final String darkAsset;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final BlendMode colorBlendMode;

  const BrandLogo._({
    required this.lightAsset,
    required this.darkAsset,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
  });

  /// CareAccess icon only (heart-shaped pathway)
  /// Automatically switches between light and dark variants
  const BrandLogo.icon({
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) : this._(
          lightAsset: BrandAssets.icon,
          darkAsset: BrandAssets.iconDark,
          height: height,
          width: width,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        );

  /// CareAccess wordmark only (text logo)
  /// Automatically switches between light and dark variants
  const BrandLogo.wordmark({
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) : this._(
          lightAsset: BrandAssets.wordmark,
          darkAsset: BrandAssets.wordmarkDark,
          height: height,
          width: width,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        );

  /// CareAccess full lockup (icon + wordmark)
  /// Automatically switches between light and dark variants
  const BrandLogo.lockup({
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) : this._(
          lightAsset: BrandAssets.lockup,
          darkAsset: BrandAssets.lockupDark,
          height: height,
          width: width,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetPath = isDark ? darkAsset : lightAsset;

    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
    );
  }
}
