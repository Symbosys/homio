import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/material_specification_item.dart';

class MaterialSpecCard extends StatelessWidget {
  final MaterialSpecificationItem item;
  final VoidCallback onToggleBOQ;

  const MaterialSpecCard({
    super.key,
    required this.item,
    required this.onToggleBOQ,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: item.isSavedToProjectBOQ
              ? AppColors.primaryLight.withValues(alpha: 0.7)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: item.isSavedToProjectBOQ ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  item.category.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const Spacer(),
              if (item.isEcoCertified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco_rounded, size: 12, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        'Green Certified',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  '${item.warrantyYears} Yr Warranty',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.productName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Brand: ${item.brand} · Code: ${item.gradeOrCode}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoLine(
                  context,
                  label: 'Application Area',
                  value: item.applicationArea,
                ),
                const SizedBox(height: 4),
                _buildInfoLine(
                  context,
                  label: 'Durability Standard',
                  value: item.durabilityLevel,
                ),
                if (item.alternativeBrands.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildInfoLine(
                    context,
                    label: 'Approved Alternatives',
                    value: item.alternativeBrands.join(', '),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Approx. Material Cost',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.getTextMuted(context),
                    ),
                  ),
                  Text(
                    '₹${item.costPerUnit.toInt()} / ${item.unit}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onToggleBOQ,
                icon: Icon(
                  item.isSavedToProjectBOQ
                      ? Icons.check_circle_rounded
                      : Icons.add_task_rounded,
                  size: 15,
                ),
                label: Text(
                  item.isSavedToProjectBOQ ? 'Linked to BOQ' : 'Sync to Project BOQ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.isSavedToProjectBOQ
                      ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5))
                      : AppColors.primary,
                  foregroundColor: item.isSavedToProjectBOQ
                      ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46))
                      : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLine(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextMuted(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ),
      ],
    );
  }
}
