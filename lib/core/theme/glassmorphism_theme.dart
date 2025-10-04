import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// Glassmorphism styling constants and utilities for consistent glass effects
class GlassmorphismTheme {
  
  /// Glass container decoration with blur and transparency
  static BoxDecoration get glassContainer => BoxDecoration(
    color: AppColors.glassContainer,
    borderRadius: BorderRadius.circular(AppDimensions.cardRadiusLg),
    border: Border.all(
      color: AppColors.glassBorderContainer,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 32,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  /// Glass card decoration with lighter transparency
  static BoxDecoration get glassCard => BoxDecoration(
    color: AppColors.glassCard,
    borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    border: Border.all(
      color: AppColors.glassBorderCard,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 24,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  /// Glass button decoration with enhanced transparency
  static BoxDecoration get glassButton => BoxDecoration(
    color: AppColors.glassButton,
    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
    border: Border.all(
      color: AppColors.glassBorderButton,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  /// Glass input decoration for form fields
  static BoxDecoration get glassInput => BoxDecoration(
    color: AppColors.glassInput,
    borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
    border: Border.all(
      color: AppColors.glassBorderInput,
      width: 1,
    ),
  );
  
  /// Floating 3D decoration with enhanced shadows and perspective
  static BoxDecoration get floating3D => BoxDecoration(
    color: AppColors.glassContainer,
    borderRadius: BorderRadius.circular(AppDimensions.cardRadiusLg),
    border: Border.all(
      color: AppColors.glassBorderContainer.withOpacity(0.1),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 40,
        offset: const Offset(0, 20),
      ),
      BoxShadow(
        color: AppColors.glassBorderContainer,
        blurRadius: 1,
        offset: const Offset(0, 0),
      ),
    ],
  );
  
  /// Neon glow decoration for special elements
  static BoxDecoration get neonGlow => BoxDecoration(
    color: AppColors.glassButton,
    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
    border: Border.all(
      color: AppColors.neonGreen.withOpacity(0.8),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.neonGreenGlow,
        blurRadius: 20,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.neonGreenGlowMid,
        blurRadius: 40,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.neonGreenGlowLight,
        blurRadius: 60,
        offset: const Offset(0, 0),
      ),
    ],
  );
  
  /// Social button decoration with subtle glass effect
  static BoxDecoration get socialButton => BoxDecoration(
    color: AppColors.glassCard,
    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
    border: Border.all(
      color: AppColors.glassBorderCard,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  /// Start saving button decoration with neon effect
  static BoxDecoration get startSavingButton => BoxDecoration(
    color: AppColors.glassButton,
    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
    border: Border.all(
      color: AppColors.glassBorderButton,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
      // Neon glow effects
      BoxShadow(
        color: AppColors.neonGreenGlow,
        blurRadius: 20,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.neonGreenGlowMid,
        blurRadius: 40,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.neonGreenGlowLight,
        blurRadius: 60,
        offset: const Offset(0, 0),
      ),
    ],
  );
  
  /// Glass overlay decoration for background
  static BoxDecoration get glassOverlay => const BoxDecoration(
    color: AppColors.glassOverlay,
  );
  
  /// Light glass overlay decoration
  static BoxDecoration get glassOverlayLight => const BoxDecoration(
    color: AppColors.glassOverlayLight,
  );
  
  /// Logo container decoration with floating 3D effect
  static BoxDecoration get logoContainer => BoxDecoration(
    borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 40,
        offset: const Offset(0, 20),
      ),
      BoxShadow(
        color: AppColors.glassBorderContainer,
        blurRadius: 1,
        offset: const Offset(0, 0),
      ),
    ],
  );
  
  /// Gradient decorations for various UI elements
  static const LinearGradient gradientGreen = LinearGradient(
    colors: AppColors.gradientGreen,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradientBlue = LinearGradient(
    colors: AppColors.gradientBlue,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradientPurple = LinearGradient(
    colors: AppColors.gradientPurple,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradientGlass = LinearGradient(
    colors: AppColors.gradientGlass,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Orb gradients for background animations
  static const RadialGradient orbGreen = RadialGradient(
    colors: AppColors.orbGreen,
    center: Alignment.center,
    radius: 1.0,
  );
  
  static const RadialGradient orbBlue = RadialGradient(
    colors: AppColors.orbBlue,
    center: Alignment.center,
    radius: 1.0,
  );
  
  static const RadialGradient orbPurple = RadialGradient(
    colors: AppColors.orbPurple,
    center: Alignment.center,
    radius: 1.0,
  );
  
  /// Text shadows for glassmorphism effect
  static List<Shadow> get textShadowGlow => [
    Shadow(
      color: AppColors.text.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 0),
    ),
  ];
  
  /// Input focus decoration with glow effect
  static BoxDecoration get inputFocused => BoxDecoration(
    color: AppColors.glassInput,
    borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
    border: Border.all(
      color: AppColors.primary,
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.primary.withOpacity(0.2),
        blurRadius: 20,
        offset: const Offset(0, 0),
      ),
    ],
  );
  
  /// Utility method to create custom glass decoration
  static BoxDecoration createGlassDecoration({
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = AppDimensions.cardRadius,
    double borderWidth = 1.0,
    double blurRadius = 24.0,
    double shadowOpacity = 0.25,
    Offset shadowOffset = const Offset(0, 4),
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.glassCard,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.glassBorderCard,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(shadowOpacity),
          blurRadius: blurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }
  
  /// Utility method to create custom gradient
  static LinearGradient createCustomGradient({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
    );
  }
  
  /// Animation curves for glassmorphism effects
  static const Curve glassAnimationCurve = Curves.easeInOutCubic;
  static const Duration glassAnimationDuration = Duration(milliseconds: AppDimensions.animationMedium);
  static const Duration floatingAnimationDuration = Duration(milliseconds: AppDimensions.animationFloat);
}