import 'dart:io';
import 'package:image/image.dart';

void main() {
  stdout.writeln('Generating assets...');

  // Colors
  final primaryColor = ColorRgba8(25, 118, 210, 255); // #1976D2
  final secondaryColor = ColorRgba8(3, 169, 244, 255); // #03A9F4
  final whiteColor = ColorRgba8(255, 255, 255, 255);

  // 1. Create App Icon (1024x1024)
  final icon = Image(width: 1024, height: 1024);

  // Fill with primary color
  fill(icon, color: primaryColor);

  // Draw a simple "W" shape (using rectangles)
  // Left vertical
  fillRect(icon, x1: 200, y1: 300, x2: 300, y2: 800, color: whiteColor);
  // Right vertical
  fillRect(icon, x1: 500, y1: 300, x2: 600, y2: 800, color: whiteColor);
  // Bottom horizontal
  fillRect(icon, x1: 200, y1: 700, x2: 600, y2: 800, color: whiteColor);
  // Middle vertical
  fillRect(icon, x1: 350, y1: 500, x2: 450, y2: 800, color: whiteColor);

  // Plus sign
  fillRect(icon,
      x1: 700, y1: 450, x2: 900, y2: 550, color: secondaryColor); // Horizontal
  fillRect(icon,
      x1: 750, y1: 350, x2: 850, y2: 650, color: secondaryColor); // Vertical

  // Save app_icon.png
  File('assets/icons/app_icon.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(icon));

  stdout.writeln('Generated assets/icons/app_icon.png');

  // 2. Create Foreground Icon (Transparent background)
  final foreground = Image(width: 1024, height: 1024);
  // No fill (transparent)

  // Draw same shape
  fillRect(foreground, x1: 200, y1: 300, x2: 300, y2: 800, color: whiteColor);
  fillRect(foreground, x1: 500, y1: 300, x2: 600, y2: 800, color: whiteColor);
  fillRect(foreground, x1: 200, y1: 700, x2: 600, y2: 800, color: whiteColor);
  fillRect(foreground, x1: 350, y1: 500, x2: 450, y2: 800, color: whiteColor);

  fillRect(foreground,
      x1: 700, y1: 450, x2: 900, y2: 550, color: secondaryColor);
  fillRect(foreground,
      x1: 750, y1: 350, x2: 850, y2: 650, color: secondaryColor);

  File('assets/icons/app_icon_foreground.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(foreground));

  stdout.writeln('Generated assets/icons/app_icon_foreground.png');

  // 3. Create simple Logo files

  // Logo Icon Only (Same as foreground but 512x512)
  final logoIcon = copyResize(foreground, width: 512, height: 512);
  File('assets/images/logo_icon_only.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(logoIcon));

  stdout.writeln('Generated assets/images/logo_icon_only.png');

  // Logo En
  final logoEn = Image(width: 1024, height: 512);
  compositeImage(logoEn, logoIcon, dstX: 0, dstY: 0);

  // Draw "Text" lines
  fillRect(logoEn, x1: 550, y1: 150, x2: 950, y2: 250, color: primaryColor);
  fillRect(logoEn, x1: 550, y1: 300, x2: 850, y2: 350, color: secondaryColor);

  File('assets/images/logo_en.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(logoEn));

  stdout.writeln('Generated assets/images/logo_en.png');

  // Logo Ar
  final logoAr = Image(width: 1024, height: 512);
  compositeImage(logoAr, logoIcon, dstX: 512, dstY: 0);

  // Draw "Text" lines on left
  fillRect(logoAr, x1: 50, y1: 150, x2: 450, y2: 250, color: primaryColor);
  fillRect(logoAr, x1: 150, y1: 300, x2: 450, y2: 350, color: secondaryColor);

  File('assets/images/logo_ar.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(logoAr));

  stdout.writeln('Generated assets/images/logo_ar.png');

  // Splash Screen Background
  final splashBg = Image(width: 1080, height: 1920);
  fill(splashBg, color: primaryColor);
  File('assets/images/splash_bg.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(splashBg));

  stdout.writeln('Generated assets/images/splash_bg.png');

  // Splash Logo (White version of icon)
  final splashLogo = Image(width: 512, height: 512);
  // Draw white W+
  fillRect(splashLogo, x1: 100, y1: 150, x2: 150, y2: 400, color: whiteColor);
  fillRect(splashLogo, x1: 250, y1: 150, x2: 300, y2: 400, color: whiteColor);
  fillRect(splashLogo, x1: 100, y1: 350, x2: 300, y2: 400, color: whiteColor);
  fillRect(splashLogo, x1: 175, y1: 250, x2: 225, y2: 400, color: whiteColor);

  fillRect(splashLogo, x1: 350, y1: 225, x2: 450, y2: 275, color: whiteColor);
  fillRect(splashLogo, x1: 375, y1: 175, x2: 425, y2: 325, color: whiteColor);

  File('assets/images/splash_logo.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(splashLogo));

  stdout.writeln('Generated assets/images/splash_logo.png');
}
