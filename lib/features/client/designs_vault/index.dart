import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum AssetType {
  render3D,
  cadBlueprint,
  electricalMep,
  moodboardBoq,
}

class DesignAsset {
  final String id;
  final String title;
  final String roomZone;
  final AssetType type;
  final String version;
  final String date;
  final String designer;
  final String resolution;
  final int revisionCount;
  final bool isApproved;
  final Color gradientStart;
  final Color gradientEnd;
  final String styleTag;
  final String description;

  const DesignAsset({
    required this.id,
    required this.title,
    required this.roomZone,
    required this.type,
    required this.version,
    required this.date,
    required this.designer,
    required this.resolution,
    required this.revisionCount,
    required this.isApproved,
    required this.gradientStart,
    required this.gradientEnd,
    required this.styleTag,
    required this.description,
  });
}

class CadDocument {
  final String id;
  final String fileName;
  final String fileFormat; // PDF, DWG, XLSX
  final String fileSize;
  final String category;
  final String uploadDate;
  final String uploader;
  final bool isApproved;
  final String description;

  const CadDocument({
    required this.id,
    required this.fileName,
    required this.fileFormat,
    required this.fileSize,
    required this.category,
    required this.uploadDate,
    required this.uploader,
    required this.isApproved,
    required this.description,
  });
}

// ============================================================================
// MAIN PAGE WIDGET: 3D DESIGNS & CAD VAULT
// ============================================================================

class ClientDesignsVaultPage extends StatefulWidget {
  const ClientDesignsVaultPage({super.key});

  @override
  State<ClientDesignsVaultPage> createState() => _ClientDesignsVaultPageState();
}

class _ClientDesignsVaultPageState extends State<ClientDesignsVaultPage> {
  String _selectedCategory = 'All Assets';
  String _selectedZone = 'All Zones';

  // 1. 3D Architectural Renders
  final List<DesignAsset> _assets = [
    const DesignAsset(
      id: 'asset_1',
      title: 'Grand Living Lounge & Double-Height Atrium',
      roomZone: 'Living & Foyer',
      type: AssetType.render3D,
      version: 'v2.1 (Approved)',
      date: 'Aug 18, 2026',
      designer: 'Pooja Hegde (Sr. Designer)',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 2,
      isApproved: true,
      gradientStart: Color(0xFF1E1B4B),
      gradientEnd: Color(0xFF312E81),
      styleTag: 'Italian Minimalist • Statuario & Fluted Walnut',
      description: 'Full layout visualization with floating TV credenza, Minotti sectional simulation, and magnetic track lighting geometry.',
    ),
    const DesignAsset(
      id: 'asset_2',
      title: 'Bespoke Island Modular Kitchen & Wet Pantry',
      roomZone: 'Modular Kitchen',
      type: AssetType.render3D,
      version: 'v3.0 (Under Client Review)',
      date: 'Aug 24, 2026',
      designer: 'Pooja Hegde (Sr. Designer)',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 3,
      isApproved: false,
      gradientStart: Color(0xFF064E3B),
      gradientEnd: Color(0xFF0F172A),
      styleTag: 'Matte Anthracite & Calacatta Gold Quartz',
      description: 'Integrated tall appliance column, Häfele pocket doors, under-cabinet lighting profiles, and breakfast counter overhang.',
    ),
    const DesignAsset(
      id: 'asset_3',
      title: 'Master Bedroom Suite & Acoustic Headboard',
      roomZone: 'Master Suite',
      type: AssetType.render3D,
      version: 'v2.0 (Approved)',
      date: 'Aug 12, 2026',
      designer: 'Pooja Hegde (Sr. Designer)',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 1,
      isApproved: true,
      gradientStart: Color(0xFF3B0764),
      gradientEnd: Color(0xFF180828),
      styleTag: 'Velvet Acoustic Panelling & Warm Brass Detailing',
      description: 'Plush boucle fabric headboard, integrated bedside wireless charging niches, and floor-to-ceiling sheer linen drape box.',
    ),
    const DesignAsset(
      id: 'asset_4',
      title: 'Walk-In Wardrobe Dual Island & Glass Vitrines',
      roomZone: 'Master Suite',
      type: AssetType.render3D,
      version: 'v1.5 (Approved)',
      date: 'Aug 15, 2026',
      designer: 'Pooja Hegde (Sr. Designer)',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 1,
      isApproved: true,
      gradientStart: Color(0xFF1F2937),
      gradientEnd: Color(0xFF111827),
      styleTag: 'Smoked Glass & Leather Lined Drawers',
      description: 'Sensor-activated 3000K vertical LED profiles, watch winder drawers, and custom tinted glass display cases.',
    ),
    const DesignAsset(
      id: 'asset_5',
      title: 'Sky Deck Balcony Lounge & Green Living Wall',
      roomZone: 'Balcony Deck',
      type: AssetType.render3D,
      version: 'v2.0 (Approved)',
      date: 'Aug 10, 2026',
      designer: 'Ar. Sameer Mehta',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 2,
      isApproved: true,
      gradientStart: Color(0xFF14532D),
      gradientEnd: Color(0xFF052E16),
      styleTag: 'Ipe Brazilian Hardwood & Automated Mist System',
      description: 'Weatherproof outdoor modular lounge, integrated drip-irrigation vertical garden, and architectural uplighting.',
    ),
    const DesignAsset(
      id: 'asset_6',
      title: 'Dining Pavilion & Minimalist Chandelier Vista',
      roomZone: 'Living & Foyer',
      type: AssetType.render3D,
      version: 'v1.0 (Approved)',
      date: 'Aug 08, 2026',
      designer: 'Pooja Hegde (Sr. Designer)',
      resolution: '4K UHD (3840x2160)',
      revisionCount: 0,
      isApproved: true,
      gradientStart: Color(0xFF431407),
      gradientEnd: Color(0xFF1C0A00),
      styleTag: '10-Seater Monolithic Quartz Slab Table',
      description: 'Custom acoustic ceiling baffle array, Bocci 28-series suspended crystal globes, and fluted marble service bar.',
    ),
  ];

  // 2. CAD Working Drawings & Technical Blueprints (from docs/requirmenet.md: DRIVE LINK - FILES FOLDER)
  final List<CadDocument> _cadDocuments = [
    const CadDocument(
      id: 'cad_1',
      fileName: 'Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg',
      fileFormat: 'DWG',
      fileSize: '14.2 MB',
      category: 'Architectural Working Plan',
      uploadDate: 'Aug 04, 2026',
      uploader: 'Ar. Sameer Mehta (Project Director)',
      isApproved: true,
      description: 'Comprehensive 1:50 scaled CAD plan showing internal masonry, column coordinates, and window schedule.',
    ),
    const CadDocument(
      id: 'cad_2',
      fileName: 'Modular_Kitchen_Lower_Carcase_Detailed_Elevations_Rev3.pdf',
      fileFormat: 'PDF',
      fileSize: '8.6 MB',
      category: 'Carpentry & Joinery',
      uploadDate: 'Aug 26, 2026',
      uploader: 'Pooja Hegde (Sr. Designer)',
      isApproved: true,
      description: 'Häfele hardware drilling templates, carcase depths, counter tolerances, and chimney exhaust routing.',
    ),
    const CadDocument(
      id: 'cad_3',
      fileName: 'Concealed_Conduit_Lighting_HVAC_Reflected_Ceiling_Plan.pdf',
      fileFormat: 'PDF',
      fileSize: '11.0 MB',
      category: 'MEP & Ceiling',
      uploadDate: 'Aug 01, 2026',
      uploader: 'Vikram Malhotra (Project Manager)',
      isApproved: true,
      description: 'Dual-circuit cove layout, VRV cassette coordinates, magnetic track driver locations, and switchboard heights.',
    ),
    const CadDocument(
      id: 'cad_4',
      fileName: 'Master_Suite_Wardrobe_Internal_Partition_Joinery_Details.dwg',
      fileFormat: 'DWG',
      fileSize: '18.4 MB',
      category: 'Carpentry & Joinery',
      uploadDate: 'Aug 14, 2026',
      uploader: 'Pooja Hegde (Sr. Designer)',
      isApproved: true,
      description: '32mm aluminum frame profiles, smoked glass gasket tolerances, and hidden shoe drawer elevations.',
    ),
    const CadDocument(
      id: 'cad_5',
      fileName: 'Turnkey_Bill_Of_Quantities_Material_Specification_Schedule.xlsx',
      fileFormat: 'XLSX',
      fileSize: '2.4 MB',
      category: 'BOQ & Specifications',
      uploadDate: 'Jul 28, 2026',
      uploader: 'Homio Commercial Desk',
      isApproved: true,
      description: 'Comprehensive itemized hardware brands, veneer codes (Italian Walnut #WN-402), and paint sheen schedules.',
    ),
    const CadDocument(
      id: 'cad_6',
      fileName: 'Plumbing_Sanitaryware_Pressure_Testing_Schematic.pdf',
      fileFormat: 'PDF',
      fileSize: '6.8 MB',
      category: 'MEP & Plumbing',
      uploadDate: 'Jul 22, 2026',
      uploader: 'Vikram Malhotra (Project Manager)',
      isApproved: true,
      description: 'Grohe concealed diverter rough-in measurements, acoustic drainage pipes, and pressure rating stamps.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    final filteredAssets = _getFilteredAssets();
    final filteredDocs = _getFilteredDocs();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Executive Design Vault Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Metrics Strip
                _buildMetricStrip(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Category Filter Tabs
                _buildCategoryFilterTabs(context, isDark, isMobile),

                const SizedBox(height: 12),

                // 4. Room Zone Sub-Filter
                _buildZoneFilterTabs(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 5. 3D Renders Gallery Grid
                if (_selectedCategory == 'All Assets' || _selectedCategory == '3D Renders') ...[
                  _buildSectionTitle(
                    context,
                    title: 'Photorealistic 3D Visualizer Gallery',
                    subtitle: 'High-definition architectural views with daylight & evening simulation',
                    badge: '${filteredAssets.length} Renders',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  if (filteredAssets.isEmpty)
                    _buildEmptyState(context, isDark, 'No 3D Renders in this zone filter.')
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isTwoCol = constraints.maxWidth > 700;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: filteredAssets.map((asset) {
                            final cardWidth = isTwoCol ? (constraints.maxWidth - 16) / 2 : double.infinity;
                            return SizedBox(
                              width: cardWidth,
                              child: _buildRenderCard(context, asset, isDark, isMobile),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  const SizedBox(height: 28),
                ],

                // 6. CAD Blueprints & Working Drawings Vault
                if (_selectedCategory == 'All Assets' ||
                    _selectedCategory == 'CAD Blueprints' ||
                    _selectedCategory == 'MEP & Electrical' ||
                    _selectedCategory == 'Moodboards & BOQ') ...[
                  _buildSectionTitle(
                    context,
                    title: 'Approved CAD Drawings & Technical Blueprint Vault',
                    subtitle: 'Authoritative working drawings, elevations, MEP schematics & contract BOQ schedules',
                    badge: '${filteredDocs.length} Documents',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  if (filteredDocs.isEmpty)
                    _buildEmptyState(context, isDark, 'No CAD drawings in this category.')
                  else
                    ...filteredDocs.map((doc) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildCadDocumentTile(context, doc, isDark, isMobile),
                        )),
                  const SizedBox(height: 20),
                ],

                // 7. Security & Cloud Vault Disclaimer
                _buildVaultSecurityBanner(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DesignAsset> _getFilteredAssets() {
    return _assets.where((a) {
      final matchesZone = _selectedZone == 'All Zones' || a.roomZone == _selectedZone;
      return matchesZone;
    }).toList();
  }

  List<CadDocument> _getFilteredDocs() {
    return _cadDocuments.where((doc) {
      if (_selectedCategory == 'CAD Blueprints') {
        return doc.fileFormat == 'DWG' || doc.category.contains('Architectural') || doc.category.contains('Carpentry');
      }
      if (_selectedCategory == 'MEP & Electrical') {
        return doc.category.contains('MEP');
      }
      if (_selectedCategory == 'Moodboards & BOQ') {
        return doc.category.contains('BOQ');
      }
      return true;
    }).toList();
  }

  // ==========================================================================
  // 1. EXECUTIVE DESIGN VAULT HEADER
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18.0 : 24.0),
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
          // Project and status badges
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_work_outlined, size: 13, color: Color(0xFF6366F1)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Skyline Villa Penthouse 402, Worli • 4 BHK Luxury',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '11 Approved Blueprints • Cloud Synced',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title & Description
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
                    '3D Designs & CAD Vault',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Photorealistic 3D renders, approved CAD working drawings, material moodboards & blueprint vault.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
  Widget _buildMetricStrip(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;

        final cards = [
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.photo_library_outlined,
            iconColor: const Color(0xFF6366F1),
            title: 'Design Assets',
            value: '${_assets.length + _cadDocuments.length} Files',
            subtitle: '6 Renders + 6 Technical CADs',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Approved Blueprints',
            value: '11 Approved',
            subtitle: 'Signed for site execution',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.edit_note_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Active Revision',
            value: '1 Under Review',
            subtitle: 'Modular Kitchen (Rev 3)',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.published_with_changes_rounded,
            iconColor: const Color(0xFF0EA5E9),
            title: 'Contract Allowance',
            value: '2 of 3 Used',
            subtitle: '1 Free revision remaining',
          ),
        ];

        if (isNarrow) {
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
      },
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
              fontSize: 17,
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
  // 3. CATEGORY & ZONE FILTER TABS
  // ==========================================================================
  Widget _buildCategoryFilterTabs(BuildContext context, bool isDark, bool isMobile) {
    final categories = [
      'All Assets',
      '3D Renders',
      'CAD Blueprints',
      'MEP & Electrical',
      'Moodboards & BOQ',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
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
      'All Zones',
      'Living & Foyer',
      'Modular Kitchen',
      'Master Suite',
      'Balcony Deck',
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
              onSelected: (val) {
                setState(() {
                  _selectedZone = zone;
                });
              },
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              selectedColor: const Color(0xFF10B981),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
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
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6366F1),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 4. 3D RENDER CARD
  // ==========================================================================
  Widget _buildRenderCard(
    BuildContext context,
    DesignAsset asset,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Simulated 3D Render Image Viewport
          InkWell(
            onTap: () => _showRenderLightbox(context, asset, isDark),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [asset.gradientStart, asset.gradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Room Visual Scene Elements Mock
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.view_in_ar_rounded,
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Interactive 3D Viewport',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Top Zone & Version Tags
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  asset.roomZone,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: asset.isApproved
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                asset.version,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Click to Expand Prompt
                      Positioned(
                        bottom: 8,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.fullscreen_rounded, size: 13, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'Tap to Expand Lightbox',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: Colors.white70,
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
            ),
          ),

          // Render Details
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  asset.styleTag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  asset.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Author, Resolution and Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${asset.designer} • ${asset.date}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => _showRevisionDialog(context, asset, isDark),
                      child: Text(
                        'Request Revision',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
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
  // 5. CAD DOCUMENT TILE
  // ==========================================================================
  Widget _buildCadDocumentTile(
    BuildContext context,
    CadDocument doc,
    bool isDark,
    bool isMobile,
  ) {
    Color formatColor = const Color(0xFF6366F1);
    if (doc.fileFormat == 'PDF') formatColor = const Color(0xFFEF4444);
    if (doc.fileFormat == 'DWG') formatColor = const Color(0xFF0EA5E9);
    if (doc.fileFormat == 'XLSX') formatColor = const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Format Icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: formatColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              doc.fileFormat,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: formatColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.fileName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${doc.category} • ${doc.fileSize} • Uploaded by ${doc.uploader}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showDocViewerModal(context, doc, isDark),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                tooltip: 'Preview Document',
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Downloading ${doc.fileName}...'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF10B981)),
                tooltip: 'Download File',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 6. VAULT SECURITY BANNER
  // ==========================================================================
  Widget _buildVaultSecurityBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_clock_outlined, size: 20, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Encrypted Blueprint Vault Policy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'As per project agreement, technical CAD files and structural plans in this vault are version-locked. File deletion requires administrator authorization to preserve contractor accountability and warranty validity.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, String message) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // MODALS & DIALOGS
  // ==========================================================================

  void _showRenderLightbox(BuildContext context, DesignAsset asset, bool isDark) {
    bool isDaylightMode = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${asset.roomZone} • ${asset.resolution} • ${asset.version}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),

                    // Lightbox Viewport
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDaylightMode
                                ? [asset.gradientStart, asset.gradientEnd]
                                : [const Color(0xFF0F172A), const Color(0xFF1E1B4B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isDaylightMode ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                                    size: 48,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isDaylightMode
                                        ? '4000K Natural Daylight Simulation'
                                        : '3000K Warm Evening Atmosphere Simulation',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Lighting Toggle Pill
                            Positioned(
                              top: 12,
                              right: 12,
                              child: InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    isDaylightMode = !isDaylightMode;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isDaylightMode ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                                        size: 13,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        isDaylightMode ? 'Daylight Mode' : 'Warm Night Mode',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Lightbox Footer Actions
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          Text(
                            asset.styleTag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  _showRevisionDialog(context, asset, isDark);
                                },
                                icon: const Icon(Icons.rate_review_outlined, size: 14),
                                label: Text(
                                  'Request Revision',
                                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('High-res 4K render downloaded!'),
                                      backgroundColor: Color(0xFF10B981),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white),
                                label: Text(
                                  'Download 4K View',
                                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
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

  void _showRevisionDialog(BuildContext context, DesignAsset? asset, bool isDark) {
    final noteController = TextEditingController();
    String selectedCat = 'Color & Material Finish';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.rate_review_outlined, color: Color(0xFF6366F1), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Request 3D Design Revision',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  asset != null ? asset.title : 'General Room Revision',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Revision Focus Area',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          'Color & Material Finish',
                          'Cabinet / Furniture Layout',
                          'Lighting Profiles',
                          'Texture & Flooring Swatch',
                        ].map((cat) {
                          final isSelected = selectedCat == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) {
                              setDialogState(() {
                                selectedCat = cat;
                              });
                            },
                            labelStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            selectedColor: const Color(0xFF6366F1),
                            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Specific Revision Notes',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Describe adjustments (e.g., change lower kitchen laminate to smoked oak)...',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Contract Allowance: 1 complimentary revision cycle remaining in Tier-1 package.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Revision request submitted to Sr. Designer Pooja Hegde!'),
                                  backgroundColor: Color(0xFF6366F1),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Submit Revision',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDocViewerModal(BuildContext context, CadDocument doc, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.architecture_rounded, color: Color(0xFF0EA5E9), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.category,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              doc.fileName,
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Text(
                          'File Format: ${doc.fileFormat} • File Size: ${doc.fileSize}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Authorized By: ${doc.uploader} on ${doc.uploadDate}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${doc.fileName} downloaded successfully!'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white),
                        label: Text(
                          'Download ${doc.fileFormat} Blueprint',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
