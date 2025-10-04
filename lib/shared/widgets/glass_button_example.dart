import 'package:flutter/material.dart';
import 'glass_button.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// Example widget demonstrating GlassButton usage
class GlassButtonExample extends StatefulWidget {
  const GlassButtonExample({super.key});

  @override
  State<GlassButtonExample> createState() => _GlassButtonExampleState();
}

class _GlassButtonExampleState extends State<GlassButtonExample> {
  bool _isLoading = false;
  bool _isDisabled = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _toggleDisabled() {
    setState(() {
      _isDisabled = !_isDisabled;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Glass Button Examples'),
        backgroundColor: AppColors.backgroundAlt,
        foregroundColor: AppColors.text,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.backgroundAlt,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Glass Button Styles',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: AppDimensions.fontSizeXl,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXxxl),
                
                // Primary Button
                PrimaryGlassButton(
                  text: 'Primary Button',
                  isLoading: _isLoading,
                  disabled: _isDisabled,
                  onPressed: () => _showSnackBar('Primary button pressed!'),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Secondary Button
                SecondaryGlassButton(
                  text: 'Secondary Button',
                  isLoading: _isLoading,
                  disabled: _isDisabled,
                  onPressed: () => _showSnackBar('Secondary button pressed!'),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Social Button
                SocialGlassButton(
                  text: 'Social Button',
                  isLoading: _isLoading,
                  disabled: _isDisabled,
                  onPressed: () => _showSnackBar('Social button pressed!'),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Button with Icon
                GlassButton(
                  text: 'Button with Icon',
                  icon: const Icon(
                    Icons.star,
                    color: AppColors.text,
                    size: AppDimensions.iconMd,
                  ),
                  isLoading: _isLoading,
                  disabled: _isDisabled,
                  onPressed: () => _showSnackBar('Icon button pressed!'),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Custom Gradient Button
                GlassButton(
                  text: 'Custom Gradient',
                  gradientColors: AppColors.gradientPurple,
                  isLoading: _isLoading,
                  disabled: _isDisabled,
                  onPressed: () => _showSnackBar('Custom gradient button pressed!'),
                ),
                const SizedBox(height: AppDimensions.spacingXxxl),
                
                // Control Buttons
                const Text(
                  'Controls',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: AppDimensions.fontSizeLg,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        text: _isLoading ? 'Stop Loading' : 'Start Loading',
                        style: GlassButtonStyle.secondary,
                        height: AppDimensions.buttonHeightSm,
                        onPressed: _toggleLoading,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: GlassButton(
                        text: _isDisabled ? 'Enable' : 'Disable',
                        style: GlassButtonStyle.secondary,
                        height: AppDimensions.buttonHeightSm,
                        onPressed: _toggleDisabled,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Status Text
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  decoration: BoxDecoration(
                    color: AppColors.glassCard,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: AppColors.glassBorderCard,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: AppDimensions.fontSizeMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Text(
                        'Loading: ${_isLoading ? "ON" : "OFF"} | Disabled: ${_isDisabled ? "ON" : "OFF"}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}