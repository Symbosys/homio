import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_logo.dart';

class EcosystemClosingSection extends StatefulWidget {
  const EcosystemClosingSection({
    super.key,
    required this.onSectionSelected,
  });

  final ValueChanged<int> onSectionSelected;

  @override
  State<EcosystemClosingSection> createState() => _EcosystemClosingSectionState();
}

class _EcosystemClosingSectionState extends State<EcosystemClosingSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  final List<Map<String, dynamic>> _nodes = [
    {'title': 'AI Studio', 'icon': Icons.auto_awesome, 'color': Color(0xFF6366F1)},
    {'title': 'Design Workspace', 'icon': Icons.architecture, 'color': Color(0xFF8B5CF6)},
    {'title': 'Sales & CRM', 'icon': Icons.filter_alt_outlined, 'color': Color(0xFF06B6D4)},
    {'title': 'Projects & Gantt', 'icon': Icons.view_timeline_outlined, 'color': Color(0xFF0284C7)},
    {'title': 'Marketplace', 'icon': Icons.storefront_outlined, 'color': Color(0xFFD97706)},
    {'title': 'Procurement', 'icon': Icons.inventory_2_outlined, 'color': Color(0xFF10B981)},
    {'title': 'Finance & Ledger', 'icon': Icons.account_balance_outlined, 'color': Color(0xFF0D9488)},
    {'title': 'Communication Hub', 'icon': Icons.chat_outlined, 'color': Color(0xFFEC4899)},
    {'title': 'HRMS & Labour', 'icon': Icons.badge_outlined, 'color': Color(0xFF8B5CF6)},
    {'title': 'Service Booking', 'icon': Icons.build_outlined, 'color': Color(0xFF3B82F6)},
    {'title': 'After-Sales Care', 'icon': Icons.verified_outlined, 'color': Color(0xFF10B981)},
    {'title': 'Executive Analytics', 'icon': Icons.query_stats_outlined, 'color': Color(0xFFF59E0B)},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    return Container(
      padding: EdgeInsets.only(
        top: isCompact ? 60 : 100,
        bottom: 40,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070A10) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Column(
        children: [
          AdaptiveContainer(
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
                      const Icon(Icons.hub_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'THE HOMIO ECOSYSTEM',
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
                  'One Ecosystem. Every Part of the Business Connected.',
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
                    'Built to bring design, people, projects, and business operations together under one intelligent architecture.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isCompact ? 15 : 17,
                      height: 1.6,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Radial / Grid Ecosystem Presentation
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final isWide = width >= 800;

                    if (isWide) {
                      return _RadialEcosystemDiagram(
                        nodes: _nodes,
                        isDark: isDark,
                        pulseController: _pulseController,
                      );
                    } else {
                      return _MobileEcosystemGrid(
                        nodes: _nodes,
                        isDark: isDark,
                      );
                    }
                  },
                ),

                const SizedBox(height: 60),

                // Closing Message Box (Not a traditional CTA!)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 24 : 48,
                    vertical: isCompact ? 32 : 48,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1E1B4B),
                              const Color(0xFF0F172A),
                            ]
                          : [
                              const Color(0xFFEEF2FF),
                              Colors.white,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? const Color(0xFF3730A3) : const Color(0xFFC7D2FE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const AppLogo(size: 42, showTag: true),
                      const SizedBox(height: 20),
                      Text(
                        'Built to bring design, people, projects and business operations together.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isCompact ? 20 : 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.3,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'The next-generation operating standard for interior design studios, architects, and luxury turnkey builders.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isCompact ? 13 : 15,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0B0F19) : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ALL 12 CORE MODULES SYNCHRONIZED',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // Architectural Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: AdaptiveContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppLogo(size: 28, showTag: false),
                      Wrap(
                        spacing: 20,
                        children: [
                          _footerLink('Platform', () => widget.onSectionSelected(0), isDark),
                          _footerLink('AI Suite', () => widget.onSectionSelected(1), isDark),
                          _footerLink('Marketplace', () => widget.onSectionSelected(4), isDark),
                          _footerLink('Projects', () => widget.onSectionSelected(5), isDark),
                          _footerLink('Operations', () => widget.onSectionSelected(7), isDark),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2026 HOMIO CRM Inc. All rights reserved.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        'Interactive Product Showcase Edition',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String title, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _RadialEcosystemDiagram extends StatelessWidget {
  const _RadialEcosystemDiagram({
    required this.nodes,
    required this.isDark,
    required this.pulseController,
  });

  final List<Map<String, dynamic>> nodes;
  final bool isDark;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    const size = 560.0;
    const radius = 220.0;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Connecting Lines Canvas
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(size, size),
                  painter: _EcosystemLinesPainter(
                    isDark: isDark,
                    pulseValue: pulseController.value,
                    nodeCount: nodes.length,
                    radius: radius,
                  ),
                );
              },
            ),

            // Center Node: HOMIO Medallion
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.45),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hub_rounded, color: Colors.white, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      'HOMIO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CORE BRAIN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 12 Connected Nodes around circle
            ...List.generate(nodes.length, (i) {
              final angle = (i * 2 * math.pi / nodes.length) - (math.pi / 2);
              final x = (size / 2) + radius * math.cos(angle) - 45;
              final y = (size / 2) + radius * math.sin(angle) - 30;
              final node = nodes[i];

              return Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 90,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (node['color'] as Color).withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (node['color'] as Color).withValues(alpha: 0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(node['icon'] as IconData, size: 16, color: node['color'] as Color),
                      const SizedBox(height: 2),
                      Text(
                        node['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MobileEcosystemGrid extends StatelessWidget {
  const _MobileEcosystemGrid({required this.nodes, required this.isDark});

  final List<Map<String, dynamic>> nodes;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Center Core
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hub_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOMIO CORE ENGINE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Central Architectural Brain',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Grid of 12 Connected Nodes
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: nodes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, idx) {
            final node = nodes[idx];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Icon(node['icon'] as IconData, size: 18, color: node['color'] as Color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      node['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EcosystemLinesPainter extends CustomPainter {
  final bool isDark;
  final double pulseValue;
  final int nodeCount;
  final double radius;

  _EcosystemLinesPainter({
    required this.isDark,
    required this.pulseValue,
    required this.nodeCount,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final linePaint = Paint()
      ..color = (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)).withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    final pulsePaint = Paint()
      ..color = const Color(0xFF6366F1).withValues(alpha: 0.8)
      ..strokeWidth = 2.0;

    for (int i = 0; i < nodeCount; i++) {
      final angle = (i * 2 * math.pi / nodeCount) - (math.pi / 2);
      final target = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // Draw connecting line
      canvas.drawLine(center, target, linePaint);

      // Draw subtle traveling pulse point along line
      final pulseDist = ((pulseValue + (i / nodeCount)) % 1.0);
      final pulsePos = Offset.lerp(center, target, pulseDist)!;
      canvas.drawCircle(pulsePos, 2.5, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EcosystemLinesPainter oldDelegate) => true;
}
