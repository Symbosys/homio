import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_models.dart';

/// Modal bottom sheet / slide-over drawer for multi-criteria enterprise filtering.
class ReportsFilterDrawer extends StatefulWidget {
  final ReportFilterState initialFilter;
  final ValueChanged<ReportFilterState> onApply;

  const ReportsFilterDrawer({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required ReportFilterState initialFilter,
    required ValueChanged<ReportFilterState> onApply,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ReportsFilterDrawer(
          initialFilter: initialFilter,
          onApply: onApply,
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (ctx) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: ReportsFilterDrawer(
              initialFilter: initialFilter,
              onApply: onApply,
            ),
          ),
        ),
      );
    }
  }

  @override
  State<ReportsFilterDrawer> createState() => _ReportsFilterDrawerState();
}

class _ReportsFilterDrawerState extends State<ReportsFilterDrawer> {
  late ReportFilterState _current;
  late TextEditingController _searchController;

  static const _branches = [
    'All Branches',
    'Bangalore Central (Indiranagar)',
    'Bangalore South (Whitefield)',
    'Mumbai BKC Flagship',
    'Delhi NCR (Gurgaon Golf Course)',
    'Hyderabad HiTech City',
  ];

  static const _businessUnits = [
    'All Business Units',
    'Luxury Turnkey Residential',
    'Modular Kitchen & Wardrobes',
    'Commercial & Retail Fitouts',
    'Architectural Civil Execution',
  ];

  static const _regions = [
    'All Regions',
    'South Cluster (BLR / HYD)',
    'West Cluster (MUM / PUNE)',
    'North Cluster (DELHI / GGN)',
  ];

  static const _teams = [
    'All Teams',
    'Senior Design Studio',
    'Sales Elite Team',
    'Site Execution & PMC',
    'Procurement & Materials',
  ];

  static const _owners = [
    'All Owners',
    'Aarav Singhania (Sales Lead)',
    'Pooja Hegde (Consultant)',
    'Rohan Deshmukh (Consultant)',
    'Kriti Sanon (Design Lead)',
    'Vikram Malhotra (Project PM)',
    'Sunil Gavaskar (Site PM)',
  ];

  static const _statuses = [
    'All Statuses',
    'On Track',
    'At Risk',
    'Delayed',
    'Critical',
    'Completed',
  ];

  static const _priorities = [
    'All Priorities',
    'High',
    'Medium',
    'Low',
  ];

  static const _customerTypes = [
    'All Types',
    'Luxury Villa (₹25L+)',
    'Premium 3BHK/4BHK (₹10L-₹25L)',
    'Standard Modular (₹5L-₹10L)',
    'Commercial Penthouse',
  ];

  @override
  void initState() {
    super.initState();
    _current = widget.initialFilter;
    _searchController = TextEditingController(text: _current.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Reporting & Filter Controls',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Filter Sections
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search query input
                  Text(
                    'Search Keyword / Entity ID',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => _current = _current.copyWith(searchQuery: val),
                    style: GoogleFonts.inter(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'e.g. PRJ-1048, Hafele, Rahul Khurana...',
                      hintStyle: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      prefixIcon: const Icon(Icons.search_rounded, size: 16),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Branch selector
                  _buildDropdownSection(
                    label: 'Branch / Experience Center',
                    value: _current.branch,
                    items: _branches,
                    onChanged: (val) => setState(() => _current = _current.copyWith(branch: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Business Unit selector
                  _buildDropdownSection(
                    label: 'Business Unit / Service Line',
                    value: _current.businessUnit,
                    items: _businessUnits,
                    onChanged: (val) => setState(() => _current = _current.copyWith(businessUnit: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Region selector
                  _buildDropdownSection(
                    label: 'Operating Region / Territory',
                    value: _current.region,
                    items: _regions,
                    onChanged: (val) => setState(() => _current = _current.copyWith(region: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Team selector
                  _buildDropdownSection(
                    label: 'Functional Team',
                    value: _current.team,
                    items: _teams,
                    onChanged: (val) => setState(() => _current = _current.copyWith(team: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Owner selector
                  _buildDropdownSection(
                    label: 'Sales Owner / Project Manager / Lead',
                    value: _current.owner,
                    items: _owners,
                    onChanged: (val) => setState(() => _current = _current.copyWith(owner: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Status selector
                  _buildDropdownSection(
                    label: 'Execution / Deal Status',
                    value: _current.status,
                    items: _statuses,
                    onChanged: (val) => setState(() => _current = _current.copyWith(status: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Priority selector
                  _buildDropdownSection(
                    label: 'Priority Tier',
                    value: _current.priority,
                    items: _priorities,
                    onChanged: (val) => setState(() => _current = _current.copyWith(priority: val)),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Customer Type selector
                  _buildDropdownSection(
                    label: 'Customer Classification',
                    value: _current.customerType,
                    items: _customerTypes,
                    onChanged: (val) => setState(() => _current = _current.copyWith(customerType: val)),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _current = const ReportFilterState();
                      _searchController.clear();
                    });
                  },
                  child: Text(
                    'Reset All',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                      child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        widget.onApply(_current.copyWith(searchQuery: _searchController.text.trim()));
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              items: items.map((s) {
                return DropdownMenuItem<String>(
                  value: s,
                  child: Text(s, maxLines: 1, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }
}
