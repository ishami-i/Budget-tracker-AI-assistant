import 'package:flutter/material.dart';

/// App color constants matching the React Native design system
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2E7D32);       // Green (growth/savings)
  static const Color secondary = Color(0xFF1976D2);     // Blue (trust)
  static const Color accent = Color(0xFF4CAF50);        // Light green accent
  
  // Background colors for dark theme
  static const Color background = Color(0xFF0F0F23);    // Dark background for glassmorphism
  static const Color backgroundAlt = Color(0xFF1A1A2E); // Darker background
  static const Color backgroundLight = Color(0x0DFFFFFF); // Glass background (rgba(255, 255, 255, 0.05))
  
  // Text colors
  static const Color text = Color(0xFFFFFFFF);          // White text for dark theme
  static const Color textSecondary = Color(0xFFB0B0B0); // Light grey text
  
  // UI element colors
  static const Color grey = Color(0xFF333333);          // Dark grey
  static const Color card = Color(0x1AFFFFFF);          // Glass card background (rgba(255, 255, 255, 0.1))
  static const Color success = Color(0xFF4CAF50);       // Green success
  static const Color error = Color(0xFFFF5252);         // Red error
  static const Color border = Color(0x33FFFFFF);        // Glass border (rgba(255, 255, 255, 0.2))
  
  // Gradient colors
  static const List<Color> gradientGreen = [Color(0xFF4CAF50), Color(0xFF2E7D32)];
  static const List<Color> gradientBlue = [Color(0xFF1976D2), Color(0xFF0D47A1)];
  static const List<Color> gradientPurple = [Color(0xFF9C27B0), Color(0xFF673AB7)];
  static const List<Color> gradientGlass = [Color(0x40FFFFFF), Color(0x0DFFFFFF)]; // rgba(255, 255, 255, 0.25) to rgba(255, 255, 255, 0.05)
  
  // Glassmorphism specific colors
  static const Color glassContainer = Color(0x1AFFFFFF);     // rgba(255, 255, 255, 0.1)
  static const Color glassCard = Color(0x14FFFFFF);          // rgba(255, 255, 255, 0.08)
  static const Color glassButton = Color(0x26FFFFFF);        // rgba(255, 255, 255, 0.15)
  static const Color glassInput = Color(0x0DFFFFFF);         // rgba(255, 255, 255, 0.05)
  
  // Glass border colors
  static const Color glassBorderContainer = Color(0x33FFFFFF); // rgba(255, 255, 255, 0.2)
  static const Color glassBorderCard = Color(0x26FFFFFF);     // rgba(255, 255, 255, 0.15)
  static const Color glassBorderButton = Color(0x4DFFFFFF);   // rgba(255, 255, 255, 0.3)
  static const Color glassBorderInput = Color(0x1AFFFFFF);    // rgba(255, 255, 255, 0.1)
  
  // Neon glow colors
  static const Color neonGreen = Color(0xFF4CAF50);
  static const Color neonGreenGlow = Color(0x994CAF50);       // rgba(76, 175, 80, 0.6)
  static const Color neonGreenGlowMid = Color(0x664CAF50);    // rgba(76, 175, 80, 0.4)
  static const Color neonGreenGlowLight = Color(0x334CAF50);  // rgba(76, 175, 80, 0.2)
  
  // Orb colors for background animations
  static const List<Color> orbGreen = [Color(0x4D4CAF50), Color(0x1A4CAF50)]; // rgba(76, 175, 80, 0.3) to rgba(76, 175, 80, 0.1)
  static const List<Color> orbBlue = [Color(0x4D1976D2), Color(0x1A1976D2)];  // rgba(25, 118, 210, 0.3) to rgba(25, 118, 210, 0.1)
  static const List<Color> orbPurple = [Color(0x4D9C27B0), Color(0x1A9C27B0)]; // rgba(156, 39, 176, 0.3) to rgba(156, 39, 176, 0.1)
  
  // Glass overlay color
  static const Color glassOverlay = Color(0xB30F0F23);       // rgba(15, 15, 35, 0.7)
  static const Color glassOverlayLight = Color(0xCC0F0F23);  // rgba(15, 15, 35, 0.8)
}