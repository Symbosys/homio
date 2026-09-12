import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 3: MATERIALS WORKSPACE
/// Connected client-side procurement & specification tracking:
/// - Procurement Status Strip (Approved, Ordered, Delivered, Pending Sign-off)
/// - Urgent Material Approval Alert for Factory Dispatch
/// - Search, Category & Room Filtering
/// - Interactive Material Cards with Detailed Spec Lightbox
/// - Homeowner Custom Material Request Dialog
/// - 100% Dark & Light mode compatible
class ClientMaterialsPage extends StatefulWidget {
  const ClientMaterialsPage({super.key});

  @override
  State<ClientMaterialsPage> createState() => _ClientMaterialsPageState();
}

class _ClientMaterialsPageState extends State<ClientMaterialsPage> {
  String _selectedCategory = 'All';
  String _selectedRoom = 'All Rooms';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Wood & Joinery',
    'Tiles & Marble',
    'Hardware & Fittings',
    'Electrical & Lighting',
    'Paints & Finishes',
    'False Ceiling',
  ];

  final List<String> _rooms = [
    'All Rooms',
    'Modular Kitchen',
    'Living Room & Dining Foyer',
    'Living, Dining & Master Bedroom',
    'Full Residence Circuits',
  ];

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allMaterials = ClientDataRepository.projectMaterials;

    // Filter materials
    final filteredMaterials = allMaterials.where((m) {
      final matchesCat = _selectedCategory == 'All' || m.category.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesRoom = _selectedRoom == 'All Rooms' || m.projectArea.toLowerCase().contains(_selectedRoom.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.specification.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesRoom && matchesSearch;
    }).toList();

    // Counts for status strip
    final totalCount = allMaterials.length;
    final approvedCount = allMaterials.where((m) => m.status == 'Approved').length;
    final orderedCount = allMaterials.where((m) => m.status == 'Ordered' || m.status == 'Dispatched').length;
    final deliveredCount = allMaterials.where((m) => m.status == 'Delivered').length;
    final pendingCount = allMaterials.where((m) => m.isApprovalRequired || m.status == 'Pending Approval').length;

    // Urgent pending item
    final urgentItem = allMaterials.firstWhere(
      (m) => m.isApprovalRequired || m.status == 'Pending Approval',
      orElse: () => allMaterials.first,
    );
    final hasUrgentItem = allMaterials.any((m) => m.isApprovalRequired || m.status == 'Pending Approval');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Procurement Status Strip
            _buildStatusStrip(
              total: totalCount,
              approved: approvedCount,
              ordered: orderedCount,
              delivered: deliveredCount,
              pending: pendingCount,
              isDark: isDark,
            ),

            // Urgent Approval Required Banner (if any item pending)
            if (hasUrgentItem) ...[
              const SizedBox(height: 16),
              _buildApprovalRequiredBanner(urgentItem, isDark),
            ],

            const SizedBox(height: 16),

            // Filter & Search Header
            _buildFilterBar(isDark),

            const SizedBox(height: 16),

            // Materials Grid
            if (filteredMaterials.isEmpty) ...[
              _buildEmptyState(isDark),
            ] else ...[
              _buildMaterialsGrid(filteredMaterials, isDark),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCustomMaterialRequestDialog(isDark),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
        label: Text(
          'Request Custom Material',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  // ===========================================================================
  // PROCUREMENT STATUS STRIP
  // ===========================================================================

  Widget _buildStatusStrip({
    required int total,
    required int approved,
    required int ordered,
    required int delivered,
    required int pending,
    required bool isDark,
  }) {
    final isDesktop = Breakpoints.isDesktop(context);

    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: _buildStatusMetric('TOTAL SPECIFIED', '$total Items', isDark ? AppColors.darkTextPrimary : Colors.grey.shade900, Icons.inventory_2_outlined, isDark)),
            _buildMetricDivider(isDark),
            Expanded(child: _buildStatusMetric('CLIENT APPROVED', '$approved Items', const Color(0xFF10B981), Icons.verified_outlined, isDark)),
            _buildMetricDivider(isDark),
            Expanded(child: _buildStatusMetric('ORDERED / DISPATCHED', '$ordered Items', const Color(0xFF3B82F6), Icons.local_shipping_outlined, isDark)),
            _buildMetricDivider(isDark),
            Expanded(child: _buildStatusMetric('DELIVERED TO SITE', '$delivered Items', const Color(0xFF8B5CF6), Icons.home_work_outlined, isDark)),
            _buildMetricDivider(isDark),
            Expanded(child: _buildStatusMetric('PENDING APPROVAL', '$pending Action Req.', const Color(0xFFF59E0B), Icons.pending_actions_rounded, isDark)),
          ],
        ),
      );
    }

    // Mobile / Tablet Wrap Layout
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatusMetric('TOTAL SPECIFIED', '$total Items', isDark ? AppColors.darkTextPrimary : Colors.grey.shade900, Icons.inventory_2_outlined, isDark)),
              Expanded(child: _buildStatusMetric('CLIENT APPROVED', '$approved Items', const Color(0xFF10B981), Icons.verified_outlined, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatusMetric('ORDERED / DISPATCHED', '$ordered Items', const Color(0xFF3B82F6), Icons.local_shipping_outlined, isDark)),
              Expanded(child: _buildStatusMetric('DELIVERED TO SITE', '$delivered Items', const Color(0xFF8B5CF6), Icons.home_work_outlined, isDark)),
            ],
          ),
          if (pending > 0) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
            const SizedBox(height: 12),
            _buildStatusMetric('PENDING APPROVAL', '$pending Action Required', const Color(0xFFF59E0B), Icons.pending_actions_rounded, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusMetric(String label, String count, Color color, IconData icon, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(bool isDark) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
    );
  }

  // ===========================================================================
  // APPROVAL REQUIRED BANNER
  // ===========================================================================

  Widget _buildApprovalRequiredBanner(CustomerMaterialItem item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.25) : const Color(0xFFFFFBEB),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.4) : const Color(0xFFFDE68A),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Action Required: Material Sign-Off',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: Text(
                        'Dispatch Locked',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.name} (${item.brand}) for ${item.projectArea} requires your sign-off before workshop dispatch.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _openDetailModal(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              elevation: 0,
            ),
            child: const Text('Review Spec'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FILTER & SEARCH BAR
  // ===========================================================================

  Widget _buildFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Room Dropdown Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search materials, brands (Hafele, Greenply...), or specs...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 12),
              // Room Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRoom,
                    dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                    ),
                    items: _rooms.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRoom = val);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Category Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                    ),
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MATERIALS GRID
  // ===========================================================================

  Widget _buildMaterialsGrid(List<CustomerMaterialItem> materials, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 768) {
      crossAxisCount = 2;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (crossAxisCount == 1) {
          return Column(
            children: materials.map((m) => _buildMaterialCard(m, isDark)).toList(),
          );
        }

        // Multiple columns via Wrap
        final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: materials.map((m) {
            return SizedBox(
              width: itemWidth,
              child: _buildMaterialCard(m, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMaterialCard(CustomerMaterialItem item, bool isDark) {
    final isPending = item.isApprovalRequired || item.status == 'Pending Approval';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isPending
              ? const Color(0xFFF59E0B)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: isPending ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Visual Header with Brand Badge
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [item.imageGradientStart, item.imageGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.xsVal),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_outlined, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        item.brand,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildProcurementStatusBadge(item.status),
              ],
            ),
          ),

          // Body Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room & Category Tag
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.projectArea,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${item.category}',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Name
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Specification Excerpt
                Text(
                  item.specification,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Quantity & Unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity: ${item.quantity.toInt()} ${item.unit}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                      ),
                    ),
                    if (item.expectedDelivery != null) ...[
                      Text(
                        'Delivery: ${item.expectedDelivery}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF38BDF8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
                const SizedBox(height: 12),

                // Actions
                if (isPending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ClientDataRepository.requestMaterialChange(
                              item.id,
                              'Finish/Brand Preference Change',
                              'Homeowner requested review of alternate brand or finish swatch.',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sample / Change requested. Design team notified.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFBBF24),
                            side: const BorderSide(color: Color(0xFFF59E0B)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedAppRadius.md,
                          ),
                          child: const Text('Change'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ClientDataRepository.approveMaterial(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Approved ${item.name} for site dispatch!'),
                                backgroundColor: const Color(0xFF047857),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedAppRadius.md,
                            elevation: 0,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _openDetailModal(item),
                        icon: const Icon(Icons.assignment_outlined, size: 14),
                        label: const Text('View Specs'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                          side: BorderSide(
                            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedAppRadius.md,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Warranty certificate for ${item.brand} downloaded.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 14, color: Color(0xFF38BDF8)),
                        label: Text(
                          'Spec Sheet',
                          style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF38BDF8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcurementStatusBadge(String status) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'approved':
        bg = const Color(0xFF10B981);
        fg = Colors.white;
        break;
      case 'ordered':
      case 'dispatched':
        bg = const Color(0xFF2563EB);
        fg = Colors.white;
        break;
      case 'delivered':
        bg = const Color(0xFF7C3AED);
        fg = Colors.white;
        break;
      case 'pending approval':
        bg = const Color(0xFFF59E0B);
        fg = Colors.white;
        break;
      default:
        bg = Colors.white;
        fg = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  void _openDetailModal(CustomerMaterialItem item) {
    CustomerMaterialDetailModal.show(
      context,
      material: item,
      onApproved: () {
        ClientDataRepository.approveMaterial(item.id);
        setState(() {});
      },
      onChangesRequested: () {
        ClientDataRepository.requestMaterialChange(
          item.id,
          'Client Requested Specification Adjustment',
          'Discussed in materials workspace.',
        );
        setState(() {});
      },
    );
  }

  // ===========================================================================
  // CUSTOM MATERIAL REQUEST DIALOG
  // ===========================================================================

  void _showCustomMaterialRequestDialog(bool isDark) {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final unitCtrl = TextEditingController(text: 'Piece');
    final notesCtrl = TextEditingController();
    String selectedArea = 'Modular Kitchen';
    String selectedCat = 'Wood & Joinery';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          title: Text(
            'Request Custom Material',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Provide details of the specific material, fixture, or finish you would like the HOMIO team to source and install.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Material / Product Name *',
                      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                      hintText: 'e.g. Matt Black Kitchen Sink Faucet',
                      hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: brandCtrl,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Preferred Brand (Optional)',
                      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                      hintText: 'e.g. Kohler, Grohe, Hafele',
                      hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyCtrl,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: unitCtrl,
                          style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                            hintText: 'sq.ft / Sets / Pcs',
                            hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Special Notes / Link / Color Ref',
                      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                ClientDataRepository.submitMaterialRequest(
                  name: nameCtrl.text.trim(),
                  category: selectedCat,
                  quantity: double.tryParse(qtyCtrl.text) ?? 1.0,
                  unit: unitCtrl.text.trim(),
                  projectArea: selectedArea,
                  preferredBrand: brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                  notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custom material request submitted to procurement lead.'),
                    backgroundColor: Color(0xFF047857),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Request'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark ? AppColors.darkTextMuted : Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            'No materials match your current filters.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your room or category selection above.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
