import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// Enumeration for different button styles
enum GlassButtonStyle { primary, secondary, social }

/// A glassmorphism-styled button with gradient backgrounds and animations
class GlassButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Custom gradient colors (overrides style defaults)
  final List<Color>? gradientColors;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Optional icon to display
  final Widget? icon;

  /// Button style (primary, secondary, social)
  final GlassButtonStyle style;

  /// Custom width for the button
  final double? width;

  /// Custom height for the button
  final double? height;

  /// Text style for the button text
  final TextStyle? textStyle;

  /// Whether the button is disabled
  final bool disabled;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors,
    this.isLoading = false,
    this.icon,
    this.style = GlassButtonStyle.primary,
    this.width,
    this.height,
    this.textStyle,
    this.disabled = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationMedium),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    // Start loading animation if initially loading
    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(GlassButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle loading state changes
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get gradient colors based on button style
  List<Color> _getGradientColors() {
    if (widget.gradientColors != null) {
      return widget.gradientColors!;
    }

    switch (widget.style) {
      case GlassButtonStyle.primary:
        return AppColors.gradientGreen;
      case GlassButtonStyle.secondary:
        return AppColors.gradientBlue;
      case GlassButtonStyle.social:
        return AppColors.gradientGlass;
    }
  }

  /// Get background color based on button style
  Color _getBackgroundColor() {
    switch (widget.style) {
      case GlassButtonStyle.primary:
        return AppColors.glassButton;
      case GlassButtonStyle.secondary:
        return AppColors.glassCard;
      case GlassButtonStyle.social:
        return AppColors.glassInput;
    }
  }

  /// Get border color based on button style
  Color _getBorderColor() {
    switch (widget.style) {
      case GlassButtonStyle.primary:
        return AppColors.glassBorderButton;
      case GlassButtonStyle.secondary:
        return AppColors.glassBorderCard;
      case GlassButtonStyle.social:
        return AppColors.glassBorderInput;
    }
  }

  /// Handle button press
  void _handlePress() {
    if (widget.disabled || widget.isLoading || widget.onPressed == null) {
      return;
    }

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Trigger press animation
    setState(() {
      _isPressed = true;
    });

    // Reset press state after animation
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });

    // Call the onPressed callback
    widget.onPressed?.call();
  }

  /// Handle InkWell tap (for better test compatibility)
  void _handleInkWellTap() {
    if (widget.disabled || widget.isLoading || widget.onPressed == null) {
      return;
    }

    // Call the onPressed callback directly for InkWell
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.onPressed == null;
    final gradientColors = _getGradientColors();
    final backgroundColor = _getBackgroundColor();
    final borderColor = _getBorderColor();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: (_) => _handlePress(),
            child: Container(
              width: widget.width,
              height: widget.height ?? AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                gradient: LinearGradient(
                  colors:
                      isDisabled
                          ? [
                            Colors.grey.withOpacity(0.3),
                            Colors.grey.withOpacity(0.1),
                          ]
                          : gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color:
                      isDisabled ? Colors.grey.withOpacity(0.2) : borderColor,
                  width: 1.0,
                ),
                boxShadow:
                    isDisabled
                        ? null
                        : [
                          BoxShadow(
                            color: gradientColors.first.withOpacity(0.3),
                            blurRadius: AppDimensions.blurLight,
                            offset: const Offset(0, 4),
                          ),
                        ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppDimensions.blurLight,
                    sigmaY: AppDimensions.blurLight,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDisabled
                              ? Colors.grey.withOpacity(0.1)
                              : backgroundColor,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.buttonRadius,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.buttonRadius,
                        ),
                        onTap:
                            (isDisabled || widget.isLoading)
                                ? null
                                : _handleInkWellTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.buttonPaddingHorizontal,
                            vertical: AppDimensions.buttonPaddingVertical,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.isLoading) ...[
                                AnimatedBuilder(
                                  animation: _rotationAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle:
                                          _rotationAnimation.value *
                                          2 *
                                          3.14159,
                                      child: SizedBox(
                                        width: AppDimensions.iconMd,
                                        height: AppDimensions.iconMd,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                isDisabled
                                                    ? Colors.grey
                                                    : AppColors.text,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: AppDimensions.spacingMd),
                              ] else if (widget.icon != null) ...[
                                widget.icon!,
                                const SizedBox(width: AppDimensions.spacingMd),
                              ],
                              Flexible(
                                child: Text(
                                  widget.text,
                                  style:
                                      widget.textStyle ??
                                      TextStyle(
                                        color:
                                            isDisabled
                                                ? Colors.grey
                                                : AppColors.text,
                                        fontSize: AppDimensions.fontSizeMd,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

/// Convenience constructors for different button styles

/// Primary glassmorphism button with green gradient
class PrimaryGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool disabled;

  const PrimaryGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      disabled: disabled,
      style: GlassButtonStyle.primary,
    );
  }
}

/// Secondary glassmorphism button with blue gradient
class SecondaryGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool disabled;

  const SecondaryGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      disabled: disabled,
      style: GlassButtonStyle.secondary,
    );
  }
}

/// Social glassmorphism button with glass gradient
class SocialGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool disabled;

  const SocialGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      disabled: disabled,
      style: GlassButtonStyle.social,
    );
  }
}
