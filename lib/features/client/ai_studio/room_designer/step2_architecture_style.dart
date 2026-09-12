import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../widgets/color_palette_picker.dart';

class Step2ArchitectureStyle extends StatelessWidget {
  final String selectedTheme;
  final String selectedLighting;
  final String selectedPaletteName;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<String> onLightingChanged;
  final ValueChanged<PaletteOption> onPaletteChanged;

  const Step2ArchitectureStyle({
    super.key,
    required this.selectedTheme,
    required this.selectedLighting,
    required this.selectedPaletteName,
    required this.onThemeChanged,
    required this.onLightingChanged,
    required this.onPaletteChanged,
  });

  static const List<Map<String, String>> styles = [
    {
      'title': 'Japandi Warm Minimalist',
      'subtitle': 'Clean lines, light oak timbers, wabi-sabi textures & serene zen lighting',
    },
    {
      'title': 'Contemporary Italian Luxury',
      'subtitle': 'Polished marble, fluted walnut panels, brushed brass accents & cove strips',
    },
    {
      'title': 'Modern Neo-Classical',
      'subtitle': 'Cornice mouldings, panel beadings, symmetrical chandeliers & rich textures',
    },
    {
      'title': 'Scandinavian Fresh',
      'subtitle': 'White canvas, ashwood furniture, natural linen and airy daylight',
    },
  ];

  static const List<String> lightingMoods = [
    'Warm Ambient 3000K (Cozy Evening)',
    'Natural Daylight 4500K (Clean Architectural)',
    'Dramatic Accent Cove & Profile LEDs',
    'Golden Hour Sunset Glow (3D Specular)',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Architectural Theme & Mood',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select the core design philosophy to guide AI texture mapping and 3D props.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: styles.map((s) {
            final isSelected = s['title'] == selectedTheme;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.md,
                  onTap: () => onThemeChanged(s['title']!),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF))
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      borderRadius: AppRadius.md,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryLight
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryLight : AppColors.getTextMuted(context),
                              width: isSelected ? 6 : 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s['subtitle']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 20),
        Text(
          'Curated Color Palette',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        ColorPalettePicker(
          palettes: ColorPalettePicker.defaultInteriorPalettes,
          selectedPaletteName: selectedPaletteName,
          onPaletteSelected: onPaletteChanged,
        ),
        const SizedBox(height: 20),
        Text(
          'Lighting Mood & Kelvin Temperature',
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
          children: lightingMoods.map((mood) {
            final isSelected = mood == selectedLighting;
            return ChoiceChip(
              label: Text(
                mood,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onLightingChanged(mood),
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
      ],
    );
  }
}
