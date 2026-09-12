import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// My Enquiry Section for HOMIO Customer Portal.
/// Displays the customer's pre-booking relationship, requirements,
/// consultation meetings, quotation links, and journey timeline.
class ClientEnquiriesPage extends StatefulWidget {
  const ClientEnquiriesPage({super.key});

  @override
  State<ClientEnquiriesPage> createState() => _ClientEnquiriesPageState();
}

class _ClientEnquiriesPageState extends State<ClientEnquiriesPage> {
  String _selectedFilter = 'All';
  CustomerEnquiry? _selectedEnquiry;

  @override
  void initState() {
    super.initState();
    // Default to showing the primary enquiry detail if single, or list view
    _selectedEnquiry = ClientDataRepository.primaryEnquiry;
  }

  List<CustomerEnquiry> get _filteredEnquiries {
    final all = ClientDataRepository.allEnquiries;
    if (_selectedFilter == 'All') return all;
    if (_selectedFilter == 'Active') return all.where((e) => e.status == 'Active').toList();
    if (_selectedFilter == 'Converted') return all.where((e) => e.status == 'Converted').toList();
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md,
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Page Header
                _buildHeader(context, isDark, isDesktop),
                const SizedBox(height: 20),

                // If on mobile and an enquiry is selected, show detail with back button
                if (!isDesktop && _selectedEnquiry != null) ...[
                  _buildDetailView(context, _selectedEnquiry!, isDark, isDesktop),
                ] else if (isDesktop) ...[
                  // Desktop 2-Column Split: Enquiry List (35%) + Active Detail (65%)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildFilterTabs(isDark),
                            const SizedBox(height: 14),
                            ..._filteredEnquiries.map((enq) {
                              final isSelected = _selectedEnquiry?.id == enq.id;
                              return _buildEnquiryCard(enq, isDark, isSelected: isSelected);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 7,
                        child: _selectedEnquiry != null
                            ? _buildDetailView(context, _selectedEnquiry!, isDark, isDesktop)
                            : CustomerEmptyState(
                                icon: Icons.assignment_outlined,
                                title: 'Select an Enquiry',
                                message: 'Select an enquiry from the list to review detailed specifications and meetings.',
                              ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Mobile List View when none is selected
                  _buildFilterTabs(isDark),
                  const SizedBox(height: 14),
                  ..._filteredEnquiries.map((enq) {
                    return _buildEnquiryCard(enq, isDark);
                  }),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. TOP PAGE HEADER
  // ============================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isDesktop && _selectedEnquiry != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Back to List',
                  onPressed: () => setState(() => _selectedEnquiry = null),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.assignment_rounded, size: 16, color: Color(0xFF3B82F6)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'My Enquiries',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track consultation progress, submitted requirements & consultation meetings.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isDesktop)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedAppRadius.md,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                'New Requirement',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Requirement Form initiated.')),
                );
              },
            ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. FILTER TABS
  // ============================================================================
  Widget _buildFilterTabs(bool isDark) {
    final tabs = ['All', 'Active', 'Converted'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSel = _selectedFilter == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tab),
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                color: isSel ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
              ),
              selected: isSel,
              selectedColor: const Color(0xFF3B82F6),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSel ? Colors.transparent : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
              onSelected: (sel) {
                if (sel) setState(() => _selectedFilter = tab);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================================
  // 3. ENQUIRY CARD (LIST ITEM)
  // ============================================================================
  Widget _buildEnquiryCard(CustomerEnquiry enq, bool isDark, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isSelected
              ? const Color(0xFF3B82F6)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isSelected ? 1.8 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedEnquiry = enq),
        borderRadius: AppRadius.lg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Top: ID, Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      enq.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3B82F6),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomerStatusBadge(status: enq.stage, isSmall: true),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                enq.projectType,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      enq.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 10),

              // Assigned Consultant & Follow-Up
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned Consultant',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                        ),
                        Text(
                          enq.assignedPerson,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Next Follow-Up',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                      ),
                      Text(
                        enq.nextFollowUp,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 4. DETAILED ENQUIRY VIEW
  // ============================================================================
  Widget _buildDetailView(BuildContext context, CustomerEnquiry enq, bool isDark, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4.1 ENQUIRY STAGE TIMELINE JOURNEY
        _buildStageJourney(enq, isDark),
        const SizedBox(height: 16),

        // 4.2 OVERVIEW SUMMARY CARD
        _buildEnquiryOverviewCard(enq, isDark),
        const SizedBox(height: 16),

        // 4.3 CONNECTED QUOTATION CARD (IF PRESENT)
        if (enq.linkedQuotationId != null) ...[
          _buildLinkedQuotationCard(context, enq, isDark),
          const SizedBox(height: 16),
        ],

        // 4.4 CONSULTATION MEETINGS
        _buildMeetingsCard(context, enq, isDark),
        const SizedBox(height: 16),

        // 4.5 PROJECT REQUIREMENTS & PROPERTY SPECIFICATION
        _buildRequirementsCard(enq, isDark),
        const SizedBox(height: 16),

        // 4.6 CUSTOMER ACTIVITY TIMELINE
        CustomerDetailSectionCard(
          title: 'Enquiry Activity & Communication',
          icon: Icons.history_rounded,
          child: CustomerTimelineView(activities: enq.activityLog),
        ),
      ],
    );
  }

  // 4.1 Stage Stepper
  Widget _buildStageJourney(CustomerEnquiry enq, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
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
              const Icon(Icons.route_rounded, size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Text(
                'Consultation & Sales Journey',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Stepper
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(enq.stages.length, (idx) {
                final isDone = idx < enq.currentStageIndex;
                final isCurrent = idx == enq.currentStageIndex;
                final isLast = idx == enq.stages.length - 1;

                Color nodeColor;
                if (isDone) {
                  nodeColor = const Color(0xFF10B981);
                } else if (isCurrent) {
                  nodeColor = const Color(0xFF3B82F6);
                } else {
                  nodeColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
                }

                return Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: nodeColor.withValues(alpha: isDone || isCurrent ? 0.15 : 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: nodeColor, width: 2),
                          ),
                          child: Icon(
                            isDone
                                ? Icons.check_rounded
                                : (isCurrent ? Icons.circle_rounded : Icons.radio_button_unchecked),
                            size: 14,
                            color: nodeColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          enq.stages[idx],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCurrent
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                        ),
                      ],
                    ),
                    if (!isLast)
                      Container(
                        width: 36,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 20, left: 6, right: 6),
                        color: isDone ? const Color(0xFF10B981) : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // 4.2 Overview Card
  Widget _buildEnquiryOverviewCard(CustomerEnquiry enq, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ENQUIRY #${enq.id}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3B82F6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      enq.projectType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomerStatusBadge(status: enq.stage),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Overview Key-Value Grid
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildMetaItem('Created Date', enq.createdDate, isDark),
              _buildMetaItem('Budget Range', enq.budgetRange, isDark, highlight: true),
              _buildMetaItem('Expected Timeline', enq.expectedTimeline, isDark),
              _buildMetaItem('Design Consultant', enq.assignedPerson, isDark),
              _buildMetaItem('Next Follow-Up', enq.nextFollowUp, isDark),
            ],
          ),
          const SizedBox(height: 12),

          // Follow-up Purpose Callout
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
              borderRadius: AppRadius.md,
              border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Next Follow-Up: ${enq.nextFollowUpPurpose}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4.3 Linked Quotation Card
  Widget _buildLinkedQuotationCard(BuildContext context, CustomerEnquiry enq, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long_rounded, size: 22, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LINKED QUOTATION GENERATED',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  'Quotation #${enq.linkedQuotationId} (₹12,80,000)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Status: ${enq.quotationStatus} — Awaiting your acceptance',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              elevation: 0,
            ),
            onPressed: () => context.goNamed(RouteNames.clientQuotations),
            child: Text(
              'View Quotation',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  // 4.4 Meetings Card
  Widget _buildMeetingsCard(BuildContext context, CustomerEnquiry enq, bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Consultation Meetings',
      icon: Icons.video_camera_front_rounded,
      child: Column(
        children: enq.meetings.map((mtg) {
          final isUpcoming = mtg.status == 'Upcoming';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isUpcoming
                    ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
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
                      mtg.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    CustomerStatusBadge(status: mtg.status, isSmall: true),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event_rounded, size: 13, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 4),
                    Text(
                      '${mtg.date} • ${mtg.time} (${mtg.type})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                if (mtg.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    mtg.notes,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
                if (isUpcoming && mtg.meetingUrl != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedAppRadius.md,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening Google Meet link...')),
                          );
                        },
                        icon: const Icon(Icons.video_call_rounded, size: 15),
                        label: Text('Join Meeting', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedAppRadius.md,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reschedule request sent to Rahul Sharma.')),
                          );
                        },
                        child: Text('Reschedule', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4.5 Requirements Card
  Widget _buildRequirementsCard(CustomerEnquiry enq, bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Property & Project Requirement Details',
      icon: Icons.home_work_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer & Site Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Site Full Address', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                    Text(enq.fullAddress, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Property Type', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                  Text(enq.propertyType, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Property Specs Row
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildMetaItem('Carpet Area', enq.carpetArea, isDark),
              _buildMetaItem('Built-up Area', enq.builtUpArea, isDark),
              _buildMetaItem('Bedrooms', '${enq.bedrooms} BHK', isDark),
              _buildMetaItem('Bathrooms', '${enq.bathrooms}', isDark),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Style & Service
          Text('Design Style Preference', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
          Text(enq.stylePreference, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1))),
          const SizedBox(height: 8),

          Text('Service Required', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
          Text(enq.serviceRequired, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Text('Client Notes & Priorities', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
          Text(
            enq.notes,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.4,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, String value, bool isDark, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: highlight
                ? const Color(0xFF10B981)
                : (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
