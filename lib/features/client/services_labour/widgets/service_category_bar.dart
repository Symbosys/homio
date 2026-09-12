import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/service_labour_models.dart';

/// Horizontal trade / category filter chip bar
class ServiceCategoryBar extends StatelessWidget {
  final List<ServiceCategoryItem> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const ServiceCategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat.name;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(
                cat.icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              label: Text(
                '${cat.name} (${cat.providerCount})',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(cat.name),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
