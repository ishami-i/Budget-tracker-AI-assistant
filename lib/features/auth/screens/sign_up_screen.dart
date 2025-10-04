import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/glass_background.dart';
import '../../../shared/widgets/glass_input.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../shared/services/app_state_model.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../app/routes.dart';
import '../services/auth_service.dart';
import '../models/auth_exception.dart';

/// Sign-up screen with glassmorphism design and form validation
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _acceptTerms = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /// Validate name field
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validate email field
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // Basic email validation pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password field
  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  /// Validate confirm password field
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Show a glassmorphism error dialog for authentication errors
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.glassCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColors.neonGreen),
                ),
              ),
            ],
          ),
    );
  }

  /// Handle sign-up form submission
  Future<void> _handleSignUp() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check terms and conditions
    if (!_acceptTerms) {
      setState(() {
        _errorMessage = 'Please accept the Terms and Conditions to continue';
      });
      _showErrorDialog(
        'Terms Required',
        'Please accept the Terms and Conditions to continue',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign up with password confirmation
      await _authService.signUpWithConfirmation(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
        name: _nameController.text.trim(),
      );

      if (mounted) {
        // Navigate to dashboard on success
        final appState = Provider.of<AppStateModel>(context, listen: false);
        appState.completeAuthentication();
        // Show success SnackBar (Task 21.2 preview)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
        });
        _showErrorDialog('Sign Up Error', e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
        _showErrorDialog(
          'Unexpected Error',
          'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navigate to sign-in screen
  void _navigateToSignIn() {
    final appState = Provider.of<AppStateModel>(context, listen: false);
    appState.navigateToSignIn();

    // Navigate to sign-in screen
    NavigationService.pushReplacementNamed(AppRoutes.signIn);
  }

  /// Show "Coming Soon" dialog for social sign-in
  void _showComingSoonDialog(String provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.glassCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
            title: const Text(
              'Coming Soon',
              style: TextStyle(color: AppColors.text),
            ),
            content: Text(
              '$provider sign-in will be available in a future update.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColors.neonGreen),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet =
        MediaQuery.of(context).size.width > AppDimensions.breakpointTablet;
    // TODO: For desktop, consider a two-column layout or side illustration in the future.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () async {
          final appState = Provider.of<AppStateModel>(context, listen: false);
          appState.navigateToSignIn();
          NavigationService.pushReplacementNamed(AppRoutes.signIn);
          return false;
        },
        child: GlassBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal =
                    constraints.maxWidth > AppDimensions.breakpointMobile
                        ? EdgeInsets.symmetric(
                          horizontal:
                              (constraints.maxWidth -
                                  AppDimensions.maxContentWidth) /
                              2,
                        )
                        : const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSm,
                        );
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontal.left,
                    right: horizontal.right,
                    top:
                        isLandscape
                            ? AppDimensions.spacingXl
                            : AppDimensions.paddingSm,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        (isLandscape
                            ? AppDimensions.spacingXl
                            : AppDimensions.paddingSm),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height:
                              isLandscape
                                  ? AppDimensions.spacingXl
                                  : AppDimensions.spacingSm,
                        ),
                        // Logo and title
                        Column(
                          children: [
                            Container(
                              width: isTablet ? 80 : 56,
                              height: isTablet ? 80 : 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: AppColors.gradientGreen,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.text,
                                size: isTablet ? 40 : 28,
                              ),
                            ),
                            SizedBox(
                              height:
                                  isLandscape
                                      ? AppDimensions.spacingSm
                                      : AppDimensions.spacingSm,
                            ),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: isTablet ? 36 : 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingSm),
                            Text(
                              'Join SmartBudget AI to start managing your finances',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize:
                                    isTablet
                                        ? AppDimensions.fontSizeLg
                                        : AppDimensions.fontSizeMd,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        // Error message
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingMd,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.inputRadius,
                              ),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: AppDimensions.iconMd,
                                ),
                                const SizedBox(width: AppDimensions.spacingSm),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: AppDimensions.fontSizeSm,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),
                        ],

                        // Name input
                        GlassInput(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.person_outlined,
                          validator: _validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_emailFocusNode);
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        // Email input
                        GlassInput(
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.email_outlined,
                          validator: _validateEmail,
                          onFieldSubmitted: (_) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocusNode);
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        // Password input
                        GlassInput(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          isPassword: true,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_outlined,
                          validator: _validatePassword,
                          onFieldSubmitted: (_) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_confirmPasswordFocusNode);
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        // Confirm password input
                        GlassInput(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outlined,
                          validator: _validateConfirmPassword,
                          onFieldSubmitted: (_) => _handleSignUp(),
                        ),

                        const SizedBox(height: AppDimensions.spacingLg),

                        // Terms and conditions checkbox
                        Container(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingMd,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassCard.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputRadius,
                            ),
                            border: Border.all(
                              color: AppColors.glassBorderInput.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.neonGreen,
                                  checkColor: AppColors.background,
                                  side: BorderSide(
                                    color:
                                        _acceptTerms
                                            ? AppColors.neonGreen
                                            : AppColors.glassBorderInput,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacingSm),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _acceptTerms = !_acceptTerms;
                                    });
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: AppDimensions.fontSizeSm,
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: const TextStyle(
                                            color: AppColors.neonGreen,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: const TextStyle(
                                            color: AppColors.neonGreen,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacingXl),

                        // Sign up button
                        PrimaryGlassButton(
                          text: 'Create Account',
                          onPressed: _isLoading ? null : _handleSignUp,
                          isLoading: _isLoading,
                          height: AppDimensions.buttonHeight,
                        ),

                        const SizedBox(height: AppDimensions.spacingXl),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.glassBorderInput,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingMd,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: AppDimensions.fontSizeSm,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.glassBorderInput,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.spacingXl),

                        // Social sign-in buttons
                        SocialGlassButton(
                          text: 'Continue with Google',
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: AppColors.text,
                            size: AppDimensions.iconLg,
                          ),
                          onPressed: () => _showComingSoonDialog('Google'),
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        SocialGlassButton(
                          text: 'Continue with Apple',
                          icon: const Icon(
                            Icons.apple,
                            color: AppColors.text,
                            size: AppDimensions.iconMd,
                          ),
                          onPressed: () => _showComingSoonDialog('Apple'),
                        ),

                        const SizedBox(height: AppDimensions.spacingXl * 2),

                        // Sign in link (wrap to avoid overflow on narrow widths)
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppDimensions.fontSizeMd,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToSignIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.neonGreen,
                                  fontSize: AppDimensions.fontSizeMd,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.spacingLg),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
