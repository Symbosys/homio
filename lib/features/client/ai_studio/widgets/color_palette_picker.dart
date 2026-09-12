import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class PaletteOption {
  final String name;
  final String subtitle;
  final List<String> hexColors;

  const PaletteOption({
    required this.name,
    required this.subtitle,
    required this.hexColors,
  });
}

class ColorPalettePicker extends StatelessWidget {
  final List<PaletteOption> palettes;
  final String selectedPaletteName;
  final ValueChanged<PaletteOption> onPaletteSelected;

  const ColorPalettePicker({
    super.key,
    required this.palettes,
    required this.selectedPaletteName,
    required this.onPaletteSelected,
  });

  static const List<PaletteOption> defaultInteriorPalettes = [
    PaletteOption(
      name: 'Japandi Warm Earth',
      subtitle: 'Charcoal, Off-White, Smoked Oak, Linen',
      hexColors: ['#282624', '#F4F1EA', '#C2A383', '#7D7065'],
    ),
    PaletteOption(
      name: 'Modern Neo-Classical',
      subtitle: 'Navy Slate, Marble White, Brushed Gold, Greige',
      hexColors: ['#1A2530', '#FAF9F6', '#D4AF37', '#938B82'],
    ),
    PaletteOption(
      name: 'Scandinavian Clean',
      subtitle: 'Matte Black, Nordic White, Bleached Birch, Sage',
      hexColors: ['#18181B', '#FFFFFF', '#D9C5B2', '#8FA89B'],
    ),
    PaletteOption(
      name: 'Contemporary Terracotta',
      subtitle: 'Burnt Ochre, Raw Silk, Deep Bronze, Cream',
      hexColors: ['#A0522D', '#EDE6DB', '#4A3B32', '#FDFBF7'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: palettes.map((palette) {
        final isSelected = palette.name == selectedPaletteName;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: AppRadius.md,
              onTap: () => onPaletteSelected(palette),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF))
                      : (isDark ? AppColors.darkSurfaceSubtle : Colors.white),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryLight
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Swatches
                    Row(
                      children: palette.hexColors.map((hex) {
                        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                        return Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            palette.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            palette.subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: AppColors.primaryLight,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
