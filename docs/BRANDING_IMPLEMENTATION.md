# CareAccess Branding Implementation

## Overview

This document describes the implementation of the CareAccess brand identity throughout the Flutter application, including the new Material 3 theme, logo integration, and brand consistency guidelines.

## Brand Assets

### Logo Files
Located in `assets/brand/`:

**Light Mode (Default):**
- `careaccess_icon.svg` - Icon only (heart-shaped pathway)
- `careaccess_wordmark.svg` - Text logo only
- `careaccess_lockup.svg` - Full logo (icon + wordmark)

**Dark Mode:**
- `careaccess_icon_dark.svg` - Icon for dark backgrounds
- `careaccess_wordmark_dark.svg` - Wordmark for dark backgrounds
- `careaccess_lockup_dark.svg` - Full logo for dark backgrounds

**Favicons:**
- `favicon.ico` - Multi-resolution ICO file
- `favicon_16x16.png` - 16x16 PNG
- `favicon_32x32.png` - 32x32 PNG
- `favicon_48x48.png` - 48x48 PNG
- `favicon_64x64.png` - 64x64 PNG

### Brand Guide
See `docs/CAREACCESS_BRAND_GUIDE.md` for complete brand guidelines.

## Theme Implementation

### Theme Files
**File:** `apps/flutter_app/lib/core/theme/app_theme.dart`

The theme has been completely redesigned to match the CareAccess brand with full dark mode support:

#### Color Palette

**Light Mode:**
```dart
// Core brand colors
Teal: #1F6F78 (Primary)
Navy: #243A5E (Secondary, text)

// Supporting colors
Sage: #9DB8A0
Warm Gray: #6B7280
Sand: #F4F1EC

// Semantic colors
Success: #1F8A70
Warning: #F59E0B
Danger: #DC2626

// Backgrounds
Background: #F7FAFA
Surface: #FFFFFF
```

**Dark Mode:**
```dart
// Core brand colors (same)
Teal: #1F6F78 (Primary)
Sage: #9DB8A0 (Secondary accent)

// Dark backgrounds
Dark Background: #121212
Dark Surface: #1E1E1E
Dark Surface Variant: #2C2C2C

// Text: White and White70
```

#### Material 3 Components
- **Cards:** Rounded corners (18px), subtle elevation
- **Buttons:** Rounded (16px), brand colors
- **Input Fields:** Rounded (14px), sand-colored fill
- **Chips:** Rounded (14px), sage/teal accents
- **Typography:** Navy text, bold headings, readable body

### Brand Constants
**File:** `apps/flutter_app/lib/core/constants/brand_assets.dart`

Centralized constants for:
- Light mode logo asset paths
- Dark mode logo asset paths
- Favicon asset paths
- Product name and tagline
- Copyright and attribution
- Melken TechWork ownership

### Theme-Aware Logo Widget
**File:** `apps/flutter_app/lib/shared/widgets/brand_logo.dart`

Smart widget that automatically switches between light and dark logos based on theme:
- `BrandLogo.icon()` - Icon only
- `BrandLogo.wordmark()` - Wordmark only
- `BrandLogo.lockup()` - Full lockup

The widget detects the current theme brightness and displays the appropriate logo variant.

## UI Integration

### 1. Login Screen
**File:** `apps/flutter_app/lib/features/auth/presentation/login_screen.dart`

**Changes:**
- Replaced generic icon with CareAccess full lockup logo
- Logo displays at 80px height
- Automatically switches to dark logo in dark mode
- Clean, professional first impression

### 2. App Drawer
**File:** `apps/flutter_app/lib/shared/widgets/app_drawer.dart`

**Changes:**
- Custom DrawerHeader with teal background
- CareAccess wordmark logo (white, 32px)
- Automatically switches to dark logo in dark mode
- User name and email in white text
- Footer with Melken TechWork attribution and tagline

### 3. About Screen
**File:** `apps/flutter_app/lib/features/settings/presentation/about_screen.dart`

**Changes:**
- CareAccess full lockup logo at top (100px)
- Automatically switches to dark logo in dark mode
- Brand tagline: "Built with care for children and families"
- Product attribution: "CareAccess™ is a product of Melken TechWork"
- Updated copyright: "© 2026 Melken TechWork. All rights reserved."

## Dependencies

### Added Package
```yaml
flutter_svg: ^2.0.9
```

Required for rendering SVG logo files.

### Asset Configuration
Updated `pubspec.yaml`:
```yaml
flutter:
  assets:
    # Light mode logos
    - ../../assets/brand/careaccess_icon.svg
    - ../../assets/brand/careaccess_wordmark.svg
    - ../../assets/brand/careaccess_lockup.svg
    # Dark mode logos
    - ../../assets/brand/careaccess_icon_dark.svg
    - ../../assets/brand/careaccess_wordmark_dark.svg
    - ../../assets/brand/careaccess_lockup_dark.svg
    # Favicons
    - ../../assets/brand/favicon.ico
    - ../../assets/brand/favicon_16x16.png
    - ../../assets/brand/favicon_32x32.png
    - ../../assets/brand/favicon_48x48.png
    - ../../assets/brand/favicon_64x64.png
```

## Usage Guidelines

### Using Brand Colors
```dart
import 'package:fcf_app/core/theme/app_theme.dart';

// In your widget
Container(
  color: CareAccessColors.teal,
  child: Text(
    'Hello',
    style: TextStyle(color: CareAccessColors.navy),
  ),
)
```

### Using Brand Assets (Theme-Aware)
```dart
import 'package:fcf_app/shared/widgets/brand_logo.dart';
import 'package:fcf_app/core/constants/brand_assets.dart';

// Display logo (automatically switches for dark mode)
const BrandLogo.lockup(height: 80)
const BrandLogo.wordmark(height: 32)
const BrandLogo.icon(height: 48)

// With custom color
const BrandLogo.wordmark(
  height: 32,
  color: Colors.white,
)

// Display attribution
Text(BrandInfo.attribution)
```

### Using Brand Assets (Manual)
```dart
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fcf_app/core/constants/brand_assets.dart';

// Light mode logo
SvgPicture.asset(
  BrandAssets.lockup,
  height: 80,
)

// Dark mode logo
SvgPicture.asset(
  BrandAssets.lockupDark,
  height: 80,
)
```

### Logo Usage Rules
1. **Icon only** - Use for app icons, favicons, small spaces
2. **Wordmark only** - Use for headers, navigation, minimal branding
3. **Full lockup** - Use for login, splash, about pages, marketing
4. **Always use BrandLogo widget** - Automatically handles light/dark mode switching
5. **Dark variants** - Only use manually when BrandLogo widget isn't suitable

## Brand Consistency Checklist

- ✅ All screens use CareAccessTheme (light and dark)
- ✅ Login screen shows full lockup logo (theme-aware)
- ✅ App drawer shows wordmark and attribution (theme-aware)
- ✅ About screen shows full branding (theme-aware)
- ✅ Copyright shows Melken TechWork ownership
- ✅ Tagline appears in appropriate places
- ✅ Colors match brand guide
- ✅ Typography uses navy for text (light) / white (dark)
- ✅ Buttons and cards use rounded corners
- ✅ No generic icons replacing brand logos
- ✅ Dark mode fully supported with appropriate logo variants
- ✅ BrandLogo widget used for automatic theme switching

## Next Steps

### Recommended Enhancements
1. **Splash Screen** - Add CareAccess logo to app launch
2. **App Icon** - Use `careaccess_icon.svg` for mobile app icon
3. **Web Favicon** - Configure favicon when web support is enabled
4. **Loading States** - Show logo during data loading
5. **Empty States** - Use brand colors and messaging
6. **Error Pages** - Maintain brand consistency

### Future Considerations
1. Add Inter font family for better typography
2. ✅ ~~Create dark theme variant~~ (DONE)
3. Add brand animations (logo reveal, transitions)
4. Create branded illustrations for empty states
5. Design branded error and success icons
6. Add theme switcher UI for user preference

## Files Modified

### Created
- `apps/flutter_app/lib/core/constants/brand_assets.dart`
- `apps/flutter_app/lib/shared/widgets/brand_logo.dart` (theme-aware logo widget)
- `docs/BRANDING_IMPLEMENTATION.md`

### Updated
- `apps/flutter_app/lib/core/theme/app_theme.dart` (complete rewrite with dark mode)
- `apps/flutter_app/lib/features/auth/presentation/login_screen.dart` (uses BrandLogo)
- `apps/flutter_app/lib/shared/widgets/app_drawer.dart` (uses BrandLogo)
- `apps/flutter_app/lib/features/settings/presentation/about_screen.dart` (uses BrandLogo)
- `apps/flutter_app/pubspec.yaml` (added dark logos and favicons)

## Testing

Run the app and verify:
1. **Light Mode:**
   - Login screen shows CareAccess logo
   - App drawer shows wordmark and attribution
   - About screen shows full branding
   - All colors match brand guide
   - Typography is consistent (navy text)
   - Buttons and cards have proper styling

2. **Dark Mode:**
   - Switch device/emulator to dark mode
   - Logos automatically switch to dark variants
   - Background is dark (#121212)
   - Surfaces are dark (#1E1E1E, #2C2C2C)
   - Text is white/white70
   - Brand colors (teal, sage) still visible
   - All UI components properly styled

3. **Theme Switching:**
   - Toggle between light and dark mode
   - Logos switch automatically
   - No visual glitches or delays
   - All screens maintain brand consistency

---

**Product Owner:** Melken TechWork  
**Brand Guide:** `docs/CAREACCESS_BRAND_GUIDE.md`  
**Last Updated:** 2026-01-12

