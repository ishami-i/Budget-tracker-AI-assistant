import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// A glassmorphism background widget with animated gradient orbs and blur effects
class GlassBackground extends StatefulWidget {
  /// The child widget to display on top of the glass background
  final Widget child;
  
  /// Custom orbs to display instead of default ones
  final List<GlassOrb>? customOrbs;
  
  /// Whether to show the glass overlay
  final bool showOverlay;
  
  /// The blur intensity for the glass effect
  final double blurIntensity;
  
  const GlassBackground({
    super.key,
    required this.child,
    this.customOrbs,
    this.showOverlay = true,
    this.blurIntensity = AppDimensions.blurMedium,
  });

  @override
  State<GlassBackground> createState() => _GlassBackgroundState();
}

class _GlassBackgroundState extends State<GlassBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _orbControllers;
  late List<Animation<double>> _orbAnimations;
  late List<GlassOrb> _orbs;

  @override
  void initState() {
    super.initState();
    _initializeOrbs();
    _setupAnimations();
  }

  void _initializeOrbs() {
    _orbs = widget.customOrbs ?? _getDefaultOrbs();
  }

  void _setupAnimations() {
    _orbControllers = [];
    _orbAnimations = [];

    for (int i = 0; i < _orbs.length; i++) {
      final controller = AnimationController(
        duration: _orbs[i].animationDuration,
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      _orbControllers.add(controller);
      _orbAnimations.add(animation);
      
      // Start animation immediately for better test compatibility
      controller.repeat(reverse: true);
    }
  }

  List<GlassOrb> _getDefaultOrbs() {
    return [
      GlassOrb(
        size: AppDimensions.orbLarge,
        position: const Offset(-50, -50),
        colors: AppColors.orbGreen,
        animationDuration: const Duration(seconds: 4),
      ),
      GlassOrb(
        size: AppDimensions.orbMedium,
        position: const Offset(250, 100),
        colors: AppColors.orbBlue,
        animationDuration: const Duration(seconds: 5),
      ),
      GlassOrb(
        size: AppDimensions.orbSmall,
        position: const Offset(50, 400),
        colors: AppColors.orbPurple,
        animationDuration: const Duration(seconds: 3),
      ),
      GlassOrb(
        size: AppDimensions.orbMedium,
        position: const Offset(300, 600),
        colors: AppColors.orbGreen,
        animationDuration: const Duration(seconds: 6),
      ),
    ];
  }

  @override
  void dispose() {
    for (final controller in _orbControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          // Animated gradient orbs
          ..._buildAnimatedOrbs(),
          
          // Glass overlay with blur effect
          if (widget.showOverlay) _buildGlassOverlay(),
          
          // Child content
          widget.child,
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedOrbs() {
    return [
      Positioned.fill(
        child: AnimatedBuilder(
          animation: Listenable.merge(_orbAnimations),
          builder: (context, child) {
            return CustomPaint(
              painter: GlassOrbPainter(
                orbs: _orbs,
                animations: _orbAnimations,
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildGlassOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurIntensity,
          sigmaY: widget.blurIntensity,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassOverlay,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.glassOverlay.withOpacity(0.3),
                AppColors.glassOverlay.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Represents a gradient orb for the glass background
class GlassOrb {
  /// The size of the orb
  final double size;
  
  /// The position of the orb
  final Offset position;
  
  /// The gradient colors for the orb
  final List<Color> colors;
  
  /// The animation duration for the orb
  final Duration animationDuration;
  
  const GlassOrb({
    required this.size,
    required this.position,
    required this.colors,
    this.animationDuration = const Duration(seconds: 4),
  });
}

/// Custom painter for rendering animated gradient orbs efficiently
class GlassOrbPainter extends CustomPainter {
  final List<GlassOrb> orbs;
  final List<Animation<double>> animations;
  
  GlassOrbPainter({
    required this.orbs,
    required this.animations,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < orbs.length; i++) {
      final orb = orbs[i];
      final animationValue = animations[i].value;
      
      // Calculate animated position
      final animatedX = orb.position.dx + (animationValue * 20 - 10);
      final animatedY = orb.position.dy + (animationValue * 15 - 7.5);
      final animatedScale = 0.8 + (animationValue * 0.4);
      final animatedSize = orb.size * animatedScale;
      
      // Create radial gradient
      final gradient = RadialGradient(
        colors: orb.colors,
        stops: const [0.0, 1.0],
      );
      
      // Create shader
      final shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(animatedX + animatedSize / 2, animatedY + animatedSize / 2),
          radius: animatedSize / 2,
        ),
      );
      
      // Create paint with shader
      final paint = Paint()
        ..shader = shader
        ..style = PaintingStyle.fill;
      
      // Draw the orb
      canvas.drawCircle(
        Offset(animatedX + animatedSize / 2, animatedY + animatedSize / 2),
        animatedSize / 2,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant GlassOrbPainter oldDelegate) {
    return orbs != oldDelegate.orbs || animations != oldDelegate.animations;
  }
}