// Homio CRM — Reusable Filter Bar for Communication Modules

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';

class CommFilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String? searchHint;
  final String? selectedCategory;
  final List<String>? categories;
  final ValueChanged<String>? onCategorySelected;
  final CommunicationChannel? selectedChannel;
  final ValueChanged<CommunicationChannel?>? onChannelChanged;
  final CustomerCrmStage? selectedCrmStage;
  final ValueChanged<CustomerCrmStage?>? onCrmStageChanged;
  final VoidCallback? onResetFilters;
  final List<Widget>? customFilters;

  const CommFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    this.searchHint = 'Search by name, phone, message...',
    this.selectedCategory,
    this.categories,
    this.onCategorySelected,
    this.selectedChannel,
    this.onChannelChanged,
    this.selectedCrmStage,
    this.onCrmStageChanged,
    this.onResetFilters,
    this.customFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    onChanged: onSearchChanged,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      filled: true,
                      fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (onChannelChanged != null) ...[
                const SizedBox(width: 10),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CommunicationChannel?>(
                      value: selectedChannel,
                      hint: Text(
                        'All Channels',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      onChanged: onChannelChanged,
                      items: [
                        const DropdownMenuItem<CommunicationChannel?>(
                          value: null,
                          child: Text('All Channels', style: TextStyle(fontSize: 12)),
                        ),
                        ...CommunicationChannel.values.map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                Icon(c.icon, size: 14, color: c.color),
                                const SizedBox(width: 6),
                                Text(c.label, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (onCrmStageChanged != null) ...[
                const SizedBox(width: 10),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CustomerCrmStage?>(
                      value: selectedCrmStage,
                      hint: Text(
                        'All CRM Stages',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      onChanged: onCrmStageChanged,
                      items: [
                        const DropdownMenuItem<CustomerCrmStage?>(
                          value: null,
                          child: Text('All CRM Stages', style: TextStyle(fontSize: 12)),
                        ),
                        ...CustomerCrmStage.values.map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.label, style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              ...?customFilters,
              if (onResetFilters != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onResetFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                  tooltip: 'Reset all filters',
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ],
            ],
          ),
          if (categories != null && categories!.isNotEmpty) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories!.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                      onSelected: (_) => onCategorySelected?.call(cat),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
