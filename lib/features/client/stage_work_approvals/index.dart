import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum ApprovalStatus {
  pendingClientAction,
  approvedCertified,
  revisionRequested,
}

class StageApprovalPackage {
  final int stageNumber;
  final String title;
  final String subtitle;
  final String category;
  ApprovalStatus status;
  final String trancheAmount;
  final String dueDate;
  String? approvedDate;
  String? certificateId;
  final String supervisorName;
  final String supervisorRole;
  final int passedCheckpoints;
  final int totalCheckpoints;
  final List<String> inspectionHighlights;
  final List<String> evidenceImages;
  final String engineeringNote;

  StageApprovalPackage({
    required this.stageNumber,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.status,
    required this.trancheAmount,
    required this.dueDate,
    this.approvedDate,
    this.certificateId,
    required this.supervisorName,
    required this.supervisorRole,
    required this.passedCheckpoints,
    required this.totalCheckpoints,
    required this.inspectionHighlights,
    required this.evidenceImages,
    required this.engineeringNote,
  });

  bool get isPendingAction => status == ApprovalStatus.pendingClientAction;
  bool get isApproved => status == ApprovalStatus.approvedCertified;
  bool get isRevisionRequested => status == ApprovalStatus.revisionRequested;
}

// ============================================================================
// MAIN PAGE WIDGET: STAGE WORK APPROVALS
// ============================================================================

class ClientStageWorkApprovalsPage extends StatefulWidget {
  const ClientStageWorkApprovalsPage({super.key});

  @override
  State<ClientStageWorkApprovalsPage> createState() => _ClientStageWorkApprovalsPageState();
}

class _ClientStageWorkApprovalsPageState extends State<ClientStageWorkApprovalsPage> {
  String _selectedFilter = 'All Packages';
  final Set<int> _expandedStageChecklists = {};

  // Stage Approval Packages Data (conforming to docs/requirmenet.md: WORK APPROVAL REQUEST)
  late final List<StageApprovalPackage> _packages = [
    StageApprovalPackage(
      stageNumber: 5,
      title: 'Stage 5: Bespoke Joinery & Modular Kitchen Fabrication',
      subtitle: 'Lower carcase, Häfele tandem boxes & anti-scratch quartz installation',
      category: 'Carpentry & Joinery',
      status: ApprovalStatus.pendingClientAction,
      trancheAmount: '₹7,50,000',
      dueDate: 'Due Today (Sep 05)',
      supervisorName: 'Rajesh Verma',
      supervisorRole: 'Sr. Site Execution Supervisor',
      passedCheckpoints: 4,
      totalCheckpoints: 4,
      inspectionHighlights: [
        'HDHMR board moisture content verified at 8.2% (Standard < 10.5%)',
        'Blum soft-close runner laser alignment verified within ±0.5 mm tolerance',
        'Anti-stain quartz nano-sealant cured for 48 hours without seepage',
        'LED strip extrusion channel thermal load measured at 34°C max under full power',
      ],
      evidenceImages: ['Modular Lower Carcase', 'Häfele Tandem Box Fit', 'Quartz Counter Joint'],
      engineeringNote: 'All 4 technical criteria verified and stamped by internal QA. Client digital sign-off will release Stage 5 milestone payment and authorize Stage 6 surface priming commencement.',
    ),
    StageApprovalPackage(
      stageNumber: 4,
      title: 'Stage 4 Variation: Italian Statuario Polish Grade-A Upgrade',
      subtitle: 'Mirror diamond silicate polish enhancement on 1,450 sq.ft living lounge',
      category: 'Flooring Variation',
      status: ApprovalStatus.pendingClientAction,
      trancheAmount: '₹1,20,000',
      dueDate: 'Action Required',
      supervisorName: 'Ar. Sameer Mehta',
      supervisorRole: 'Project Director',
      passedCheckpoints: 3,
      totalCheckpoints: 3,
      inspectionHighlights: [
        '8-step diamond pad mechanical abrasion completed to 12,000 grit finish',
        'Reflectance gloss meter index read 96 GU (Grade-A Luxury standard)',
        'Zero open hairline cracks or loose epoxy grout detected under raking light',
      ],
      evidenceImages: ['Mirror Gloss Test', 'Marble Joint Levelling', 'Silicate Coating Stamp'],
      engineeringNote: 'Client requested variation during Aug 22 design review. High-luster silicate treatment completed with 5-year anti-etch warranty endorsement.',
    ),
    StageApprovalPackage(
      stageNumber: 4,
      title: 'Stage 4: Italian Marble Flooring & Wall Cladding',
      subtitle: 'Precision bookmatch layout & wet area epoxy grouting',
      category: 'Flooring & Cladding',
      status: ApprovalStatus.approvedCertified,
      trancheAmount: '₹8,00,000',
      dueDate: 'Completed Aug 28, 2026',
      approvedDate: 'Aug 28, 2026',
      certificateId: 'CRT-STG4-402-998',
      supervisorName: 'Rajesh Verma',
      supervisorRole: 'Sr. Site Execution Supervisor',
      passedCheckpoints: 9,
      totalCheckpoints: 9,
      inspectionHighlights: [
        'Statuario slab bookmatching verified against approved 3D visualizer renders',
        'Dry lay inspection approved by Client in presence of Ar. Mehta',
        'Sub-floor acoustic underlayment bonded with zero hollow sound spots',
      ],
      evidenceImages: ['Full Foyer Bookmatch', 'Epoxy Joint Check', 'Moisture Barrier'],
      engineeringNote: 'Digitally certified by Client on Aug 28. Tranche released to vendor ledger.',
    ),
    StageApprovalPackage(
      stageNumber: 3,
      title: 'Stage 3: Gypsum False Ceiling & Cove Lighting',
      subtitle: 'Saint-Gobain channel framing with concealed magnetic track profiles',
      category: 'Ceiling & Lighting',
      status: ApprovalStatus.approvedCertified,
      trancheAmount: '₹6,50,000',
      dueDate: 'Completed Aug 14, 2026',
      approvedDate: 'Aug 14, 2026',
      certificateId: 'CRT-STG3-402-871',
      supervisorName: 'Rajesh Verma',
      supervisorRole: 'Sr. Site Execution Supervisor',
      passedCheckpoints: 10,
      totalCheckpoints: 10,
      inspectionHighlights: [
        'Drop perimeter level check verified using optical laser instrument',
        'Reinforced ceiling anchors tested to 45 kg deadweight pull load',
        'Dual-switched 4000K warm white coves wired with fire-retardant grade wires',
      ],
      evidenceImages: ['Ceiling Laser Level', 'Magnetic Track Fit', 'Cove Lighting Test'],
      engineeringNote: 'Digitally signed and sealed. Zero snags reported on completion certificate.',
    ),
    StageApprovalPackage(
      stageNumber: 2,
      title: 'Stage 2: Concealed MEP & HVAC Ducting',
      subtitle: 'Multi-split VRV copper refrigeration lines & CPVC pressure lines',
      category: 'Infrastructure',
      status: ApprovalStatus.approvedCertified,
      trancheAmount: '₹9,20,000',
      dueDate: 'Completed Jul 29, 2026',
      approvedDate: 'Jul 29, 2026',
      certificateId: 'CRT-STG2-402-654',
      supervisorName: 'Vikram Malhotra',
      supervisorRole: 'Project Manager',
      passedCheckpoints: 12,
      totalCheckpoints: 12,
      inspectionHighlights: [
        'Hydrostatic pressure test sustained 10 bar for 48 consecutive hours',
        'Nitrogen leak test on HVAC refrigerant circuits showed 0.0 psi drop',
        'Circuit breaker isolation tests cleared by chartered electrical inspector',
      ],
      evidenceImages: ['Pressure Gauge Log', 'Concealed Conduit Map', 'Earthing Test Stamp'],
      engineeringNote: 'Full MEP as-built drawings archived in CAD Vault. Client sign-off recorded.',
    ),
    StageApprovalPackage(
      stageNumber: 1,
      title: 'Stage 1: Civil Demolition & Core Masonry',
      subtitle: 'Internal non-load bearing wall reconfiguration and debris removal',
      category: 'Civil & Structural',
      status: ApprovalStatus.approvedCertified,
      trancheAmount: '₹10,40,000',
      dueDate: 'Completed Jul 12, 2026',
      approvedDate: 'Jul 12, 2026',
      certificateId: 'CRT-STG1-402-412',
      supervisorName: 'Vikram Malhotra',
      supervisorRole: 'Project Manager',
      passedCheckpoints: 8,
      totalCheckpoints: 8,
      inspectionHighlights: [
        'Structural beam deflection test verified zero collateral stress',
        'AAC blockwork cured with polymer-modified bonding mortar',
        'Society management clean corridor & lift protection sign-off obtained',
      ],
      evidenceImages: ['Demolition Clearance', 'AAC Masonry Alignment', 'Society NOC Stamped'],
      engineeringNote: 'Kick-off structural milestone signed off with zero damages or society complaints.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    final filteredPackages = _getFilteredPackages();

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
                // 1. Executive Approvals Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Summary Metric Strip
                _buildMetricStrip(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Segmented Filter Tabs
                _buildFilterTabs(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Stage Approval Package Cards
                if (filteredPackages.isEmpty)
                  _buildEmptyState(context, isDark)
                else
                  ...filteredPackages.map((pkg) => Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: _buildStagePackageCard(context, pkg, isDark, isMobile),
                      )),

                const SizedBox(height: 16),

                // 5. Digital Signature Compliance Guarantee Note
                _buildComplianceGuaranteeBanner(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<StageApprovalPackage> _getFilteredPackages() {
    if (_selectedFilter == 'Action Required') {
      return _packages.where((p) => p.isPendingAction).toList();
    }
    if (_selectedFilter == 'Approved & Certified') {
      return _packages.where((p) => p.isApproved).toList();
    }
    if (_selectedFilter == 'Changes Requested') {
      return _packages.where((p) => p.isRevisionRequested).toList();
    }
    return _packages;
  }

  // ==========================================================================
  // 1. EXECUTIVE APPROVALS HEADER
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
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF0F172A).withValues(alpha: 0.03),
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
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '2 Stages Awaiting Client Action',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEF4444),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stage Work Approvals',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 22 : 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Digital sign-offs for construction milestones, quality inspection certificates & tranche release authorizations.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. METRIC STRIP
  // ==========================================================================
  Widget _buildMetricStrip(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;

        final cards = [
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.pending_actions_rounded,
            iconColor: const Color(0xFFEF4444),
            title: 'Action Required',
            value: '2 Stages',
            subtitle: 'Stage 5 & Floor Variation',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Approved & Certified',
            value: '4 Milestones',
            subtitle: '₹34.1L cumulative released',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF6366F1),
            title: 'Pending Milestone Value',
            value: '₹8,70,000',
            subtitle: 'Authorized on sign-off',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF0EA5E9),
            title: 'Audit Compliance',
            value: '100% Passed',
            subtitle: 'All engineer checks signed',
          ),
        ];

        if (isNarrow) {
          return Column(
            children: cards
                .map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: c,
                    ))
                .toList(),
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
  // 3. SEGMENTED FILTER TABS
  // ==========================================================================
  Widget _buildFilterTabs(BuildContext context, bool isDark, bool isMobile) {
    final tabs = [
      ('All Packages', 'All Packages (${_packages.length})'),
      ('Action Required', 'Action Required (${_packages.where((p) => p.isPendingAction).length})'),
      ('Approved & Certified', 'Approved & Certified (${_packages.where((p) => p.isApproved).length})'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((t) {
          final isSelected = _selectedFilter == t.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = t.$1;
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
                  t.$2,
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

  // ==========================================================================
  // 4. STAGE APPROVAL PACKAGE CARD
  // ==========================================================================
  Widget _buildStagePackageCard(
    BuildContext context,
    StageApprovalPackage pkg,
    bool isDark,
    bool isMobile,
  ) {
    final isExpanded = _expandedStageChecklists.contains(pkg.stageNumber);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: pkg.isPendingAction
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: pkg.isPendingAction ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: pkg.isPendingAction
                ? const Color(0xFFEF4444).withValues(alpha: 0.08)
                : (isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03)),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Accent / Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Tags Row
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            pkg.category,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        Text(
                          pkg.dueDate,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Status Badge
                    if (pkg.isPendingAction)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded, size: 12, color: Color(0xFFEF4444)),
                            const SizedBox(width: 5),
                            Text(
                              'ACTION REQUIRED',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (pkg.isApproved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF10B981)),
                            const SizedBox(width: 5),
                            Text(
                              'APPROVED & CERTIFIED',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title & Subtitle
                Text(
                  pkg.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  pkg.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 14),

                // Financial Release Strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.payments_outlined, size: 16, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Milestone Tranche Value',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                pkg.trancheAmount,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_pin_circle_outlined, size: 16, color: Color(0xFF6366F1)),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: isMobile ? 180 : 340),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inspecting Authority',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Text(
                                  '${pkg.supervisorName} (${pkg.supervisorRole})',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${pkg.passedCheckpoints}/${pkg.totalCheckpoints} Criteria Passed',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Inspection Highlights Checklist
                ...pkg.inspectionHighlights.take(isExpanded ? 10 : 2).map((h) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            h,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Expand/Collapse checklist button
                if (pkg.inspectionHighlights.length > 2)
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedStageChecklists.remove(pkg.stageNumber);
                        } else {
                          _expandedStageChecklists.add(pkg.stageNumber);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        isExpanded
                            ? '▲ Show Fewer Technical Checkpoints'
                            : '▼ View All ${pkg.inspectionHighlights.length} Engineering Checkpoints',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Engineering Sign-Off Note
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF6366F1)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          pkg.engineeringNote,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                if (pkg.certificateId != null)
                  Text(
                    'Certificate ID: ${pkg.certificateId}',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  )
                else
                  Text(
                    'Action Due: Immediate for Stage Release',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEF4444),
                    ),
                  ),

                // Action Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (pkg.isPendingAction) ...[
                      OutlinedButton.icon(
                        onPressed: () => _showModificationDialog(context, pkg, isDark),
                        icon: const Icon(Icons.edit_note_rounded, size: 14, color: Color(0xFFEF4444)),
                        label: Text(
                          'Request Modification',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showDigitalSignOffDialog(context, pkg, isDark),
                        icon: const Icon(Icons.draw_rounded, size: 14, color: Colors.white),
                        label: Text(
                          'Approve & Sign Digitally',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          elevation: 0,
                        ),
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: () => _showCertificateModal(context, pkg, isDark),
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 14, color: Color(0xFF6366F1)),
                        label: Text(
                          'View Certificate',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    ],
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
  // 5. COMPLIANCE & LEGAL GUARANTEE BANNER
  // ==========================================================================
  Widget _buildComplianceGuaranteeBanner(BuildContext context, bool isDark, bool isMobile) {
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
          const Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legal Digital Certification Guarantee',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Every stage approval is cryptographically signed and timestamped in the Homio Project Ledger. Approved certificates bind milestone release tranches and guarantee 10-year structural warranty enforcement.',
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

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded, size: 40, color: Color(0xFF10B981)),
            const SizedBox(height: 10),
            Text(
              'No Packages Found In This Category',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'All current items in this category are fully processed.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // MODALS & DIALOGS
  // ==========================================================================

  void _showDigitalSignOffDialog(BuildContext context, StageApprovalPackage pkg, bool isDark) {
    bool isAgreed = false;

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
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.draw_rounded, color: Color(0xFF10B981), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Digital Sign-Off Confirmation',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  pkg.title,
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

                      Container(
                        padding: const EdgeInsets.all(12),
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
                              'AUTHORIZATION SUMMARY',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildBullet('Authorized Tranche: ${pkg.trancheAmount}'),
                            _buildBullet('${pkg.passedCheckpoints}/${pkg.totalCheckpoints} Engineering checks verified by ${pkg.supervisorName}'),
                            _buildBullet('Authorizes commencement of next consecutive construction stage'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Checkbox agreement
                      InkWell(
                        onTap: () {
                          setDialogState(() {
                            isAgreed = !isAgreed;
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isAgreed,
                              onChanged: (val) {
                                setDialogState(() {
                                  isAgreed = val ?? false;
                                });
                              },
                              activeColor: const Color(0xFF10B981),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'I have reviewed the supervisor inspection evidence and hereby execute digital approval for this milestone.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
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
                            onPressed: !isAgreed
                                ? null
                                : () {
                                    Navigator.of(ctx).pop();
                                    setState(() {
                                      pkg.status = ApprovalStatus.approvedCertified;
                                      pkg.approvedDate = 'Sep 05, 2026';
                                      pkg.certificateId = 'CRT-STG${pkg.stageNumber}-402-EXP';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${pkg.title} approved and digitally certified!'),
                                        backgroundColor: const Color(0xFF10B981),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Sign & Approve Stage',
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

  void _showModificationDialog(BuildContext context, StageApprovalPackage pkg, bool isDark) {
    final noteController = TextEditingController();

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
                          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_note_rounded, color: Color(0xFFEF4444), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request Stage Modification',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Sent to ${pkg.supervisorName}',
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

                  const SizedBox(height: 16),

                  Text(
                    'Notes & Snag Details',
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
                      hintText: 'Specify the modification or check required before sign-off...',
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
                              content: Text('Modification request dispatched to supervisor!'),
                              backgroundColor: Color(0xFFEF4444),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Submit Request',
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
  }

  void _showCertificateModal(BuildContext context, StageApprovalPackage pkg, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
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
                        child: const Icon(Icons.verified_rounded, color: Color(0xFF6366F1), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stage Completion Certificate',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              pkg.certificateId ?? 'CRT-HOMIO',
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6366F1),
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pkg.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Certified Date: ${pkg.approvedDate ?? "Aug 2026"} • Stamped by ${pkg.supervisorName}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Milestone Value Released:',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5),
                            ),
                            Text(
                              pkg.trancheAmount,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
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
                            const SnackBar(
                              content: Text('Certificate PDF downloaded successfully!'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white),
                        label: Text(
                          'Download PDF',
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
          ),
        );
      },
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF10B981)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
