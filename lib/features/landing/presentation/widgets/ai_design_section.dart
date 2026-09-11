import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class AiDesignSection extends StatefulWidget {
  const AiDesignSection({super.key});

  @override
  State<AiDesignSection> createState() => _AiDesignSectionState();
}

class _AiDesignSectionState extends State<AiDesignSection> {
  int _selectedStyleIndex = 0;

  final List<Map<String, dynamic>> _styles = [
    {
      'name': 'Modern',
      'mood': 'Warm Minimalist Oak & Travertine',
      'renderTime': '1.8s',
      'lighting': 'Ambient Soft Sunken Linear LED',
      'imageUrl': 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFF4F46E5),
    },
    {
      'name': 'Minimal',
      'mood': 'Micro-cement & Natural Linen Textures',
      'renderTime': '2.1s',
      'lighting': 'Nordic Natural Daylight Infiltration',
      'imageUrl': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFF0D9488),
    },
    {
      'name': 'Luxury',
      'mood': 'Calacatta Marble & Brushed Brass Accents',
      'renderTime': '2.4s',
      'lighting': 'Architectural Chandelier & Cove Lighting',
      'imageUrl': 'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFFD97706),
    },
    {
      'name': 'Contemporary',
      'mood': 'Fluted Glass, Matte Black & Sculptural Wood',
      'renderTime': '1.9s',
      'lighting': 'Directional Ceiling Track Fixtures',
      'imageUrl': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFF7C3AED),
    },
    {
      'name': 'Traditional',
      'mood': 'Reclaimed Teak, Classical Arches & Jali',
      'renderTime': '2.6s',
      'lighting': 'Warm Tungsten Sconces & Lanterns',
      'imageUrl': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFFB45309),
    },
    {
      'name': 'Premium',
      'mood': 'Bespoke Italian Leather & Venetian Plaster',
      'renderTime': '2.0s',
      'lighting': 'Architectural Recessed Wall Grazing',
      'imageUrl': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=1000&auto=format&fit=crop&q=80',
      'accent': Color(0xFF0284C7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;
    final isDesktop = context.isDesktop;
    final activeStyle = _styles[_selectedStyleIndex];

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
                  const Icon(Icons.psychology_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'AI-POWERED DESIGN INTELLIGENCE',
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

            // Section Heading
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Text(
                'Turn Ideas Into Beautiful Spaces With AI',
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
                  height: 1.15,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Supporting Message
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'Explore intelligent tools that help visualize rooms, understand design possibilities, calculate budgets, and accelerate creative decision-making.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 36),

            // Style Switcher Tabs (Presentation Only)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_styles.length, (index) {
                  final style = _styles[index];
                  final isSelected = _selectedStyleIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _selectedStyleIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark ? const Color(0xFF161F30) : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: style['accent'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              style['name'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 40),

            // Feature 1: Concept -> AI Visualization -> Refined Interior Showcase
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Transformation Steps Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _TransformationBadge(number: '1', title: 'Concept Sketch', isDone: true, isDark: isDark),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                            const SizedBox(width: 8),
                            _TransformationBadge(number: '2', title: 'AI Neural Diffusion', isDone: true, isDark: isDark),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                            const SizedBox(width: 8),
                            _TransformationBadge(number: '3', title: 'Refined Interior', isDone: true, isDark: isDark, isHighlight: true),
                          ],
                        ),
                        if (isDesktop)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Latency: ${activeStyle['renderTime']}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Big Image Preview Container
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: isCompact ? 16 / 10 : 21 / 9,
                          child: Image.network(
                            activeStyle['imageUrl'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                child: Center(
                                  child: Icon(Icons.image_outlined, size: 48, color: isDark ? Colors.white24 : Colors.black26),
                                ),
                              );
                            },
                          ),
                        ),

                        // Gradient overlay at bottom
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.75),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Specs on image
                        Positioned(
                          left: 24,
                          bottom: 24,
                          right: 24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (activeStyle['accent'] as Color).withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${activeStyle['name']} Aesthetic',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    activeStyle['mood'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: isCompact ? 16 : 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Lighting Scheme: ${activeStyle['lighting']}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isCompact)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                                      const SizedBox(width: 8),
                                      Text(
                                        '4K Photoreal Shader',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
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
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Features 2 & 3: Side-by-Side Static Mockups (AI Budget Calculator + AI Design Workspace)
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 840;

                final budgetCard = _AiBudgetCalculatorMockup(isDark: isDark);
                final workspaceCard = _AiDesignWorkspaceMockup(isDark: isDark);

                if (isStacked) {
                  return Column(
                    children: [
                      budgetCard,
                      const SizedBox(height: 20),
                      workspaceCard,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: budgetCard),
                    const SizedBox(width: 24),
                    Expanded(child: workspaceCard),
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

class _TransformationBadge extends StatelessWidget {
  const _TransformationBadge({
    required this.number,
    required this.title,
    required this.isDone,
    required this.isDark,
    this.isHighlight = false,
  });

  final String number;
  final String title;
  final bool isDone;
  final bool isDark;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isHighlight
                ? AppColors.primary
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isHighlight ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
            color: isHighlight
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
        ),
      ],
    );
  }
}

class _AiBudgetCalculatorMockup extends StatelessWidget {
  const _AiBudgetCalculatorMockup({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calculate_outlined, color: Color(0xFF10B981), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI Budget Calculator',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
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
                  'Auto-Estimator',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Estimated Project Budget Breakdown',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 12),

          _budgetRow('Materials (Tiles, Stone, Wood)', '\$42,500', 0.37, isDark),
          _budgetRow('Furniture & Custom Millwork', '\$28,400', 0.25, isDark),
          _budgetRow('Labour & On-Site Trades', '\$19,800', 0.17, isDark),
          _budgetRow('Architectural Design & 3D Engineering', '\$9,500', 0.08, isDark),
          _budgetRow('Civil Execution & Site Supervision', '\$14,200', 0.13, isDark),

          const SizedBox(height: 14),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ESTIMATED TOTAL',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '\$114,400',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Text(
                  '±2.8% Variance Accuracy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _budgetRow(String label, String value, double ratio, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 4,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiDesignWorkspaceMockup extends StatelessWidget {
  const _AiDesignWorkspaceMockup({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.space_dashboard_outlined, color: Color(0xFF8B5CF6), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI Design Workspace',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'APPROVED',
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

          _detailField('Project Name', 'Oberoi Penthouse Living & Terrace Suite', isDark),
          _detailField('Design Category', 'Architectural Interior Fit-Out (Bespoke Turnkey)', isDark),
          _detailField('Active Revision', 'Revision 4 of 5 (Client Signed)', isDark),
          _detailField('Approval Status', 'Client Approved • Ready for Procurement Handover', isDark),
          _detailField('Lead Designer', 'Ar. Anya Sen, Studio Principal Architect', isDark),

          const SizedBox(height: 14),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.lock_rounded, size: 14, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Specifications locked & auto-synced to Bill of Quantities',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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

  static Widget _detailField(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
