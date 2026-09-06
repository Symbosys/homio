import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompact;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 48 : 80),
      child: AdaptiveContainer(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 24 : 64,
            vertical: isCompact ? 48 : 72,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF0F172A), Color(0xFF31104B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 15, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 6),
                    Text(
                      'INSTANT WORKSPACE PROVISIONING',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Your Entire Business.\nOne Intelligent Workspace.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 28 : 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  height: 1.15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  'Bring customers, teams, site milestones, WhatsApp automation, and finance together. Start running seamless operations today.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isCompact ? 15 : 17,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // CTAs
              isCompact
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            text: 'Start Free 14-Day Trial',
                            size: AppButtonSize.large,
                            isFullWidth: true,
                            suffixIcon: Icons.arrow_forward_rounded,
                            onPressed: () => context.goNamed(RouteNames.login),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Sign In to Workspace',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.large,
                            isFullWidth: true,
                            onPressed: () => context.goNamed(RouteNames.login),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          text: 'Start Free 14-Day Trial',
                          size: AppButtonSize.large,
                          suffixIcon: Icons.arrow_forward_rounded,
                          onPressed: () => context.goNamed(RouteNames.login),
                        ),
                        const SizedBox(width: 16),
                        AppButton(
                          text: 'Sign In to Workspace',
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.large,
                          onPressed: () => context.goNamed(RouteNames.login),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),

              Text(
                'No credit card required • Cancel anytime • Free data onboarding',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
