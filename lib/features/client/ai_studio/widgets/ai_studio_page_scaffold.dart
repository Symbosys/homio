import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import 'ai_credit_chip.dart';
import 'ai_project_context_banner.dart';

class AiStudioPageScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? parentTitle;
  final String? parentRoute;
  final bool showProjectBanner;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;

  const AiStudioPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.parentTitle = 'AI Studio',
    this.parentRoute = RouteNames.clientAiSuitePath,
    this.showProjectBanner = true,
    this.actions,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Breadcrumb Navigation & Credit Chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (parentRoute != null) ...[
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Back to $parentTitle',
                          color: AppColors.getTextPrimary(context),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                isDark ? const Color(0xFF1E2433) : const Color(0xFFF1F5F9),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                          ),
                          onPressed: () => context.go(parentRoute!),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (parentRoute != null)
                              Text(
                                '$parentTitle > $title',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.getTextMuted(context),
                                ),
                              ),
                            Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.getTextPrimary(context),
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Live Credit Balance Chip
                      const AiCreditChip(),
                      if (actions != null) ...[
                        const SizedBox(width: 8),
                        ...actions!,
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (showProjectBanner) ...[
                    const AiProjectContextBanner(compact: true),
                    const SizedBox(height: 18),
                  ],
                  // Main Content Body
                  body,
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
