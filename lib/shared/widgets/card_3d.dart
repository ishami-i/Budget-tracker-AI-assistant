import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// A 3D interactive card widget with glassmorphism styling and tilt effects.
/// 
/// This widget creates a card that responds to pan gestures with 3D tilt effects
/// and includes glassmorphism styling with blur and transparency effects.
/// In non-interactive mode, it provides auto-rotation animations.
class Card3D extends StatefulWidget {
  /// The child widget to display inside the card
  final Widget child;
  
  /// Whether the card should respond to user gestures
  final bool interactive;
  
  /// The padding inside the card
  final EdgeInsets padding;
  
  /// The border radius of the card
  final BorderRadius? borderRadius;
  
  /// The width of the card (null for flexible width)
  final double? width;
  
  /// The height of the card (null for flexible height)
  final double? height;
  
  /// The intensity of the tilt effect (0.0 to 1.0)
  final double tiltIntensity;
  
  /// The duration of the auto-rotation animation (for non-interactive mode)
  final Duration autoRotationDuration;
  
  /// Whether to show the glassmorphism border
  final bool showBorder;
  
  /// Custom background color (overrides default glassmorphism)
  final Color? backgroundColor;
  
  /// Custom border color
  final Color? borderColor;
  
  const Card3D({
    super.key,
    required this.child,
    this.interactive = true,
    this.padding = const EdgeInsets.all(AppDimensions.paddingXl),
    this.borderRadius,
    this.width,
    this.height,
    this.tiltIntensity = 0.3,
    this.autoRotationDuration = const Duration(seconds: 4),
    this.showBorder = true,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<Card3D> createState() => _Card3DState();
}

class _Card3DState extends State<Card3D> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _autoRotationController;
  late AnimationController _resetController;
  
  // Animations
  late Animation<double> _autoRotationAnimation;
  late Animation<double> _resetAnimation;
  
  // Tilt state
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isPressed = false;
  
  // Auto-rotation values
  double _autoTiltX = 0.0;
  double _autoTiltY = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    if (!widget.interactive) {
      _startAutoRotation();
    }
  }

  void _initializeAnimations() {
    // Auto-rotation controller for non-interactive mode
    _autoRotationController = AnimationController(
      duration: widget.autoRotationDuration,
      vsync: this,
    );
    
    // Reset controller for smooth return to center
    _resetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Auto-rotation animation
    _autoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _autoRotationController,
      curve: Curves.linear,
    ));

    // Reset animation
    _resetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOut,
    ));

    // Listen to auto-rotation animation
    _autoRotationAnimation.addListener(() {
      if (!widget.interactive && mounted) {
        setState(() {
          _autoTiltX = math.sin(_autoRotationAnimation.value) * 0.1;
          _autoTiltY = math.cos(_autoRotationAnimation.value * 0.7) * 0.15;
        });
      }
    });

    // Listen to reset animation
    _resetAnimation.addListener(() {
      if (mounted) {
        setState(() {
          _tiltX = _tiltX * (1.0 - _resetAnimation.value);
          _tiltY = _tiltY * (1.0 - _resetAnimation.value);
        });
      }
    });
  }

  void _startAutoRotation() {
    if (!widget.interactive) {
      _autoRotationController.repeat();
    }
  }



  void _onPanStart(DragStartDetails details) {
    if (!widget.interactive) return;
    
    setState(() {
      _isPressed = true;
    });
    _resetController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details, Size cardSize) {
    if (!widget.interactive) return;
    
    // Get the center of the card
    final center = Offset(cardSize.width / 2, cardSize.height / 2);
    
    // Calculate the offset from center
    final localPosition = details.localPosition;
    final offsetX = (localPosition.dx - center.dx) / center.dx;
    final offsetY = (localPosition.dy - center.dy) / center.dy;
    
    // Apply tilt intensity and clamp values
    final maxTilt = widget.tiltIntensity;
    setState(() {
      _tiltX = (-offsetY * maxTilt).clamp(-maxTilt, maxTilt);
      _tiltY = (offsetX * maxTilt).clamp(-maxTilt, maxTilt);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.interactive) return;
    
    setState(() {
      _isPressed = false;
    });
    
    // Smoothly return to center
    _resetController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _autoRotationController.dispose();
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = widget.width ?? constraints.maxWidth;
        final cardHeight = widget.height;
        
        return GestureDetector(
          onPanStart: widget.interactive ? _onPanStart : null,
          onPanUpdate: widget.interactive 
              ? (details) => _onPanUpdate(details, Size(cardWidth, cardHeight ?? 200))
              : null,
          onPanEnd: widget.interactive ? _onPanEnd : null,
          child: AnimatedContainer(
            duration: _isPressed 
                ? Duration.zero 
                : const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                // Add perspective for 3D effect
                ..setEntry(3, 2, 0.001)
                // Apply tilt rotations
                ..rotateX(widget.interactive ? _tiltX : _autoTiltX)
                ..rotateY(widget.interactive ? _tiltY : _autoTiltY)
                // Add subtle scale effect when pressed
                ..scale(_isPressed ? 0.98 : 1.0),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.glassCard,
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(AppDimensions.cardRadius),
                  border: widget.showBorder
                      ? Border.all(
                          color: widget.borderColor ?? AppColors.glassBorderCard,
                          width: 1.0,
                        )
                      : null,
                  boxShadow: [
                    // Subtle shadow for depth
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    // Inner glow effect
                    BoxShadow(
                      color: AppColors.glassBorderCard.withValues(alpha: 0.5),
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(AppDimensions.cardRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppDimensions.blurLight,
                      sigmaY: AppDimensions.blurLight,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}