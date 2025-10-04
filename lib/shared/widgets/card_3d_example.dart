import 'package:flutter/material.dart';
import 'card_3d.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// Example usage of the Card3D widget demonstrating both interactive and non-interactive modes
class Card3DExample extends StatelessWidget {
  const Card3DExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Card3D Examples'),
        backgroundColor: AppColors.backgroundAlt,
        foregroundColor: AppColors.text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Interactive Card (Pan to tilt)',
              style: TextStyle(
                color: AppColors.text,
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Card3D(
              interactive: true,
              tiltIntensity: 0.3,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(AppDimensions.paddingXl),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: AppColors.accent,
                      size: AppDimensions.iconXl,
                    ),
                    SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      'Interactive Card',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: AppDimensions.fontSizeLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingSm),
                    Text(
                      'Pan to see 3D tilt effect',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimensions.fontSizeMd,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXxxl),
            const Text(
              'Auto-Rotating Card',
              style: TextStyle(
                color: AppColors.text,
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Card3D(
              interactive: false,
              autoRotationDuration: const Duration(seconds: 4),
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(AppDimensions.paddingXl),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.autorenew,
                      color: AppColors.primary,
                      size: AppDimensions.iconXl,
                    ),
                    SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      'Auto-Rotating Card',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: AppDimensions.fontSizeLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingSm),
                    Text(
                      'Automatically rotates with 3D effect',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimensions.fontSizeMd,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}