import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/budget_estimate.dart';

class BudgetBreakdownTable extends StatelessWidget {
  final List<BudgetPackageOption> packages;
  final String selectedPackageId;
  final ValueChanged<BudgetPackageOption> onSelectPackage;

  const BudgetBreakdownTable({
    super.key,
    required this.packages,
    required this.selectedPackageId,
    required this.onSelectPackage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: packages.map((pkg) {
              final isSelected = pkg.id == selectedPackageId;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildPackageCard(context, pkg, isSelected, isDark),
                ),
              );
            }).toList(),
          );
        }

        return Column(
          children: packages.map((pkg) {
            final isSelected = pkg.id == selectedPackageId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPackageCard(context, pkg, isSelected, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    BudgetPackageOption pkg,
    bool isSelected,
    bool isDark,
  ) {
    final isRecommended = pkg.id == 'pkg_premium';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryLight
              : (isRecommended
                  ? const Color(0xFF6366F1).withValues(alpha: 0.5)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          width: isSelected || isRecommended ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? AppColors.primaryLight.withValues(alpha: isDark ? 0.2 : 0.08)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: isRecommended ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.xs,
              ),
              child: Text(
                'RECOMMENDED BY HOMIO',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Text(
            pkg.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          Text(
            pkg.targetSegment,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${(pkg.totalCost / 100000).toStringAsFixed(2)} Lakhs',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          Text(
            '₹${pkg.perSqFtRate.toInt()} / sq.ft · ${pkg.warrantyYears} Years Warranty',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextMuted(context),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Text(
            'Key Specifications',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          ...pkg.highlightPoints.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Itemized Scope Split',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          ...pkg.scopeBreakdown.map(
            (scope) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scope.categoryName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${(scope.amount / 1000).toInt()}k (${scope.percentage.toStringAsFixed(0)}%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: AppRadius.full,
                    child: LinearProgressIndicator(
                      value: scope.percentage / 100,
                      minHeight: 4,
                      backgroundColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isRecommended ? AppColors.primaryLight : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onSelectPackage(pkg),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColors.success
                    : (isRecommended ? AppColors.primary : AppColors.getSurfaceSubtle(context)),
                foregroundColor: isSelected || isRecommended
                    ? Colors.white
                    : AppColors.getTextPrimary(context),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              ),
              child: Text(
                isSelected ? 'Selected Package' : 'Select Package',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
