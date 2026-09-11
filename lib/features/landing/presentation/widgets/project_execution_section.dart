import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class ProjectExecutionSection extends StatelessWidget {
  const ProjectExecutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isCompact ? 50 : 90,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
      ),
      child: AdaptiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Eyebrow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0284C7).withValues(alpha: 0.15) : const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF0284C7).withValues(alpha: 0.5) : const Color(0xFFBAE6FD),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.handyman_outlined, size: 14, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'PROJECT EXECUTION & DESIGN COLLABORATION',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Heading
            Text(
              'Design. Collaborate. Execute. Track.',
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
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'Bridge the gap between design studio creativity and physical on-site contractors. Track timelines, revisions, milestones, and handover protocols in real-time.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 44),

            // 1. Gantt Timeline Visualization Mockup
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timeline_rounded, color: Color(0xFF0284C7), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Gantt Milestone Schedule • Turnkey Execution',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ON TRACK (DAY 48 OF 75)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Gantt Bars
                  _ganttBar('1. Architectural Design & 3D Approvals', 1.0, '100% Done', const Color(0xFF10B981), isDark),
                  _ganttBar('2. Material Procurement & Factory Orders', 0.92, '92% Dispatched', const Color(0xFF6366F1), isDark),
                  _ganttBar('3. Civil, Electrical & Plumbing Rough-in', 0.88, '88% Verified', const Color(0xFF0284C7), isDark),
                  _ganttBar('4. Modular Millwork & Joinery Fit-Out', 0.54, '54% In Progress', const Color(0xFFF59E0B), isDark),
                  _ganttBar('5. Soft Furnishing, Deep Clean & Handover', 0.10, 'Scheduled Oct 18', const Color(0xFF94A3B8), isDark),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // 2. Side-by-Side: Site Progress Dashboard + Design Collaboration Stream
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 900;

                final leftSite = _SiteProgressMockup(isDark: isDark);
                final rightCollab = _DesignCollaborationMockup(isDark: isDark);

                if (isStacked) {
                  return Column(
                    children: [
                      leftSite,
                      const SizedBox(height: 24),
                      rightCollab,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: leftSite),
                    const SizedBox(width: 24),
                    Expanded(child: rightCollab),
                  ],
                );
              },
            ),

            const SizedBox(height: 36),

            // 3. Connected Activity Stream Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONNECTED DIGITAL AUDIT TRAIL',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _streamStep('Design Submitted', 'v3.0 Renders', isDark, true),
                        _stepArrow(isDark),
                        _streamStep('Client Reviewed', 'VR Walkthrough', isDark, true),
                        _stepArrow(isDark),
                        _streamStep('Revision Requested', 'Pendant Lighting', isDark, true),
                        _stepArrow(isDark),
                        _streamStep('Designer Updated', 'v3.2 Locked', isDark, true),
                        _stepArrow(isDark),
                        _streamStep('Client Approved', 'Digital Signoff', isDark, true),
                        _stepArrow(isDark),
                        _streamStep('Execution Handover', 'BOQ Locked', isDark, true, isHighlight: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _ganttBar(String title, double progress, String label, Color barColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _stepArrow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.arrow_forward_rounded, size: 14, color: isDark ? Colors.white24 : Colors.black26),
    );
  }

  static Widget _streamStep(String title, String sub, bool isDark, bool isDone, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight
            ? const Color(0xFF10B981).withValues(alpha: 0.15)
            : (isDark ? const Color(0xFF161F30) : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlight
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isHighlight
                  ? const Color(0xFF10B981)
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteProgressMockup extends StatelessWidget {
  const _SiteProgressMockup({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Site Progress Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '74% COMPLETE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _progressField('Current Milestone', 'Phase 4: Modular Millwork & Wet Area Cladding', isDark),
          _progressField('Today’s Progress', 'Sub-floor leveling completed; 42 supervisor photo logs uploaded', isDark),
          _progressField('Pending Verification', 'Fluted glass partition acoustic vibration damping test', isDark),
          _progressField('Assigned Team', 'Rajesh V. (PM) • 12 Verified Site Workers Logged', isDark),

          const SizedBox(height: 14),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.camera_alt_outlined, size: 16, color: Color(0xFF0284C7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Daily Geotagged Site Photo Stream Auto-Synced to Client App',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _progressField(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesignCollaborationMockup extends StatelessWidget {
  const _DesignCollaborationMockup({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Design Workspace & Annotations',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'v3.2 REVISION',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _collabItem('File Version', 'The_Skyview_Residence_Living_v3.2.dwg (BIM LOD 350)', isDark),
          _collabItem('Revision History', '4 iterations archived with change-delta highlights', isDark),
          _collabItem('Client Annotation', '"Approved ceiling drop height at 2.85m. Ready for joinery."', isDark),
          _collabItem('Execution Handover', 'Auto-generated cutting lists sent to CNC millwork shop', isDark),

          const SizedBox(height: 14),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.sync_problem_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Zero Drawing Drift: Contractors only see certified, approved revisions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _collabItem(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
