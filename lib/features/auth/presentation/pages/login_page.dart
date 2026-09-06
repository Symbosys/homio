import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_brand_panel.dart';
import '../widgets/login_form_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: ResponsiveLayout(
        compact: (context) => _buildMobileLayout(context),
        medium: (context) => _buildMobileLayout(context),
        expanded: (context) => _buildDesktopLayout(context),
      ),
    );
  }

  // Split-Screen Desktop Layout (Fixed 100vh Viewport, No Scrollbars)
  Widget _buildDesktopLayout(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Row(
      children: [
        // Left Branding & Social Proof Panel (56% width)
        const Expanded(
          flex: 11,
          child: AuthBrandPanel(),
        ),

        // Right Authentication Form Panel (44% width)
        Expanded(
          flex: 9,
          child: Container(
            color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Subtle ambient micro-dot background for light mode
                if (!isDark)
                  CustomPaint(
                    painter: _DotGridPainter(),
                  ),

                // Centered Login Card
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isShortScreen = constraints.maxHeight < 630;

                    Widget card = ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: LoginFormCard(viewModel: _viewModel, isMobile: false),
                    );

                    if (isShortScreen) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Center(child: card),
                      );
                    }

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: card,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Mobile & Tablet Single-Column Layout
  Widget _buildMobileLayout(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: LoginFormCard(viewModel: _viewModel, isMobile: true),
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle decorative micro-dot grid pattern matching modern SaaS dashboards
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    const dotRadius = 1.0;

    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
