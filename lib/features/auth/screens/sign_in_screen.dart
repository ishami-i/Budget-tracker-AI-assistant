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

/// Sign-in screen with glassmorphism design and form validation
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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

  /// Handle sign-in form submission
  Future<void> _handleSignIn() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign in
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        // Navigate to dashboard on success
        final appState = Provider.of<AppStateModel>(context, listen: false);
        appState.completeAuthentication();
        // Show success SnackBar (Task 21.2 preview)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
        });
        _showErrorDialog('Sign In Error', e.message);
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

  /// Navigate to sign-up screen
  void _navigateToSignUp() {
    final appState = Provider.of<AppStateModel>(context, listen: false);
    appState.navigateToSignUp();

    // Navigate to sign-up screen
    NavigationService.pushReplacementNamed(AppRoutes.signUp);
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

  /// Show "Coming Soon" dialog for forgot password
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.glassCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
            title: const Text(
              'Forgot Password',
              style: TextStyle(color: AppColors.text),
            ),
            content: const Text(
              'Password reset functionality will be available in a future update.',
              style: TextStyle(color: AppColors.textSecondary),
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
          appState.navigateToState(AppState.onboarding, validate: false);
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
                          horizontal: AppDimensions.paddingLg,
                        );
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontal.left,
                    right: horizontal.right,
                    top:
                        isLandscape
                            ? AppDimensions.spacingXl
                            : AppDimensions.paddingLg,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        (isLandscape
                            ? AppDimensions.spacingXl
                            : AppDimensions.paddingLg),
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
                                  : AppDimensions.spacingXl,
                        ),
                        // Logo and title
                        Column(
                          children: [
                            Container(
                              width: isTablet ? 100 : 80,
                              height: isTablet ? 100 : 80,
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
                                size: isTablet ? 56 : 40,
                              ),
                            ),
                            SizedBox(
                              height:
                                  isLandscape
                                      ? AppDimensions.spacingLg
                                      : AppDimensions.spacingLg,
                            ),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: isTablet ? 36 : 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingSm),
                            Text(
                              'Sign in to continue to SmartBudget AI',
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

                        const SizedBox(height: AppDimensions.spacingXl * 2),

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

                        const SizedBox(height: AppDimensions.spacingLg),

                        // Password input
                        GlassInput(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outlined,
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _handleSignIn(),
                        ),

                        const SizedBox(height: AppDimensions.spacingMd),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.neonGreen,
                                fontSize: AppDimensions.fontSizeSm,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacingXl),

                        // Sign in button
                        PrimaryGlassButton(
                          text: 'Sign In',
                          onPressed: _isLoading ? null : _handleSignIn,
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

                        // Sign up link (wrap to avoid overflow on narrow widths)
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppDimensions.fontSizeMd,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToSignUp,
                              child: const Text(
                                'Sign Up',
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
