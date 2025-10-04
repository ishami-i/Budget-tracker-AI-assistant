import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/glass_background.dart';
import '../../../shared/widgets/floating_3d.dart';
import '../../../shared/widgets/card_3d.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../shared/services/app_state_model.dart';

/// Main dashboard screen with animated logo, welcome text, and feature cards
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimensions.animationMedium),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOutBack,
    );

    // Start the checkmark animation on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final appState = Provider.of<AppStateModel>(context, listen: false);
          appState.navigateToSignIn();
          return false;
        },
        child: GlassBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with animated logo and welcome
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animated logo using Floating3D
                      const RepaintBoundary(
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Floating3D(
                            intensity: 0.6,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.text,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Welcome to SmartBudget AI',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacingSm),
                                RepaintBoundary(
                                  child: ScaleTransition(
                                    scale: _checkScale,
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: AppColors.neonGreen,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingXs),
                            const Text(
                              'Your financial overview at a glance',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppDimensions.fontSizeSm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingXl),

                  // Feature cards grid
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        final crossAxisCount = isWide ? 3 : 2;
                        return RepaintBoundary(
                          child: GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: AppDimensions.spacingMd,
                            mainAxisSpacing: AppDimensions.spacingMd,
                            children: [
                              _DashboardFeatureCard(
                                title: 'Set Income',
                                icon: Icons.attach_money,
                                gradientColors: AppColors.gradientGreen,
                                onTap:
                                    () =>
                                        _showComingSoon(context, 'Set Income'),
                              ),
                              _DashboardFeatureCard(
                                title: 'AI Analysis',
                                icon: Icons.analytics_outlined,
                                gradientColors: AppColors.gradientBlue,
                                onTap:
                                    () =>
                                        _showComingSoon(context, 'AI Analysis'),
                              ),
                              _DashboardFeatureCard(
                                title: 'Save More',
                                icon: Icons.savings_outlined,
                                gradientColors: AppColors.gradientGlass,
                                onTap:
                                    () => _showComingSoon(context, 'Save More'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Footer with logout button
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () {
                        final appState = Provider.of<AppStateModel>(
                          context,
                          listen: false,
                        );
                        appState.signOut();
                      },
                      icon: const Icon(Icons.logout, color: AppColors.text),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: AppColors.text),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.glassButton,
                        foregroundColor: AppColors.text,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.buttonRadius,
                          ),
                          side: const BorderSide(
                            color: AppColors.glassBorderButton,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.buttonPaddingHorizontal,
                          vertical: AppDimensions.buttonPaddingVertical,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
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
              '$feature will be available in a future update.',
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
}

class _DashboardFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const _DashboardFeatureCard({
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      onTap: onTap,
      child: Card3D(
        interactive: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      gradientColors
                          .map((c) => c.withValues(alpha: 0.35))
                          .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.text, size: AppDimensions.iconLg),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: AppDimensions.fontSizeMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
