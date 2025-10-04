import 'package:flutter/material.dart';
import 'glass_input.dart';
import 'glass_background.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/validators.dart';

/// Example screen demonstrating GlassInput widget usage
class GlassInputExample extends StatefulWidget {
  const GlassInputExample({super.key});

  @override
  State<GlassInputExample> createState() => _GlassInputExampleState();
}

class _GlassInputExampleState extends State<GlassInputExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form is valid!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Glass Input Example'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: GlassBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingXl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Glass Input Components',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: AppDimensions.fontSizeXxl,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingXxxl),
                  
                  // Name input
                  GlassInput(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _nameController,
                    validator: Validators.name,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  
                  // Email input
                  GlassInput(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  
                  // Password input
                  GlassInput(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    validator: Validators.password,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  
                  // Confirm password input
                  GlassInput(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    controller: _confirmPasswordController,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxxl),
                  
                  // Submit button
                  Container(
                    height: AppDimensions.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.gradientGreen,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreenGlow.withOpacity(0.3),
                          blurRadius: AppDimensions.blurMedium,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _submitForm,
                        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                        child: const Center(
                          child: Text(
                            'Validate Form',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: AppDimensions.fontSizeLg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  
                  // Disabled input example
                  const GlassInput(
                    labelText: 'Disabled Input',
                    hintText: 'This input is disabled',
                    enabled: false,
                    prefixIcon: Icons.block,
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  
                  // Multi-line input example
                  const GlassInput(
                    labelText: 'Comments',
                    hintText: 'Enter your comments here...',
                    maxLines: 4,
                    prefixIcon: Icons.comment_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}