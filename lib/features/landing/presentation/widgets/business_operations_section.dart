import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class BusinessOperationsSection extends StatefulWidget {
  const BusinessOperationsSection({super.key});

  @override
  State<BusinessOperationsSection> createState() => _BusinessOperationsSectionState();
}

class _BusinessOperationsSectionState extends State<BusinessOperationsSection> {
  int _selectedModuleIndex = 0;

  final List<Map<String, dynamic>> _lifecycleStages = [
    {'name': 'Lead', 'icon': Icons.person_search_outlined, 'desc': 'Inbound capture & auto-enrichment'},
    {'name': 'Customer', 'icon': Icons.badge_outlined, 'desc': 'Verified 360 profile & site dossier'},
    {'name': 'Quotation', 'icon': Icons.request_quote_outlined, 'desc': 'Automated item-rate BOQ engine'},
    {'name': 'Design', 'icon': Icons.palette_outlined, 'desc': 'AI rendering & BIM CAD drawings'},
    {'name': 'Approval', 'icon': Icons.verified_outlined, 'desc': 'Client e-sign & scope lock'},
    {'name': 'Procurement', 'icon': Icons.inventory_2_outlined, 'desc': 'Vendor RFQs & material POs'},
    {'name': 'Execution', 'icon': Icons.handyman_outlined, 'desc': 'On-site punchlists & Gantt sync'},
    {'name': 'Finance', 'icon': Icons.account_balance_wallet_outlined, 'desc': 'Milestone billing & tax ledger'},
    {'name': 'After-Sales', 'icon': Icons.support_agent_outlined, 'desc': 'Snag warranty & maintenance'},
  ];

  final List<Map<String, dynamic>> _modules = [
    {
      'title': 'CRM & Sales Funnels',
      'icon': Icons.filter_alt_outlined,
      'metric': '84% Win-Rate on High-Ticket Turnkeys',
      'items': [
        'Multi-channel WhatsApp, Meta & Web inquiry aggregation',
        'Automated architectural qualification score (1-100)',
        'Site visit geostamp & surveyor measurement notes',
      ],
    },
    {
      'title': 'Quotations & Smart BOQ',
      'icon': Icons.receipt_long_outlined,
      'metric': '10-Minute Precision Quotation Turnaround',
      'items': [
        'Centralized regional Item Rate Master database',
        'Instant multi-tier margin calculation (Materials, Labour, Markups)',
        'One-click client interactive web proposal generation',
      ],
    },
    {
      'title': 'Project Gantt & Milestone Tracking',
      'icon': Icons.calendar_month_outlined,
      'metric': 'Zero Critical Path Delays Across 18 Sites',
      'items': [
        'Dynamic dependency linking from demolition to polish',
        'Automatic delay propagation and vendor delivery alarms',
        'Daily contractor check-ins linked directly to milestones',
      ],
    },
    {
      'title': 'On-Site Progress & Snag Resolution',
      'icon': Icons.fact_check_outlined,
      'metric': '99.1% Defect-Free Handover Score',
      'items': [
        'Geofenced supervisor photo check-ins with timestamps',
        'Pinpoint photo snagging directly onto architectural drawings',
        'Contractor dispute mitigation with auditable revision logs',
      ],
    },
    {
      'title': 'Commercial Tracking & Finance',
      'icon': Icons.monetization_on_outlined,
      'metric': 'Automated Milestone Stage Release Billing',
      'items': [
        'Real-time cashflow projection per ongoing project',
        'Subcontractor measurement sheets and retention holding',
        'Direct GST/Tax ledger integration and payment gateway sync',
      ],
    },
    {
      'title': 'After-Sales & Warranty Governance',
      'icon': Icons.verified_user_outlined,
      'metric': '10-Year Comprehensive Warranty Portal',
      'items': [
        'Digital homeowner appliance & material warranty locker',
        'Automated 3-month, 6-month, and 1-year inspection scheduling',
        'Direct maintenance ticketing linked to original execution team',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;
    final activeModule = _modules[_selectedModuleIndex];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isCompact ? 50 : 90,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: AdaptiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Eyebrow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sync_alt_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'END-TO-END PLATFORM CONTINUUM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Heading
            Text(
              'From First Conversation to Final Execution',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: context.responsiveValue<double>(
                  compact: 28,
                  medium: 38,
                  expanded: 44,
                  large: 48,
                ),
                fontWeight: FontWeight.w800,
                letterSpacing: -1.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 16),

            // Supporting
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 740),
              child: Text(
                'Replace disconnected spreadsheets and fragmented chat tools. HOMIO unifies every department, phase, and stakeholder into one continuous digital pipeline.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Horizontal Lifecycle Visualization (Horizontal scrollable on compact, sleek chain on wide)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'THE 9-STAGE INTEGRATED LIFECYCLE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Continuity Active',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_lifecycleStages.length, (i) {
                        final stage = _lifecycleStages[i];
                        final isLast = i == _lifecycleStages.length - 1;

                        return Row(
                          children: [
                            Container(
                              width: 130,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(stage['icon'] as IconData, size: 16, color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    stage['name'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    stage['desc'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Operations Capability Grid with Interactive Preview Tabs
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 880;

                final leftList = Column(
                  children: List.generate(_modules.length, (idx) {
                    final mod = _modules[idx];
                    final isSelected = _selectedModuleIndex == idx;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _selectedModuleIndex = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.15)
                                      : (isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  mod['icon'] as IconData,
                                  size: 18,
                                  color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  mod['title'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: isSelected ? AppColors.primary : (isDark ? Colors.white24 : Colors.black26),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );

                final rightPreview = Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(activeModule['icon'] as IconData, size: 24, color: AppColors.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeModule['title'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeModule['metric'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Engineered Operational Capabilities',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        children: (activeModule['items'] as List<String>).map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.hub_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Data connects seamlessly into Finance & Execution',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SHOWCASE VIEW',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                if (isStacked) {
                  return Column(
                    children: [
                      leftList,
                      const SizedBox(height: 24),
                      rightPreview,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: leftList),
                    const SizedBox(width: 28),
                    Expanded(flex: 6, child: rightPreview),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
