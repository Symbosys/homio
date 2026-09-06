import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../view_models/auth_view_model.dart';
import 'social_auth_buttons.dart';

/// Right-hand authentication card matching the exact high-fidelity mockup.
/// Fits completely within standard viewport heights without scrolling.
class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.viewModel,
    this.isMobile = false,
  });

  final AuthViewModel viewModel;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20.0 : 24.0,
            vertical: isMobile ? 20.0 : 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Floating App Badge & Portal Switcher
              Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: viewModel.isClientPortal
                          ? const [Color(0xFF34D399), Color(0xFF10B981), Color(0xFF059669)]
                          : const [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (viewModel.isClientPortal ? const Color(0xFF10B981) : const Color(0xFF6366F1))
                            .withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    viewModel.isClientPortal ? Icons.home_repair_service_rounded : Icons.layers_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Portal Switcher Segmented Control
              Container(
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => viewModel.setPortalMode(AuthPortalMode.teamCrm),
                        borderRadius: BorderRadius.circular(7),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          decoration: BoxDecoration(
                            color: !viewModel.isClientPortal
                                ? (isDark ? const Color(0xFF334155) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: !viewModel.isClientPortal
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.business_center_rounded,
                                size: 13,
                                color: !viewModel.isClientPortal
                                    ? const Color(0xFF6366F1)
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Team / CRM',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: !viewModel.isClientPortal ? FontWeight.w700 : FontWeight.w500,
                                    color: !viewModel.isClientPortal
                                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => viewModel.setPortalMode(AuthPortalMode.clientPortal),
                        borderRadius: BorderRadius.circular(7),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          decoration: BoxDecoration(
                            color: viewModel.isClientPortal
                                ? (isDark ? const Color(0xFF334155) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: viewModel.isClientPortal
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home_rounded,
                                size: 13,
                                color: viewModel.isClientPortal
                                    ? const Color(0xFF10B981)
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Client Portal',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: viewModel.isClientPortal ? FontWeight.w700 : FontWeight.w500,
                                    color: viewModel.isClientPortal
                                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
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
              const SizedBox(height: 12),

              // Title
              Text(
                viewModel.isClientPortal ? 'Client Portal' : 'Welcome back',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),

              // Subtitle
              Text(
                viewModel.isClientPortal
                    ? 'Sign in to track your home interior & turnkey project'
                    : 'Sign in to access your organization workspace',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),

              // Magic Link / Passwordless Sign In Box
              InkWell(
                onTap: viewModel.fillDemoCredentials,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1B4B).withValues(alpha: 0.25)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF312E81) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: (viewModel.isClientPortal ? const Color(0xFF10B981) : const Color(0xFF6366F1))
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: viewModel.isClientPortal ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.isClientPortal
                                  ? 'Demo Homeowner: Villa 402 Project'
                                  : 'Use magic link for a passwordless sign in',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              viewModel.isClientPortal
                                  ? 'sarah.homeowner@gmail.com'
                                  : 'alex@homioworkspace.com',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Divider: or continue with email
              _buildTextDivider(
                text: 'or continue with email',
                isDark: isDark,
              ),
              const SizedBox(height: 12),

              // Work Email Address
              AppTextField(
                label: viewModel.isClientPortal ? 'Account Email Address' : 'Work Email Address',
                hint: viewModel.isClientPortal ? 'name@gmail.com' : 'name@company.com',
                controller: viewModel.emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                enabled: !viewModel.isLoading,
                isDense: true,
                errorText: viewModel.errorMessage != null &&
                        viewModel.validateEmail(viewModel.emailController.text) != null
                    ? viewModel.errorMessage
                    : null,
              ),
              const SizedBox(height: 10),

              // Password
              AppTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: viewModel.passwordController,
                isPassword: true,
                prefixIcon: Icons.lock_outline_rounded,
                enabled: !viewModel.isLoading,
                isDense: true,
                errorText: viewModel.errorMessage != null &&
                        viewModel.validatePassword(viewModel.passwordController.text) != null
                    ? viewModel.errorMessage
                    : null,
                onSubmitted: (_) => viewModel.login(),
              ),
              const SizedBox(height: 10),

              // Remember Me & Forgot Password
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: viewModel.rememberMe,
                          onChanged: viewModel.isLoading
                              ? null
                              : (val) => viewModel.setRememberMe(val ?? true),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          activeColor: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Remember me',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset instructions sent to your email.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Primary Submit Button (Height 42px)
              SizedBox(
                height: 42,
                child: AppButton(
                  text: viewModel.isClientPortal ? 'Access Client Portal' : 'Sign in to Workspace',
                  size: AppButtonSize.medium,
                  isFullWidth: true,
                  isLoading: viewModel.isLoading,
                  suffixIcon: Icons.arrow_forward_rounded,
                  onPressed: () async {
                    final success = await viewModel.login();
                    if (success && context.mounted) {
                      if (viewModel.isClientPortal) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Welcome to your Homeowner Portal (Villa 402)!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                        context.goNamed(RouteNames.clientOverview);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sign in successful! Welcome to Homio Workspace.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        context.goNamed(RouteNames.dashboardOverview);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Divider: or continue with
              _buildTextDivider(
                text: 'or continue with',
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              // Social Auth Buttons (Google Workspace & Microsoft 365)
              const SocialAuthButtons(),
              const SizedBox(height: 14),

              // Footer: Don't have a workspace? Start 14-day free trial
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have a workspace? ",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.goNamed(RouteNames.landing),
                      child: Text(
                        'Start 14-day free trial',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextDivider({required String text, required bool isDark}) {
    final lineColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }
}
