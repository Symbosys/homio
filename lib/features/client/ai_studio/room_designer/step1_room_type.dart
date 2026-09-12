import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/room_design_session.dart';

class Step1RoomType extends StatelessWidget {
  final RoomType selectedRoomType;
  final double lengthFt;
  final double widthFt;
  final double ceilingHeightFt;
  final ValueChanged<RoomType> onRoomTypeChanged;
  final ValueChanged<double> onLengthChanged;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onCeilingHeightChanged;

  const Step1RoomType({
    super.key,
    required this.selectedRoomType,
    required this.lengthFt,
    required this.widthFt,
    required this.ceilingHeightFt,
    required this.onRoomTypeChanged,
    required this.onLengthChanged,
    required this.onWidthChanged,
    required this.onCeilingHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final floorArea = lengthFt * widthFt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Room Category',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose the exact space you wish to redesign. Dimensions calibrate camera perspective.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 650;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: RoomType.values.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isNarrow ? 1 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isNarrow ? 3.0 : 2.5,
              ),
              itemBuilder: (context, index) {
                final type = RoomType.values[index];
                final isSelected = type == selectedRoomType;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.md,
                    onTap: () => onRoomTypeChanged(type),
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryLight.withValues(alpha: 0.2)
                                  : (isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9)),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Icon(
                              _getRoomIcon(type),
                              color: isSelected ? AppColors.primaryLight : AppColors.getTextMuted(context),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  type.label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  type.description,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryLight,
                              size: 18,
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
        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 20),
        Text(
          'Room Dimensions & Clear Height',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            children: [
              _buildDimensionSlider(
                context,
                title: 'Room Length',
                value: lengthFt,
                min: 8,
                max: 32,
                unit: 'ft',
                onChanged: onLengthChanged,
              ),
              const SizedBox(height: 12),
              _buildDimensionSlider(
                context,
                title: 'Room Width',
                value: widthFt,
                min: 8,
                max: 28,
                unit: 'ft',
                onChanged: onWidthChanged,
              ),
              const SizedBox(height: 12),
              _buildDimensionSlider(
                context,
                title: 'Slab Clear Height',
                value: ceilingHeightFt,
                min: 9,
                max: 14,
                unit: 'ft',
                onChanged: onCeilingHeightChanged,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: AppRadius.md,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.square_foot_rounded, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 10),
                    Text(
                      'Calculated Floor Area: ${floorArea.toStringAsFixed(1)} sq.ft',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDimensionSlider(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 2).toInt(),
            activeColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '${value.toStringAsFixed(1)} $unit',
            textAlign: TextAlign.end,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getRoomIcon(RoomType type) {
    switch (type) {
      case RoomType.livingRoom:
        return Icons.weekend_rounded;
      case RoomType.masterBedroom:
        return Icons.bed_rounded;
      case RoomType.modularKitchen:
        return Icons.soup_kitchen_rounded;
      case RoomType.kidsBedroom:
        return Icons.toys_rounded;
      case RoomType.diningRoom:
        return Icons.table_restaurant_rounded;
      case RoomType.poojaRoom:
        return Icons.spa_rounded;
      case RoomType.homeOffice:
        return Icons.computer_rounded;
      case RoomType.balconyGarden:
        return Icons.deck_rounded;
    }
  }
}
