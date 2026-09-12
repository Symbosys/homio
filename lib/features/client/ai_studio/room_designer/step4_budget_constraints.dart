import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class Step4BudgetConstraints extends StatelessWidget {
  final String selectedBudgetBand;
  final String specialNotes;
  final String? uploadedPhotoName;
  final ValueChanged<String> onBudgetBandChanged;
  final ValueChanged<String> onSpecialNotesChanged;
  final VoidCallback onUploadPhoto;

  const Step4BudgetConstraints({
    super.key,
    required this.selectedBudgetBand,
    required this.specialNotes,
    this.uploadedPhotoName,
    required this.onBudgetBandChanged,
    required this.onSpecialNotesChanged,
    required this.onUploadPhoto,
  });

  static const List<Map<String, String>> budgetBands = [
    {
      'title': 'Essential (₹1.5L - ₹3.0L)',
      'subtitle': 'Commercial MR Plywood + 0.8mm Laminate + Standard Soft-Close',
      'highlight': 'Ideal for budget optimization or rental homes',
    },
    {
      'title': 'Premium Modern (₹3.0L - ₹6.0L)',
      'subtitle': 'CenturyPly BWP 710 + 1.5mm Acrylic + Hettich Sensys + Quartz',
      'highlight': 'Homeowner preferred · 10-year durability warranty',
    },
    {
      'title': 'Ultra-Luxury Bespoke (₹6.0L+)',
      'subtitle': 'Natural Veneer + Italian Statuario Marble + Blum Servo Drive + KNX',
      'highlight': 'Villa & Penthouse grade architectural finishes',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Room Budget Band',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'AI filters material grades and custom cabinetry hardware according to your target investment.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: budgetBands.map((band) {
            final isSelected = band['title'] == selectedBudgetBand;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.md,
                  onTap: () => onBudgetBandChanged(band['title']!),
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
                                band['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                band['subtitle']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                band['highlight']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryLight,
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
          'Upload Current Site Photo (Optional 50/50 Mode)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload an existing bare room or unfurnished site photo to generate a 50/50 before-and-after comparison slider.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 14),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.lg,
            onTap: onUploadPhoto,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.lg,
                border: Border.all(
                  color: isDark ? const Color(0xFF263554) : const Color(0xFFCBD5E1),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_rounded,
                      color: AppColors.primaryLight,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    uploadedPhotoName != null
                        ? 'Selected: $uploadedPhotoName'
                        : 'Tap to browse or drop current room photo',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supports JPG, PNG, WEBP up to 25MB · Floor plans also accepted',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: AppColors.getTextMuted(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Special Instructions & Spatial Requests',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: specialNotes,
          maxLines: 3,
          onChanged: onSpecialNotesChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.getTextPrimary(context),
          ),
          decoration: InputDecoration(
            hintText: 'e.g. Include a discreet space for robot vacuum dock, conceal AC drain pipes behind fluted slats...',
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.getTextMuted(context)),
            filled: true,
            fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
        ),
      ],
    );
  }
}
