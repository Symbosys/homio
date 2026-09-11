import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class HeroShowcaseSection extends StatefulWidget {
  const HeroShowcaseSection({super.key, required this.onExploreTap});

  final VoidCallback onExploreTap;

  @override
  State<HeroShowcaseSection> createState() => _HeroShowcaseSectionState();
}

class _HeroShowcaseSectionState extends State<HeroShowcaseSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;
    final isDesktop = context.isDesktop;

    final headingSize = context.responsiveValue<double>(
      compact: 32.0,
      medium: 44.0,
      expanded: 56.0,
      large: 64.0,
    );

    return Stack(
      children: [
        // Architectural Background Glow & Grid
        Positioned(
          top: -80,
          left: 0,
          right: 0,
          height: 600,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 0.9,
                colors: isDark
                    ? [
                        const Color(0xFF4F46E5).withValues(alpha: 0.16),
                        const Color(0xFF0F172A).withValues(alpha: 0.02),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFF6366F1).withValues(alpha: 0.10),
                        const Color(0xFFF1F5F9).withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),

        AdaptiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16.0 : 32.0,
            vertical: isCompact ? 36.0 : 64.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Eyebrow Badge
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1B4B).withValues(alpha: 0.6)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF4338CA).withValues(alpha: 0.5)
                          : const Color(0xFFC7D2FE),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'THE ALL-IN-ONE ARCHITECTURAL & PROJECT OPERATING SYSTEM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.9,
                          color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF3730A3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Hero Headline
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: Text(
                      'One Intelligent Platform for Design, Projects & Business.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: headingSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.8,
                        height: 1.12,
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Supporting Copy
              FadeTransition(
                opacity: _fadeAnimation,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Text(
                    'HOMIO brings AI-powered design, project execution, customer management, marketplace discovery, finance, procurement, and field operations together in one connected ecosystem.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isCompact ? 15 : 18,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Showcase Feature Strip
              FadeTransition(
                opacity: _fadeAnimation,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _PillIndicator(
                      icon: Icons.hub_rounded,
                      text: 'Unified Data Continuity',
                      isDark: isDark,
                    ),
                    _PillIndicator(
                      icon: Icons.psychology_rounded,
                      text: 'Design & Vastu AI',
                      isDark: isDark,
                    ),
                    _PillIndicator(
                      icon: Icons.storefront_rounded,
                      text: 'Curated Luxury Marketplace',
                      isDark: isDark,
                    ),
                    _PillIndicator(
                      icon: Icons.track_changes_rounded,
                      text: 'Site Progress to Balance Sheet',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 52),

              // Main Layered Visual Composition
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _HeroLayeredComposition(
                    isDark: isDark,
                    isDesktop: isDesktop,
                    floatAnimation: _floatAnimation,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PillIndicator extends StatelessWidget {
  const _PillIndicator({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLayeredComposition extends StatelessWidget {
  const _HeroLayeredComposition({
    required this.isDark,
    required this.isDesktop,
    required this.floatAnimation,
  });

  final bool isDark;
  final bool isDesktop;
  final Animation<double> floatAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isWide = availableWidth >= 980;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Centerpiece: Executive Dashboard Mockup
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 900 : availableWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              _dot(const Color(0xFFEF4444)),
                              const SizedBox(width: 6),
                              _dot(const Color(0xFFF59E0B)),
                              const SizedBox(width: 6),
                              _dot(const Color(0xFF10B981)),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0B0F19) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.lock_outline_rounded, size: 12, color: isDark ? Colors.white38 : Colors.black38),
                                  const SizedBox(width: 8),
                                  Text(
                                    'app.homiocrm.com/enterprise/dashboard/overview',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11,
                                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'LIVE SYNC',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dashboard Body
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'The Skyview Penthouse & Residence',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Architectural Turnkey • Phase 3: Civil & Fit-Out Execution',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Overall Progress: 74%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // 4 Metric Highlight Cards
                          LayoutBuilder(
                            builder: (context, box) {
                              final isCardStacked = box.maxWidth < 650;

                              if (isCardStacked) {
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    _MetricTile(title: 'Active Revenue', value: '\$1,420,000', delta: '+18.4%', isDark: isDark),
                                    _MetricTile(title: 'Milestones Done', value: '26 / 34', delta: 'On Schedule', isDark: isDark),
                                    _MetricTile(title: 'Site Workers Logged', value: '48 Verified', delta: 'Geofenced', isDark: isDark),
                                    _MetricTile(title: 'Procurement Cleared', value: '94.2%', delta: '12 Vendors', isDark: isDark),
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  Expanded(child: _MetricTile(title: 'Active Revenue', value: '\$1,420,000', delta: '+18.4%', isDark: isDark)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _MetricTile(title: 'Milestones Done', value: '26 / 34', delta: 'On Schedule', isDark: isDark)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _MetricTile(title: 'Site Workers Logged', value: '48 Verified', delta: 'Geofenced', isDark: isDark)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _MetricTile(title: 'Procurement Cleared', value: '94.2%', delta: '12 Vendors', isDark: isDark)),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Mini Timeline & Phase Tracker
                          Container(
                            padding: const EdgeInsets.all(16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PROJECT TIMELINE & EXECUTION STREAM',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      'Estimated Handover: Nov 28',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: 0.74,
                                    minHeight: 8,
                                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _timelineStep('AI Concept', true, isDark),
                                    _timelineStep('3D Design', true, isDark),
                                    _timelineStep('Procurement', true, isDark),
                                    _timelineStep('Civil Work (In Progress)', true, isDark, isActive: true),
                                    _timelineStep('Furnishing', false, isDark),
                                    _timelineStep('Handover', false, isDark),
                                  ],
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
            ),

            // Floating Layer 1: Left AI Design Card (visible on wide screens)
            if (isWide)
              Positioned(
                left: -40,
                bottom: 40,
                child: _FloatingCard(
                  title: 'AI DESIGN GENERATION',
                  subtitle: 'Contemporary Living Studio',
                  badge: 'Render Complete • 2.4s',
                  icon: Icons.auto_awesome,
                  color: const Color(0xFF7C3AED),
                  isDark: isDark,
                  width: 240,
                  content: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
                        ),
                        child: const Icon(Icons.architecture_rounded, color: Color(0xFF8B5CF6), size: 24),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Japandi Warm Wood',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Confidence: 99.2%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Floating Layer 2: Right Marketplace Card (visible on wide screens)
            if (isWide)
              Positioned(
                right: -40,
                top: 40,
                child: _FloatingCard(
                  title: 'HOMIO MARKETPLACE',
                  subtitle: 'Curated Architectural Finishes',
                  badge: 'Direct Supplier Sync',
                  icon: Icons.storefront_rounded,
                  color: const Color(0xFF0D9488),
                  isDark: isDark,
                  width: 250,
                  content: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.4)),
                        ),
                        child: const Icon(Icons.palette_outlined, color: Color(0xFF14B8A6), size: 24),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calacatta Gold Marble',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Pre-Negotiated • In Stock',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? Colors.white70 : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  static Widget _timelineStep(String text, bool isDone, bool isDark, {bool isActive = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4F46E5)
                  : isDone
                      ? const Color(0xFF10B981)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? const Color(0xFF4F46E5)
                  : isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.delta,
    required this.isDark,
  });

  final String title;
  final String value;
  final String delta;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            delta,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.width,
    required this.content,
  });

  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final bool isDark;
  final double width;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}
