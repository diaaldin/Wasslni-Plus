# Wasslni Plus App Icon Assets

This folder contains the app icon assets for Wasslni Plus.

## Required Files:

### 1. app_icon.png (1024x1024px)
- **Main app icon** for all platforms
- Should be a square PNG image with transparency
- **Design Guidelines:**
  - Modern package delivery box or parcel icon
  - Incorporate speed/motion elements (arrows, speed lines)
  - Primary color: Teal/Cyan (#00BCD4)
  - Accent color: Orange (#FF9800)
  - Clean, minimalist design
  - Should work well at small sizes

### 2. app_icon_foreground.png (1024x1024px)
- **Android adaptive icon foreground**
- Contains only the icon graphic (transparent background)
- Should be centered with padding (safe zone: 432x432px in center)
- Same design as app_icon.png but optimized for adaptive icons

## Design Concept:
The icon should represent:
- **Fast delivery** - Speed, efficiency
- **Reliability** - Trust, professionalism  
- **Package delivery** - Box, parcel, or delivery truck
- **Modern tech** - Clean, contemporary design

## Color Scheme:
- Primary: #00BCD4 (Vibrant Teal/Cyan)
- Secondary: #FF9800 (Vibrant Orange)
- Background: White or transparent
- Consider using gradient effects for depth

## Tools for Creation:
- Adobe Illustrator / Photoshop
- Figma
- Canva
- Online logo makers (e.g., Looka, LogoMaker)
- AI generators (DALL-E, Midjourney, etc.)

## Once Created:
1. Place app_icon.png in this folder
2. Place app_icon_foreground.png in this folder
3. Run: `flutter pub get`
4. Run: `flutter pub run flutter_launcher_icons`
5. This will automatically generate icons for all platforms

## Example Icon Ideas:
1. A stylized package/box with a speed arrow overlay
2. A delivery truck with motion lines
3. Abstract "W" or "W+" lettermark with package elements
4. A package with a checkmark (representing delivered)
5. Minimalist box icon with teal-to-orange gradient
