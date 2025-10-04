import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

/// A glassmorphism-styled input field with focus animations and validation
class GlassInput extends StatefulWidget {
  /// The text to display as a hint
  final String? hintText;

  /// The text to display as a label
  final String? labelText;

  /// The controller for the text field
  final TextEditingController? controller;

  /// The validator function for form validation
  final String? Function(String?)? validator;

  /// Whether this is a password field
  final bool isPassword;

  /// The keyboard type
  final TextInputType keyboardType;

  /// Whether the field is enabled
  final bool enabled;

  /// The prefix icon
  final IconData? prefixIcon;

  /// The suffix icon (overridden by password toggle if isPassword is true)
  final IconData? suffixIcon;

  /// Callback when the field value changes
  final void Function(String)? onChanged;

  /// Callback when the field is submitted
  final void Function(String)? onFieldSubmitted;

  /// The focus node for the field
  final FocusNode? focusNode;

  /// The text input action
  final TextInputAction? textInputAction;

  /// Maximum number of lines
  final int maxLines;

  /// Whether to auto-focus the field
  final bool autofocus;

  const GlassInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.maxLines = 1,
    this.autofocus = false,
  });

  @override
  State<GlassInput> createState() => _GlassInputState();
}

class _GlassInputState extends State<GlassInput>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;

  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _glowAnimation;

  bool _obscureText = true;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationMedium),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppColors.glassBorderInput,
      end: AppColors.neonGreen,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                border: Border.all(
                  color:
                      _errorText != null
                          ? AppColors.error
                          : _borderColorAnimation.value ??
                              AppColors.glassBorderInput,
                  width: _isFocused ? 2.0 : 1.0,
                ),
                boxShadow:
                    _isFocused && _errorText == null
                        ? [
                          BoxShadow(
                            color: AppColors.neonGreenGlow.withOpacity(
                              _glowAnimation.value * 0.3,
                            ),
                            blurRadius: AppDimensions.blurMedium,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: AppColors.neonGreenGlowLight.withOpacity(
                              _glowAnimation.value * 0.2,
                            ),
                            blurRadius: AppDimensions.blurHeavy,
                            spreadRadius: 4.0,
                          ),
                        ]
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppDimensions.blurLight,
                    sigmaY: AppDimensions.blurLight,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassInput,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.inputRadius,
                      ),
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      validator: (value) {
                        final error = widget.validator?.call(value);
                        setState(() {
                          _errorText = error;
                        });
                        return null; // Return null to prevent TextFormField from showing its own error
                      },
                      obscureText: widget.isPassword ? _obscureText : false,
                      keyboardType: widget.keyboardType,
                      enabled: widget.enabled,
                      onChanged: widget.onChanged,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      textInputAction: widget.textInputAction,
                      maxLines: widget.maxLines,
                      autofocus: widget.autofocus,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: AppDimensions.fontSizeMd,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontSizeMd,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon:
                            widget.prefixIcon != null
                                ? Icon(
                                  widget.prefixIcon,
                                  color:
                                      _isFocused
                                          ? AppColors.neonGreen
                                          : AppColors.textSecondary,
                                  size: AppDimensions.iconMd,
                                )
                                : null,
                        suffixIcon:
                            widget.isPassword
                                ? IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  tooltip: 'Toggle password visibility',
                                  iconSize: 28,
                                  splashRadius: 24,
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        _isFocused
                                            ? AppColors.neonGreen
                                            : AppColors.textSecondary,
                                    size: AppDimensions.iconMd,
                                  ),
                                )
                                : widget.suffixIcon != null
                                ? Icon(
                                  widget.suffixIcon,
                                  color:
                                      _isFocused
                                          ? AppColors.neonGreen
                                          : AppColors.textSecondary,
                                  size: AppDimensions.iconMd,
                                )
                                : null,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 64,
                          minHeight: 64,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.inputPaddingHorizontal,
                          vertical: AppDimensions.inputPaddingVertical,
                        ),
                        errorStyle: const TextStyle(height: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              AnimatedOpacity(
                opacity: _errorText != null ? 1.0 : 0.0,
                duration: const Duration(
                  milliseconds: AppDimensions.animationFast,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppDimensions.iconSm,
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: AppDimensions.fontSizeXs,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
