import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Granular client proposal visibility toggles matching PRD Section 9.2 & 21.
class VisibilityControls extends StatelessWidget {
  final VisibilitySettings settings;
  final ValueChanged<VisibilitySettings> onChanged;

  const VisibilityControls({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Client Proposal Visibility Controls',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Control which granular pricing & dimension columns appear on the client-facing PDF / web proposal to protect company IP.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),

          _buildToggleItem(
            title: 'Hide Item Unit Rates',
            subtitle: 'Removes the "Rate / Sq.Ft" column to prevent item-by-item rate negotiation.',
            value: settings.hideRate,
            onChanged: (v) => onChanged(settings.copyWith(hideRate: v)),
            isDark: isDark,
          ),
          const Divider(height: 12),
          _buildToggleItem(
            title: 'Hide Dimensions & Sq.Ft Quantities',
            subtitle: 'Protects BOQ from being handed to local contractors for unauthorized execution.',
            value: settings.hideSqft,
            onChanged: (v) => onChanged(settings.copyWith(hideSqft: v)),
            isDark: isDark,
          ),
          const Divider(height: 12),
          _buildToggleItem(
            title: 'Display Lump Sum Grand Total',
            subtitle: 'Shows the consolidated payable total at the bottom of the proposal.',
            value: settings.showAmount,
            onChanged: (v) => onChanged(settings.copyWith(showAmount: v)),
            isDark: isDark,
          ),
          const Divider(height: 12),
          _buildToggleItem(
            title: 'Hide Approved Brand Names',
            subtitle: 'Conceals specific hardware brands (e.g. Blum, Hafele) during early concept stages.',
            value: settings.hideBrand,
            onChanged: (v) => onChanged(settings.copyWith(hideBrand: v)),
            isDark: isDark,
          ),
          const Divider(height: 12),
          _buildToggleItem(
            title: 'Show Payment Schedule Breakdown',
            subtitle: 'Displays milestone percentage milestones and triggering conditions.',
            value: settings.showPaymentSchedule,
            onChanged: (v) => onChanged(settings.copyWith(showPaymentSchedule: v)),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
