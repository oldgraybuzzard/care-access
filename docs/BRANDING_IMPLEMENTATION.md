# CareAccess Branding Implementation

## Overview

This document describes the implementation of the CareAccess brand identity throughout the Flutter application, including the new Material 3 theme, logo integration, and brand consistency guidelines.

## Brand Assets

### Logo Files
Located in `assets/brand/`:
- `careaccess_icon.svg` - Icon only (heart-shaped pathway)
- `careaccess_wordmark.svg` - Text logo only
- `careaccess_lockup.svg` - Full logo (icon + wordmark)

### Brand Guide
See `docs/CAREACCESS_BRAND_GUIDE.md` for complete brand guidelines.

## Theme Implementation

### New Theme File
**File:** `apps/flutter_app/lib/core/theme/app_theme.dart`

The theme has been completely redesigned to match the CareAccess brand:

#### Color Palette
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

#### Material 3 Components
- **Cards:** Rounded corners (18px), subtle elevation
- **Buttons:** Rounded (16px), brand colors
- **Input Fields:** Rounded (14px), sand-colored fill
- **Chips:** Rounded (14px), sage/teal accents
- **Typography:** Navy text, bold headings, readable body

### Brand Constants
**File:** `apps/flutter_app/lib/core/constants/brand_assets.dart`

Centralized constants for:
- Asset paths
- Product name and tagline
- Copyright and attribution
- Melken TechWork ownership

## UI Integration

### 1. Login Screen
**File:** `apps/flutter_app/lib/features/auth/presentation/login_screen.dart`

**Changes:**
- Replaced generic icon with CareAccess full lockup logo
- Logo displays at 80px height
- Clean, professional first impression

### 2. App Drawer
**File:** `apps/flutter_app/lib/shared/widgets/app_drawer.dart`

**Changes:**
- Custom DrawerHeader with teal background
- CareAccess wordmark logo (white, 32px)
- User name and email in white text
- Footer with Melken TechWork attribution and tagline

### 3. About Screen
**File:** `apps/flutter_app/lib/features/settings/presentation/about_screen.dart`

**Changes:**
- CareAccess full lockup logo at top (100px)
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
    - ../../assets/brand/careaccess_icon.svg
    - ../../assets/brand/careaccess_wordmark.svg
    - ../../assets/brand/careaccess_lockup.svg
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

### Using Brand Assets
```dart
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fcf_app/core/constants/brand_assets.dart';

// Display logo
SvgPicture.asset(
  BrandAssets.lockup,
  height: 80,
)

// Display attribution
Text(BrandInfo.attribution)
```

### Logo Usage Rules
1. **Icon only** - Use for app icons, favicons, small spaces
2. **Wordmark only** - Use for headers, navigation, minimal branding
3. **Full lockup** - Use for login, splash, about pages, marketing

## Brand Consistency Checklist

- ✅ All screens use CareAccessTheme
- ✅ Login screen shows full lockup logo
- ✅ App drawer shows wordmark and attribution
- ✅ About screen shows full branding
- ✅ Copyright shows Melken TechWork ownership
- ✅ Tagline appears in appropriate places
- ✅ Colors match brand guide
- ✅ Typography uses navy for text
- ✅ Buttons and cards use rounded corners
- ✅ No generic icons replacing brand logos

## Next Steps

### Recommended Enhancements
1. **Splash Screen** - Add CareAccess logo to app launch
2. **App Icon** - Use `careaccess_icon.svg` for mobile app icon
3. **Favicon** - Use icon for web version
4. **Loading States** - Show logo during data loading
5. **Empty States** - Use brand colors and messaging
6. **Error Pages** - Maintain brand consistency

### Future Considerations
1. Add Inter font family for better typography
2. Create dark theme variant
3. Add brand animations (logo reveal, transitions)
4. Create branded illustrations for empty states
5. Design branded error and success icons

## Files Modified

### Created
- `apps/flutter_app/lib/core/constants/brand_assets.dart`
- `docs/BRANDING_IMPLEMENTATION.md`

### Updated
- `apps/flutter_app/lib/core/theme/app_theme.dart` (complete rewrite)
- `apps/flutter_app/lib/features/auth/presentation/login_screen.dart`
- `apps/flutter_app/lib/shared/widgets/app_drawer.dart`
- `apps/flutter_app/lib/features/settings/presentation/about_screen.dart`
- `apps/flutter_app/pubspec.yaml`

## Testing

Run the app and verify:
1. Login screen shows CareAccess logo
2. App drawer shows wordmark and attribution
3. About screen shows full branding
4. All colors match brand guide
5. Typography is consistent
6. Buttons and cards have proper styling

---

**Product Owner:** Melken TechWork  
**Brand Guide:** `docs/CAREACCESS_BRAND_GUIDE.md`  
**Last Updated:** 2026-01-12

