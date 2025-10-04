import 'package:flutter/material.dart';
import 'glass_background.dart';
import '../../core/constants/colors.dart';

/// Example usage of the GlassBackground widget
class GlassBackgroundExample extends StatelessWidget {
  const GlassBackgroundExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.glassBorderCard,
                    width: 1,
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Glassmorphism Background',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This demonstrates the glass background with animated orbs',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example with custom orbs
class CustomGlassBackgroundExample extends StatelessWidget {
  const CustomGlassBackgroundExample({super.key});

  @override
  Widget build(BuildContext context) {
    final customOrbs = [
      GlassOrb(
        size: 200,
        position: const Offset(100, 100),
        colors: AppColors.orbGreen,
        animationDuration: const Duration(seconds: 3),
      ),
      GlassOrb(
        size: 150,
        position: const Offset(250, 400),
        colors: AppColors.orbBlue,
        animationDuration: const Duration(seconds: 4),
      ),
    ];

    return Scaffold(
      body: GlassBackground(
        customOrbs: customOrbs,
        blurIntensity: 15.0,
        child: const Center(
          child: Text(
            'Custom Orbs Example',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}