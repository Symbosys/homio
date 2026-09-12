import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class Step3MaterialsFurniture extends StatelessWidget {
  final String selectedWood;
  final String selectedMetal;
  final List<String> selectedElements;
  final ValueChanged<String> onWoodChanged;
  final ValueChanged<String> onMetalChanged;
  final ValueChanged<String> onToggleElement;

  const Step3MaterialsFurniture({
    super.key,
    required this.selectedWood,
    required this.selectedMetal,
    required this.selectedElements,
    required this.onWoodChanged,
    required this.onMetalChanged,
    required this.onToggleElement,
  });

  static const List<String> woodFinishes = [
    'Smoked European Oak',
    'Natural Burma Teak',
    'Bleached Nordic Birch',
    'American Walnut Veneer',
    'Charcoal Stained Ash',
  ];

  static const List<String> metalAccents = [
    'Brushed Brass (Gold Satin)',
    'Matte Powder-Coated Black',
    'Rose Gold Metallic',
    'Brushed Gunmetal / Anthracite',
  ];

  static const List<String> possibleElements = [
    'Floating Marble/Fluted TV Console',
    'Fluted Acoustic Rafter Headboard',
    'Indirect False Ceiling LED Profile Tracks',
    'Built-in Workstation / Study Nook',
    'Floor-to-Ceiling Tinted Glass Wardrobe',
    'Accent Wall with Microcement / Lime Wash',
    'Pendant Bedside Droplights',
    'Ergonomic Ambient Reading Sconces',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Woodwork Finish',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Defines the tone of custom cabinetry, wall paneling, and storage units.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: woodFinishes.map((wood) {
            final isSelected = wood == selectedWood;
            return ChoiceChip(
              label: Text(
                wood,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onWoodChanged(wood),
              selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
              backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryLight
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryLight.withValues(alpha: 0.6)
                    : Colors.transparent,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 20),
        Text(
          'Hardware & Metallic Trim Accents',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: metalAccents.map((metal) {
            final isSelected = metal == selectedMetal;
            return ChoiceChip(
              label: Text(
                metal,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onMetalChanged(metal),
              selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
              backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryLight
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryLight.withValues(alpha: 0.6)
                    : Colors.transparent,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 20),
        Text(
          'Must-Have Built-in Elements',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select the specific architectural features you want the 3D model to include.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: possibleElements.map((element) {
            final isChecked = selectedElements.contains(element);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: isChecked,
                onChanged: (_) => onToggleElement(element),
                title: Text(
                  element,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                activeColor: AppColors.primaryLight,
                checkColor: Colors.white,
                tileColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                  side: BorderSide(
                    color: isChecked
                        ? AppColors.primaryLight.withValues(alpha: 0.5)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                dense: true,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
