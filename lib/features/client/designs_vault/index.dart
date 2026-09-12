import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

// ============================================================================
// MAIN PAGE WIDGET: 3D DESIGNS & CAD VAULT
// ============================================================================

class ClientDesignsVaultPage extends StatefulWidget {
  const ClientDesignsVaultPage({super.key});

  @override
  State<ClientDesignsVaultPage> createState() => _ClientDesignsVaultPageState();
}

class _ClientDesignsVaultPageState extends State<ClientDesignsVaultPage> {
  String _selectedCategory = 'All Files';
  String _selectedZone = 'All Rooms';
  String _searchQuery = '';
  String _sortBy = 'Newest First';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onRepoStateChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onRepoStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRepoStateChanged() {
    if (mounted) setState(() {});
  }

  List<CustomerDesignFile> _getFilteredFiles() {
    var files = List<CustomerDesignFile>.from(ClientDataRepository.designFiles);

    // Category filter
    if (_selectedCategory == '★ Approved Designs') {
      files = files.where((f) => f.isApproved).toList();
    } else if (_selectedCategory == '3D Renders') {
      files = files.where((f) => f.category == '3D Designs' || f.category == 'Renders').toList();
    } else if (_selectedCategory != 'All Files') {
      files = files.where((f) => f.category.toLowerCase().contains(_selectedCategory.toLowerCase())).toList();
    }

    // Room Zone filter
    if (_selectedZone != 'All Rooms') {
      files = files.where((f) => f.roomZone.toLowerCase().contains(_selectedZone.toLowerCase())).toList();
    }

    // Search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      files = files.where((f) {
        final matchTitle = f.title.toLowerCase().contains(q);
        final matchZone = f.roomZone.toLowerCase().contains(q);
        final matchCategory = f.category.toLowerCase().contains(q);
        final matchUploader = f.uploader.toLowerCase().contains(q);
        final matchSpecs = f.specifications.any((s) => s.toLowerCase().contains(q));
        return matchTitle || matchZone || matchCategory || matchUploader || matchSpecs;
      }).toList();
    }

    // Sorting
    switch (_sortBy) {
      case 'Oldest First':
        files.sort((a, b) => a.uploadedDate.compareTo(b.uploadedDate));
        break;
      case 'Name (A-Z)':
        files.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Status':
        files.sort((a, b) => a.status.compareTo(b.status));
        break;
      case 'Newest First':
      default:
        // Already newest first in mock data
        break;
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;
    final isTablet = screenWidth >= Breakpoints.compact && screenWidth < Breakpoints.medium;

    final filteredFiles = _getFilteredFiles();
    final renderFiles = filteredFiles.where((f) => f.category == '3D Designs' || f.category == 'Renders').toList();
    final cadFiles = filteredFiles.where((f) => f.category != '3D Designs' && f.category != 'Renders').toList();

    final pendingApprovals = ClientDataRepository.approvalPackages.where((a) => a.isPending).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14.0 : 28.0,
          vertical: isMobile ? 14.0 : 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Unified Customer Project Context Header
                const CustomerProjectContextBar(activeTab: 'designs'),

                const SizedBox(height: 18),

                // 2. Executive Vault Header Card
                _buildVaultHeader(context, isDark, isMobile),

                const SizedBox(height: 16),

                // 3. Vault Metrics Strip
                _buildMetricsStrip(context, isDark, isMobile),

                const SizedBox(height: 16),

                // 4. Action Required Floating Banner (if pending approvals exist)
                if (pendingApprovals.isNotEmpty) ...[
                  _buildPendingNoticeBanner(context, pendingApprovals, isDark, isMobile),
                  const SizedBox(height: 16),
                ],

                // 5. Category Tabs
                _buildCategoryFilterTabs(context, isDark, isMobile),

                const SizedBox(height: 12),

                // 6. Room Zone Filter Chips
                _buildZoneFilterTabs(context, isDark, isMobile),

                const SizedBox(height: 14),

                // 7. Search & Sorting Toolbar
                _buildSearchAndSortToolbar(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 8. 3D Renders Visual Gallery
                if (_selectedCategory == 'All Files' ||
                    _selectedCategory == '★ Approved Designs' ||
                    _selectedCategory == '3D Renders') ...[
                  if (renderFiles.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      title: 'Photorealistic 3D Visualizer Gallery',
                      subtitle: 'Ultra-high-definition architectural concepts with simulated ambient lighting & material finishes',
                      badge: '${renderFiles.length} Renders',
                      badgeColor: const Color(0xFF6366F1),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildRenderGrid(context, renderFiles, isDark, isMobile, isTablet),
                    const SizedBox(height: 28),
                  ] else if (_selectedCategory == '3D Renders') ...[
                    CustomerEmptyState(
                      icon: Icons.view_in_ar_rounded,
                      title: 'No 3D Renders Match Your Filter',
                      message: 'Try selecting a different room zone or clearing your search term.',
                      actionLabel: 'Reset Filters',
                      onAction: () => setState(() {
                        _selectedCategory = 'All Files';
                        _selectedZone = 'All Rooms';
                        _searchController.clear();
                        _searchQuery = '';
                      }),
                    ),
                    const SizedBox(height: 28),
                  ],
                ],

                // 9. CAD Drawings & Technical Blueprint Vault
                if (_selectedCategory == 'All Files' ||
                    _selectedCategory == '★ Approved Designs' ||
                    _selectedCategory == 'CAD Drawings' ||
                    _selectedCategory == 'Floor Plans' ||
                    _selectedCategory == 'Working Drawings' ||
                    _selectedCategory == 'Material Specifications') ...[
                  if (cadFiles.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      title: 'Certified CAD Working Drawings & Specifications',
                      subtitle: 'Accurate architectural blueprints, joinery templates, MEP routes & material dossiers for site execution',
                      badge: '${cadFiles.length} Documents',
                      badgeColor: const Color(0xFF0EA5E9),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    ...cadFiles.map((doc) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildCadDocumentCard(context, doc, isDark, isMobile),
                        )),
                    const SizedBox(height: 24),
                  ] else if (_selectedCategory != '3D Renders') ...[
                    CustomerEmptyState(
                      icon: Icons.architecture_rounded,
                      title: 'No Blueprints Found',
                      message: 'No technical documents match your current filter selection.',
                      actionLabel: 'Reset Filters',
                      onAction: () => setState(() {
                        _selectedCategory = 'All Files';
                        _selectedZone = 'All Rooms';
                        _searchController.clear();
                        _searchQuery = '';
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],

                // 10. Vault Security & Cloud Authenticity Guarantee
                _buildVaultSecurityBanner(context, isDark, isMobile),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. VAULT HEADER CARD
  // ==========================================================================
  Widget _buildVaultHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 22.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_special_rounded, size: 13, color: Color(0xFF6366F1)),
                    const SizedBox(width: 5),
                    Text(
                      '3BHK Residence • Vault #HOM-VLT-0084',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_done_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Text(
                      'Direct Site Sync • 28 Approved Blueprints',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title & CTA
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Designs & CAD Vault',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 21 : 25,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore photorealistic 3D renders, certified CAD blueprints, and material specifications for your home.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              ElevatedButton.icon(
                onPressed: () => _showRevisionDialog(context, null, isDark),
                icon: const Icon(Icons.rate_review_outlined, size: 15, color: Colors.white),
                label: Text(
                  'Request Design Revision',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. METRICS STRIP
  // ==========================================================================
  Widget _buildMetricsStrip(BuildContext context, bool isDark, bool isMobile) {
    final totalFiles = ClientDataRepository.designFiles.length + 34; // Total repository volume
    final approvedCount = ClientDataRepository.designFiles.where((f) => f.isApproved).length + 22;
    final pendingCount = ClientDataRepository.approvalPackages.where((a) => a.isPending).length;

    final cards = [
      _buildMetricCard(
        context,
        isDark: isDark,
        icon: Icons.photo_library_rounded,
        iconColor: const Color(0xFF6366F1),
        title: 'Total Vault Files',
        value: '$totalFiles Files',
        subtitle: '8 Active + 34 Archived',
      ),
      _buildMetricCard(
        context,
        isDark: isDark,
        icon: Icons.verified_rounded,
        iconColor: const Color(0xFF10B981),
        title: 'Approved Designs',
        value: '$approvedCount Certified',
        subtitle: 'Locked for site fabrication',
      ),
      _buildMetricCard(
        context,
        isDark: isDark,
        icon: Icons.pending_actions_rounded,
        iconColor: const Color(0xFFF59E0B),
        title: 'Action Required',
        value: '$pendingCount Pending Sign-Off',
        subtitle: pendingCount > 0 ? 'Living Room 3D & False Ceiling' : 'All designs up to date',
      ),
      _buildMetricCard(
        context,
        isDark: isDark,
        icon: Icons.published_with_changes_rounded,
        iconColor: const Color(0xFF0EA5E9),
        title: 'Revision Allowance',
        value: '2 of 3 Used',
        subtitle: '1 Free revision remaining',
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 12),
        Expanded(child: cards[1]),
        const SizedBox(width: 12),
        Expanded(child: cards[2]),
        const SizedBox(width: 12),
        Expanded(child: cards[3]),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
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
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. PENDING ACTION NOTICE BANNER
  // ==========================================================================
  Widget _buildPendingNoticeBanner(
    BuildContext context,
    List<CustomerApprovalItem> pendingList,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
        borderRadius: AppRadius.lg,
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rate_review_rounded, size: 20, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pendingList.length} Design${pendingList.length > 1 ? 's' : ''} Awaiting Your Digital Sign-Off',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your review is required to lock materials and authorize workshop joinery cutting.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF4C1D95),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              elevation: 0,
            ),
            onPressed: () {
              if (pendingList.isNotEmpty) {
                DesignApprovalReviewModal.show(
                  context,
                  approval: pendingList.first,
                  onApproved: () => setState(() {}),
                  onChangesRequested: () => setState(() {}),
                );
              }
            },
            child: Text(
              'Review Now',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. CATEGORY & ZONE FILTER TABS
  // ==========================================================================
  Widget _buildCategoryFilterTabs(BuildContext context, bool isDark, bool isMobile) {
    final categories = [
      'All Files',
      '★ Approved Designs',
      '3D Renders',
      'CAD Drawings',
      'Floor Plans',
      'Working Drawings',
      'Material Specifications',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          final isStar = cat.startsWith('★');

          Color activeColor = const Color(0xFF6366F1);
          if (isStar) activeColor = const Color(0xFF10B981);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? activeColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isStar
                            ? const Color(0xFF10B981)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildZoneFilterTabs(BuildContext context, bool isDark, bool isMobile) {
    final zones = [
      'All Rooms',
      'Living Room',
      'Modular Kitchen',
      'Master Bedroom',
      'Balcony',
      'Full Residence',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: zones.map((zone) {
          final isSelected = _selectedZone == zone;
          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ChoiceChip(
              label: Text(zone),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedZone = zone),
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              selectedColor: const Color(0xFF0EA5E9),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 5. SEARCH & SORTING TOOLBAR
  // ==========================================================================
  Widget _buildSearchAndSortToolbar(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final searchBox = Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
            decoration: InputDecoration(
              hintText: 'Search blueprints, rooms, materials, specs...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        );

        final sortBox = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              icon: const Icon(Icons.sort_rounded, size: 16),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              items: ['Newest First', 'Oldest First', 'Name (A-Z)', 'Status']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
            ),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchBox,
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Sort by: ', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                  const SizedBox(width: 6),
                  sortBox,
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: searchBox),
            const SizedBox(width: 12),
            sortBox,
          ],
        );
      },
    );
  }

  // ==========================================================================
  // 6. SECTION HEADER WIDGET
  // ==========================================================================
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: AppRadius.full,
            border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
          ),
          child: Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 7. 3D RENDERS GALLERY GRID
  // ==========================================================================
  Widget _buildRenderGrid(
    BuildContext context,
    List<CustomerDesignFile> renders,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        }

        final spacing = 16.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: renders.map((render) {
            return SizedBox(
              width: itemWidth,
              child: _buildRenderCard(context, render, isDark, isMobile),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRenderCard(
    BuildContext context,
    CustomerDesignFile render,
    bool isDark,
    bool isMobile,
  ) {
    final linkedApproval = render.linkedApprovalId != null
        ? ClientDataRepository.approvalPackages.firstWhere(
            (a) => a.id == render.linkedApprovalId,
            orElse: () => ClientDataRepository.approvalPackages.first,
          )
        : null;

    final isPendingReview = render.status == 'Pending Approval';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isPendingReview
              ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isPendingReview ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPendingReview
                ? const Color(0xFFF59E0B).withValues(alpha: 0.08)
                : (isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03)),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Visual Canvas Header
          GestureDetector(
            onTap: () => _showDesignDetailModal(context, render, isDark),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    render.previewGradientStart ?? const Color(0xFF1E1B4B),
                    render.previewGradientEnd ?? const Color(0xFF312E81),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Center Icon simulation
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.view_in_ar_rounded, size: 48, color: Colors.white60),
                        const SizedBox(height: 8),
                        Text(
                          'Photorealistic 3D Concept',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Left: Room Tag & Version Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            render.roomZone,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            render.version,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Right: Status Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CustomerStatusBadge(status: render.status, isSmall: true),
                  ),

                  // Bottom Overlay: Tap to inspect
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.zoom_in_rounded, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Inspect 3D',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  render.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Specifications bullets
                if (render.specifications.isNotEmpty)
                  Text(
                    render.specifications.first,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Meta footer: Designer & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      render.uploader,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                    Text(
                      render.updatedDate,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          shape: RoundedAppRadius.md,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () => _showDesignDetailModal(context, render, isDark),
                        icon: const Icon(Icons.info_outline_rounded, size: 14),
                        label: Text(
                          'Details',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 11.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    if (isPendingReview && linkedApproval != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            shape: RoundedAppRadius.md,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 0,
                          ),
                          onPressed: () {
                            DesignApprovalReviewModal.show(
                              context,
                              approval: linkedApproval,
                              onApproved: () => setState(() {}),
                              onChangesRequested: () => setState(() {}),
                            );
                          },
                          icon: const Icon(Icons.verified_rounded, size: 14),
                          label: Text(
                            'Sign-Off',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 11.5),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedAppRadius.md,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 0,
                          ),
                          onPressed: () => _downloadFile(context, render.title, render.fileFormat),
                          icon: const Icon(Icons.file_download_outlined, size: 14),
                          label: Text(
                            'Download',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 11.5),
                          ),
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

  // ==========================================================================
  // 8. CAD & TECHNICAL WORKING DRAWINGS CARDS
  // ==========================================================================
  Widget _buildCadDocumentCard(
    BuildContext context,
    CustomerDesignFile doc,
    bool isDark,
    bool isMobile,
  ) {
    Color formatBg;
    Color formatFg;
    IconData formatIcon;

    switch (doc.fileFormat.toUpperCase()) {
      case 'DWG':
        formatBg = const Color(0xFF8B5CF6).withValues(alpha: 0.12);
        formatFg = const Color(0xFF8B5CF6);
        formatIcon = Icons.architecture_rounded;
        break;
      case 'PDF':
        formatBg = const Color(0xFFEF4444).withValues(alpha: 0.12);
        formatFg = const Color(0xFFEF4444);
        formatIcon = Icons.picture_as_pdf_rounded;
        break;
      case 'XLSX':
        formatBg = const Color(0xFF10B981).withValues(alpha: 0.12);
        formatFg = const Color(0xFF10B981);
        formatIcon = Icons.table_chart_rounded;
        break;
      default:
        formatBg = const Color(0xFF6366F1).withValues(alpha: 0.12);
        formatFg = const Color(0xFF6366F1);
        formatIcon = Icons.insert_drive_file_rounded;
    }

    final isPendingReview = doc.status == 'Pending Approval';

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isPendingReview
              ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Format Icon Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: formatBg,
                  borderRadius: AppRadius.md,
                ),
                child: Center(
                  child: Icon(formatIcon, size: 22, color: formatFg),
                ),
              ),
              const SizedBox(width: 12),

              // Title & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            doc.version,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${doc.category} • ${doc.roomZone}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Size: ${doc.fileSize}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          'Uploaded: ${doc.uploadedDate}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Status Badge
              CustomerStatusBadge(status: doc.status, isSmall: true),
            ],
          ),

          // Specifications teaser
          if (doc.specifications.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 13, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      doc.specifications.first,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Footer actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By ${doc.uploader}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () => _showDesignDetailModal(context, doc, isDark),
                    icon: const Icon(Icons.visibility_outlined, size: 14),
                    label: Text(
                      'Inspect Specs & Comments (${doc.comments.length})',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedAppRadius.md,
                      elevation: 0,
                    ),
                    onPressed: () => _downloadFile(context, doc.title, doc.fileFormat),
                    icon: const Icon(Icons.download_rounded, size: 14),
                    label: Text(
                      'Download ${doc.fileFormat}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 9. INTERACTIVE FULLSCREEN DESIGN DETAIL & VERSION MODAL
  // ==========================================================================
  void _showDesignDetailModal(
    BuildContext context,
    CustomerDesignFile file,
    bool isDark,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        String selectedVersion = file.version;
        final commentCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (context, setModalState) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final isDesktop = screenWidth >= 768;

            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              insetPadding: EdgeInsets.all(isDesktop ? 24 : 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960, maxHeight: 840),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Modal Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              selectedVersion,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  '${file.roomZone} • ${file.category} • Uploaded by ${file.uploader}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomerStatusBadge(status: file.status, isSmall: true),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),

                    // Scrollable Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Interactive Preview Canvas with Pinch-to-Zoom
                            Container(
                              height: isDesktop ? 320 : 220,
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.lg,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    file.previewGradientStart ?? const Color(0xFF1E1B4B),
                                    file.previewGradientEnd ?? const Color(0xFF4338CA),
                                  ],
                                ),
                                border: Border.all(color: const Color(0xFF3730A3)),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          file.category == '3D Designs' || file.category == 'Renders'
                                              ? Icons.view_in_ar_rounded
                                              : Icons.architecture_rounded,
                                          size: 58,
                                          color: Colors.white60,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${file.title} ($selectedVersion)',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Certified Scaled 1:50 Construction Geometry & Shader Textures',
                                          style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Watermark
                                  Positioned(
                                    bottom: 12,
                                    left: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'HOMIO QA VERIFIED • DHANBAD RESIDENCE',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 2. Version Comparison Switcher
                            Text(
                              'Revision Timeline & Versions',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: file.versions.map((ver) {
                                  final isVerSelected = selectedVersion == ver;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(
                                        '$ver ${ver == file.version ? "(Current)" : "(Archived)"}',
                                      ),
                                      selected: isVerSelected,
                                      onSelected: (val) {
                                        setModalState(() => selectedVersion = ver);
                                      },
                                      labelStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontWeight: isVerSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isVerSelected
                                            ? Colors.white
                                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                      ),
                                      selectedColor: const Color(0xFF6366F1),
                                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 3. Technical Specifications
                            Text(
                              'Technical Specifications & Materials',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                                borderRadius: AppRadius.md,
                                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: file.specifications.map((spec) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            spec,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.5,
                                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 4. Discussion & Comments Thread
                            Text(
                              'Designer & Client Discussion (${file.comments.length})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 10),

                            if (file.comments.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  borderRadius: AppRadius.md,
                                ),
                                child: Text(
                                  'No comments posted yet. Ask designer Priya Mehta a question below.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                  ),
                                ),
                              )
                            else
                              ...file.comments.map((comm) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: comm.isClient
                                        ? const Color(0xFF6366F1).withValues(alpha: 0.08)
                                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                                    borderRadius: AppRadius.md,
                                    border: Border.all(
                                      color: comm.isClient
                                          ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${comm.author} (${comm.authorRole})',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: comm.isClient
                                                  ? const Color(0xFF6366F1)
                                                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                            ),
                                          ),
                                          Text(
                                            comm.timestamp,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comm.text,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                            const SizedBox(height: 12),

                            // Post Comment Input Field
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: commentCtrl,
                                    decoration: InputDecoration(
                                      hintText: 'Post a question or feedback for the designer...',
                                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                                      filled: true,
                                      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                      border: OutlineInputBorder(borderRadius: AppRadius.md),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6366F1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedAppRadius.md,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  onPressed: () {
                                    if (commentCtrl.text.trim().isEmpty) return;
                                    ClientDataRepository.addDesignComment(file.id, commentCtrl.text.trim());
                                    commentCtrl.clear();
                                    setModalState(() {});
                                    setState(() {});
                                  },
                                  child: Text('Post', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),

                    // Modal Bottom Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6366F1),
                              side: const BorderSide(color: Color(0xFF6366F1)),
                              shape: RoundedAppRadius.md,
                            ),
                            onPressed: () => _downloadFile(context, file.title, file.fileFormat),
                            icon: const Icon(Icons.file_download_outlined, size: 16),
                            label: Text(
                              'Download High-Res (${file.fileSize})',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                            ),
                          ),
                          const Spacer(),
                          if (file.status == 'Pending Approval') ...[
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedAppRadius.md,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                ClientDataRepository.approveDesign(file.id);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF10B981),
                                    content: Text(
                                      'Success! "${file.title}" is approved and locked for site execution.',
                                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.verified_rounded, size: 16),
                              label: Text(
                                'Approve Design',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                              ),
                            ),
                          ] else
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                                shape: RoundedAppRadius.md,
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('Close', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 10. REVISION REQUEST DIALOG
  // ==========================================================================
  void _showRevisionDialog(BuildContext context, String? designId, bool isDark) {
    String selectedZone = 'Living & Foyer';
    final reasonCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              title: Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: Color(0xFF6366F1), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Request Design Revision',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: AppRadius.md,
                      ),
                      child: Text(
                        'You have 1 complimentary revision remaining under your Turnkey Interior agreement.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF6366F1)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text('Select Room / Zone', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedZone,
                          isExpanded: true,
                          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          items: ['Living & Foyer', 'Modular Kitchen', 'Master Suite', 'Balcony Deck', 'Full Residence']
                              .map((z) => DropdownMenuItem(value: z, child: Text(z, style: GoogleFonts.plusJakartaSans(fontSize: 12.5))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedZone = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text('Reason for Revision', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: reasonCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g., Change wood laminate shade, adjust shelf depth',
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: AppRadius.md),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text('Detailed Notes', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: commentsCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Please describe your preferences in detail...',
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: AppRadius.md),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedAppRadius.md,
                  ),
                  onPressed: () {
                    if (reasonCtrl.text.trim().isEmpty || commentsCtrl.text.trim().isEmpty) return;
                    Navigator.of(ctx).pop();

                    final targetId = designId ?? ClientDataRepository.designFiles.first.id;
                    ClientDataRepository.requestDesignChanges(
                      targetId,
                      reasonCtrl.text.trim(),
                      commentsCtrl.text.trim(),
                    );
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF6366F1),
                        content: Text(
                          'Revision submitted to Priya Mehta. Updated render turnaround is 24-48 hours.',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  },
                  child: Text('Submit Request', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 11. VAULT SECURITY & CLOUD GUARANTEE BANNER
  // ==========================================================================
  Widget _buildVaultSecurityBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security_rounded, size: 20, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOMIO Certified Cloud Vault & Real-Time Site Synchronization',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All CAD files and 3D renders in this vault are encrypted with 256-bit SSL and synchronized with your Site Supervisor\'s tablet in Dhanbad. Whenever you digitally approve a design, site craftsmen receive instant notification to build according to the authorized specifications.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 12. HELPER DOWNLOAD NOTIFICATION
  // ==========================================================================
  void _downloadFile(BuildContext context, String title, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0EA5E9),
        content: Row(
          children: [
            const Icon(Icons.file_download_done_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Downloading "$title" ($format)...',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
