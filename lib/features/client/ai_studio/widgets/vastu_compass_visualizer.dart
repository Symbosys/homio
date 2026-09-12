import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/vastu_analysis.dart';

class VastuCompassVisualizer extends StatelessWidget {
  final List<VastuZoneResult> zones;
  final ValueChanged<VastuZoneResult>? onZoneSelected;

  const VastuCompassVisualizer({
    super.key,
    required this.zones,
    this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.compass_calibration_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '8-Direction Vastu Chakra Alignment',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    'Tap any directional zone to inspect cosmic element harmony and remedies',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 3x3 Grid representing directional mandala
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: zones.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isNarrow ? 1 : (constraints.maxWidth < 900 ? 2 : 3),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isNarrow ? 2.5 : 1.7,
                ),
                itemBuilder: (context, index) {
                  final zone = zones[index];
                  final statusColor = Color(zone.status.colorHex);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: AppRadius.md,
                      onTap: () => onZoneSelected?.call(zone),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    zone.direction,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.15),
                                    borderRadius: AppRadius.xs,
                                  ),
                                  child: Text(
                                    '${zone.compliancePercent}%',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Room: ${zone.currentRoomPlacement}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                zone.energyAnalysis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: AppColors.getTextSecondary(context),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
