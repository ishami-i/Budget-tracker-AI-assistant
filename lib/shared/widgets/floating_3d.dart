import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that provides 3D floating animation effects with rotation and scaling.
/// 
/// This widget wraps its child with floating, rotation, and scaling animations
/// to create a 3D floating effect similar to the original React Native app.
class Floating3D extends StatefulWidget {
  /// The child widget to animate
  final Widget child;
  
  /// The intensity of the floating animation (higher values = more movement)
  final double intensity;
  
  /// The duration of one complete animation cycle
  final Duration duration;
  
  /// Whether to automatically start the animation when the widget is created
  final bool autoStart;
  
  /// Whether the animation should loop continuously
  final bool loop;
  
  const Floating3D({
    super.key,
    required this.child,
    this.intensity = 10.0,
    this.duration = const Duration(seconds: 3),
    this.autoStart = true,
    this.loop = true,
  });

  @override
  State<Floating3D> createState() => _Floating3DState();
}

class _Floating3DState extends State<Floating3D>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    if (widget.autoStart) {
      startAnimation();
    }
  }

  void _initializeAnimations() {
    // Floating animation controller (vertical movement)
    _floatingController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    // Rotation animation controller (subtle rotation)
    _rotationController = AnimationController(
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 1.5).round()),
      vsync: this,
    );
    
    // Scale animation controller (breathing effect)
    _scaleController = AnimationController(
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 0.8).round()),
      vsync: this,
    );

    // Floating animation (sine wave for smooth up/down movement)
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.linear,
    ));

    // Rotation animation (subtle rotation around Y-axis)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Scale animation (subtle breathing effect)
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  /// Start the floating animation
  void startAnimation() {
    if (widget.loop) {
      _floatingController.repeat();
      _rotationController.repeat();
      _scaleController.repeat(reverse: true);
    } else {
      _floatingController.forward();
      _rotationController.forward();
      _scaleController.forward();
    }
  }

  /// Stop the floating animation
  void stopAnimation() {
    _floatingController.stop();
    _rotationController.stop();
    _scaleController.stop();
  }

  /// Reset the animation to its initial state
  void resetAnimation() {
    _floatingController.reset();
    _rotationController.reset();
    _scaleController.reset();
  }

  @override
  void dispose() {
    // Proper disposal of animation controllers to prevent memory leaks
    _floatingController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatingAnimation,
        _rotationAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        // Calculate the floating offset using sine wave
        final floatingOffset = math.sin(_floatingAnimation.value) * widget.intensity;
        
        // Calculate rotation values for 3D effect
        final rotationY = math.sin(_rotationAnimation.value) * 0.1; // Subtle Y-axis rotation
        final rotationX = math.cos(_rotationAnimation.value * 0.7) * 0.05; // Subtle X-axis rotation
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            // Add perspective for 3D effect
            ..setEntry(3, 2, 0.001)
            // Apply Y-axis rotation
            ..rotateY(rotationY)
            // Apply X-axis rotation
            ..rotateX(rotationX)
            // Apply scaling
            ..scale(_scaleAnimation.value)
            // Apply floating translation
            ..translate(0.0, floatingOffset, 0.0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}