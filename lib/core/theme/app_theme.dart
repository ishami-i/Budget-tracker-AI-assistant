import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// App theme configuration for dark theme matching React Native design
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      // Base theme
      brightness: Brightness.dark,
      useMaterial3: true,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.text,
        onSecondary: AppColors.text,
        onSurface: AppColors.text,
        onError: AppColors.text,
        tertiary: AppColors.accent,
        outline: AppColors.border,
        surfaceContainerHighest: AppColors.backgroundAlt,
      ),
      
      // Scaffold theme
      scaffoldBackgroundColor: AppColors.background,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.text,
          size: AppDimensions.iconMd,
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        // Display styles (large titles)
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontSizeHuge,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
          height: AppDimensions.lineHeightXxl / AppDimensions.fontSizeHuge,
        ),
        displayMedium: TextStyle(
          fontSize: AppDimensions.fontSizeXxl,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
          height: AppDimensions.lineHeightXl / AppDimensions.fontSizeXxl,
        ),
        displaySmall: TextStyle(
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          height: AppDimensions.lineHeightLg / AppDimensions.fontSizeXl,
        ),
        
        // Headline styles
        headlineLarge: TextStyle(
          fontSize: AppDimensions.fontSizeXxl,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
          height: AppDimensions.lineHeightXl / AppDimensions.fontSizeXxl,
        ),
        headlineMedium: TextStyle(
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          height: AppDimensions.lineHeightLg / AppDimensions.fontSizeXl,
        ),
        headlineSmall: TextStyle(
          fontSize: AppDimensions.fontSizeLg,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightMd / AppDimensions.fontSizeLg,
        ),
        
        // Title styles
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontSizeLg,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightMd / AppDimensions.fontSizeLg,
        ),
        titleMedium: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightMd / AppDimensions.fontSizeMd,
        ),
        titleSmall: TextStyle(
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightSm / AppDimensions.fontSizeSm,
        ),
        
        // Body styles
        bodyLarge: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: AppDimensions.lineHeightMd / AppDimensions.fontSizeMd,
        ),
        bodyMedium: TextStyle(
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: AppDimensions.lineHeightSm / AppDimensions.fontSizeSm,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSizeXs,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: AppDimensions.lineHeightSm / AppDimensions.fontSizeXs,
        ),
        
        // Label styles
        labelLarge: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightMd / AppDimensions.fontSizeMd,
        ),
        labelMedium: TextStyle(
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightSm / AppDimensions.fontSizeSm,
        ),
        labelSmall: TextStyle(
          fontSize: AppDimensions.fontSizeXs,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          height: AppDimensions.lineHeightSm / AppDimensions.fontSizeXs,
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.text,
          elevation: AppDimensions.elevationMd,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.glassBorderInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.glassBorderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingHorizontal,
          vertical: AppDimensions.inputPaddingVertical,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeMd,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeMd,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: AppDimensions.fontSizeSm,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: AppDimensions.fontSizeSm,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: AppColors.glassCard,
        elevation: AppDimensions.elevationLg,
        shadowColor: Colors.black.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          side: const BorderSide(color: AppColors.glassBorderCard),
        ),
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.cardMarginVertical),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.text,
        size: AppDimensions.iconMd,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: AppDimensions.spacingLg,
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.text),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColors.border;
        }),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.glassContainer,
        contentTextStyle: const TextStyle(
          color: AppColors.text,
          fontSize: AppDimensions.fontSizeMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppDimensions.elevationXl,
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.glassContainer,
        elevation: AppDimensions.elevationXxl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          side: const BorderSide(color: AppColors.glassBorderContainer),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.text,
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeMd,
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.glassContainer,
        elevation: AppDimensions.elevationXxl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
          side: BorderSide(color: AppColors.glassBorderContainer),
        ),
      ),
    );
  }
}