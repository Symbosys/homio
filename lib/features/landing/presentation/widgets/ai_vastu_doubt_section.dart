import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/theme_controller.dart';

class AiVastuDoubtSection extends StatefulWidget {
  const AiVastuDoubtSection({super.key});

  @override
  State<AiVastuDoubtSection> createState() => _AiVastuDoubtSectionState();
}

class _AiVastuDoubtSectionState extends State<AiVastuDoubtSection> {
  int _activeQuestionIndex = 0;

  final List<Map<String, String>> _doubtExamples = [
    {
      'q': 'Which flooring works best for this space?',
      'a':
          'For a high-traffic coastal living suite with underfloor heating, Italian Travertine or European Engineered White Oak (14mm with 4mm wear layer) offers superior dimensional stability, acoustic comfort, and natural tactile elegance.',
      'category': 'Material Selection',
    },
    {
      'q': 'How can I optimize this room layout?',
      'a':
          'Reposition the bespoke media credenza to the eastern boundary wall to unlock an unobstructed 1.4m primary circulation spine, maintaining uninterrupted natural light and panoramic sightlines to the private terrace.',
      'category': 'Spatial Planning',
    },
    {
      'q': 'What should I consider before starting execution?',
      'a':
          'Ensure MEP core slab core-cuts and dual-coat polyurethane waterproofing on all wet zones are certified prior to screed casting. HOMIO has auto-flagged 2 conduit overlaps in the coordinated BIM structural model.',
      'category': 'Execution & MEP',
    },
  ];

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
                color: isDark ? const Color(0xFF0D9488).withValues(alpha: 0.15) : const Color(0xFFCCFBF1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF0D9488).withValues(alpha: 0.5) : const Color(0xFF99F6E4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.explore_outlined, size: 14, color: Color(0xFF0D9488)),
                  const SizedBox(width: 8),
                  Text(
                    'INTELLIGENT ADVISORY & ARCHITECTURAL EXPERTISE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: const Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Heading
            Text(
              'Intelligence Beyond Design',
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
                'HOMIO combines spatial computing, directional Vastu science, and automated domain advisory into seamless guidance throughout the design and build journey.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Split Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 920;

                final leftVastu = _VastuConsultantMockup(isDark: isDark);
                final rightDoubt = _DoubtSolverMockup(
                  isDark: isDark,
                  doubtExamples: _doubtExamples,
                  activeIndex: _activeQuestionIndex,
                  onSelect: (idx) => setState(() => _activeQuestionIndex = idx),
                );

                if (isStacked) {
                  return Column(
                    children: [
                      leftVastu,
                      const SizedBox(height: 32),
                      rightDoubt,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: leftVastu),
                    const SizedBox(width: 32),
                    Expanded(flex: 5, child: rightDoubt),
                  ],
                );
              },
            ),

            const SizedBox(height: 36),

            // Additional AI Capability: Designer Video Call Card
            _DesignerVideoCallCard(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _VastuConsultantMockup extends StatelessWidget {
  const _VastuConsultantMockup({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.compass_calibration_outlined, color: Color(0xFF0D9488), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Vastu Consultant',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Automated Spatial Alignment & Energy Scoring',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
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
                  '94% HARMONY',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Architectural Floor-Plan Visual Blueprint
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
              ),
            ),
            child: Stack(
              children: [
                // Blueprint Grid Pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BlueprintGridPainter(isDark: isDark),
                  ),
                ),

                // Floor Plan Layout Lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FloorPlanGraphicPainter(isDark: isDark),
                  ),
                ),

                // Compass Directional Indicator
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.north_rounded, size: 14, color: Color(0xFF0D9488)),
                        const SizedBox(width: 4),
                        Text(
                          'TRUE NORTH',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Zone Tag 1: Master Bed
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _zoneTag('SW: Master Bed', const Color(0xFF10B981), isDark),
                ),
                // Zone Tag 2: Kitchen
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _zoneTag('SE: Kitchen (Adjust)', const Color(0xFFF59E0B), isDark),
                ),
                // Zone Tag 3: Entrance
                Positioned(
                  top: 16,
                  left: 16,
                  child: _zoneTag('NE: Entrance', const Color(0xFF10B981), isDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Vastu Analysis & Zone Insights',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 12),

          // 4 Static Vastu Insights
          _vastuInsight(
            title: 'Entrance',
            status: 'Recommended',
            isSuccess: true,
            desc: 'North-East orientation maximizes natural prana and morning luminosity.',
            isDark: isDark,
          ),
          _vastuInsight(
            title: 'Living Room',
            status: 'Suitable',
            isSuccess: true,
            desc: 'North-West placement optimal for air circulation and welcoming social flow.',
            isDark: isDark,
          ),
          _vastuInsight(
            title: 'Kitchen',
            status: 'Consider adjustment',
            isSuccess: false,
            desc: 'Cooking counter shifted 12° from ideal South-East fire zone; baffle wall suggested.',
            isDark: isDark,
          ),
          _vastuInsight(
            title: 'Master Bedroom',
            status: 'Recommended',
            isSuccess: true,
            desc: 'South-West placement provides grounding stability and superior acoustic isolation.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  static Widget _zoneTag(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  static Widget _vastuInsight({
    required String title,
    required String status,
    required bool isSuccess,
    required String desc,
    required bool isDark,
  }) {
    final statusColor = isSuccess ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    final icon = isSuccess ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: statusColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubtSolverMockup extends StatelessWidget {
  const _DoubtSolverMockup({
    required this.isDark,
    required this.doubtExamples,
    required this.activeIndex,
    required this.onSelect,
  });

  final bool isDark;
  final List<Map<String, String>> doubtExamples;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final activeItem = doubtExamples[activeIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF4F46E5), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Technical Doubt Solver',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Pre-Trained Architectural & Construction Copilot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'SHOWCASE PREVIEW',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Select an Example Inquiry to Preview Response:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 12),

          // Question Tabs (Safe showcase interaction)
          Column(
            children: List.generate(doubtExamples.length, (idx) {
              final item = doubtExamples[idx];
              final isCurrent = activeIndex == idx;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onSelect(idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrent
                            ? const Color(0xFF4F46E5)
                            : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          size: 16,
                          color: isCurrent ? const Color(0xFF4F46E5) : (isDark ? Colors.white38 : Colors.black38),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '"${item['q']}"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                              color: isCurrent
                                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['category']!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Conversational Response Window
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0F19) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'HOMIO Architectural AI • Technical Response',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  activeItem['a']!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Source: HOMIO Material Masters & Structural Guidelines',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined, size: 12, color: isDark ? Colors.white38 : Colors.black38),
                        const SizedBox(width: 8),
                        Icon(Icons.copy_rounded, size: 12, color: isDark ? Colors.white38 : Colors.black38),
                      ],
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
}

class _DesignerVideoCallCard extends StatelessWidget {
  const _DesignerVideoCallCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          // Video preview placeholder thumbnail
          Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.5)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.person_rounded, color: Color(0xFF4F46E5), size: 30),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Live Designer Collaboration & Video Call',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LIVE HUD',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Ar. Kabir Mehta (Principal Architect) • Synchronized 3D Model Markup & Spatial Walkthrough',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Static Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.videocam_outlined, size: 16, color: Color(0xFF4F46E5)),
                const SizedBox(width: 6),
                Text(
                  '1-on-1 Session Ready',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  final bool isDark;
  _BlueprintGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)).withValues(alpha: 0.5)
      ..strokeWidth = 0.8;

    const step = 20.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlueprintGridPainter oldDelegate) => false;
}

class _FloorPlanGraphicPainter extends CustomPainter {
  final bool isDark;
  _FloorPlanGraphicPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = (isDark ? Colors.white70 : const Color(0xFF334155))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(30, 20, size.width - 60, size.height - 40);
    canvas.drawRect(rect, wallPaint);

    // Internal partition walls
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.45, rect.top),
      Offset(rect.left + rect.width * 0.45, rect.bottom),
      wallPaint,
    );
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.45, rect.top + rect.height * 0.5),
      Offset(rect.right, rect.top + rect.height * 0.5),
      wallPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FloorPlanGraphicPainter oldDelegate) => false;
}
