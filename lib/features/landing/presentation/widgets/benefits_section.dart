import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 48 : 80),
      child: AdaptiveContainer(
        child: Column(
          children: [
            // Section Header
            AppBadge(
              label: 'MEASURABLE BUSINESS IMPACT',
              icon: Icons.trending_up_rounded,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Why Growing Companies Choose Homio',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isCompact ? 26 : 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'Focus on concrete business outcomes: faster sales conversions, zero project blind spots, and reduced operational overhead.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 14.5 : 16.5,
                  height: 1.6,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // 4 Outcome Stat Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width < 600 ? 1 : (width < 1000 ? 2 : 4);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppConstants.businessOutcomes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 350,
                  ),
                  itemBuilder: (context, index) {
                    final item = AppConstants.businessOutcomes[index];

                    return AppCard(
                      padding: const EdgeInsets.all(24),
                      borderRadius: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['stat'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              item['description'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                height: 1.5,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
