import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

/// "Access Anywhere" / "One Platform. Every Device. Total Freedom." showcase section.
/// Displays pixel-perfect multi-device mockups (Mobile Smartphone, Web Laptop, Desktop Monitor)
/// with callouts, annotations, and bottom value strip.
class AccessAnywhereSection extends StatelessWidget {
  const AccessAnywhereSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1150;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFF),
        gradient: isDark
            ? const RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.2,
                colors: [Color(0xFF161E38), Color(0xFF0B0F19)],
              )
            : const RadialGradient(
                center: Alignment(0, -0.4),
                radius: 1.4,
                colors: [
                  Color(0xFFEEF2FF),
                  Color(0xFFF8FAFC),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isTablet ? 24 : 48),
        vertical: isMobile ? 50 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Badge
              _buildTopBadge(isDark),
              const SizedBox(height: 20),

              // 2. Main Headline
              _buildHeadline(isDark, isMobile),
              const SizedBox(height: 16),

              // 3. Subtitle with Top-Right Hand-Drawn Annotation
              _buildSubtitleWithAnnotation(isDark, isMobile, isTablet),
              SizedBox(height: isMobile ? 36 : 56),

              // 4. Center Multi-Device Visual Composition
              if (isMobile)
                _buildMobileDeviceStack(isDark)
              else
                _buildDesktopDeviceComposition(isDark),

              SizedBox(height: isMobile ? 40 : 64),

              // 5. Bottom 4-Pillar Trust & Performance Strip
              _buildBottomTrustStrip(isDark, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TOP BADGE
  // ==========================================
  Widget _buildTopBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF241D49) : const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? const Color(0xFF4C1D95) : const Color(0xFFDDD6FE),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED)
                .withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          Text(
            'ACCESS ANYWHERE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF6D28D9),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MAIN HEADLINE
  // ==========================================
  Widget _buildHeadline(bool isDark, bool isMobile) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: isMobile ? 32 : 52,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          height: 1.15,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        children: [
          const TextSpan(text: 'One Platform.\nEvery Device. '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ).createShader(bounds),
              child: Text(
                'Total Freedom.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 32 : 52,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SUBTITLE & HANDWRITTEN ANNOTATION
  // ==========================================
  Widget _buildSubtitleWithAnnotation(
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            'Stay connected and productive, wherever you are. Access your workspace seamlessly across mobile, web, and desktop — with a consistent and powerful experience.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 14 : 17,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ),
        if (!isMobile)
          Positioned(
            right: isTablet ? -20 : -120,
            top: -24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: -0.08,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Same experience.',
                        style: GoogleFonts.caveat(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                      Text(
                        'Everywhere you work.',
                        style: GoogleFonts.caveat(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: CustomPaint(
                    size: const Size(38, 48),
                    painter: _HandDrawnArrowPainter(
                      color: const Color(0xFF6366F1),
                      isPointingDown: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ==========================================
  // DESKTOP MULTI-DEVICE COMPOSITION
  // ==========================================
  Widget _buildDesktopDeviceComposition(bool isDark) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 1240,
          height: 640,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Background soft floor glow
              Positioned(
                bottom: 80,
                child: Container(
                  width: 900,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF818CF8))
                                .withValues(alpha: isDark ? 0.15 : 0.22),
                        blurRadius: 100,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------------------
              // 1. MOBILE DEVICE (LEFT)
              // -------------------------------------------------------------
              Positioned(
                left: 40,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeviceCalloutCard(
                      icon: Icons.smartphone_rounded,
                      title: 'Mobile App',
                      description: 'Stay productive on the go\nwith full access to your\nworkspace.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: CustomPaint(
                        size: const Size(40, 36),
                        painter: _CurvedCalloutArrowPainter(
                          color: const Color(0xFF8B5CF6),
                          direction: ArrowDirection.downRight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bullets on the left of the phone
              Positioned(
                left: 10,
                bottom: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckBullet('Real-time updates', isDark),
                    const SizedBox(height: 10),
                    _buildCheckBullet('Quick actions', isDark),
                    const SizedBox(height: 10),
                    _buildCheckBullet('Stay connected', isDark),
                  ],
                ),
              ),

              // Mobile Phone Frame Mockup
              Positioned(
                left: 140,
                bottom: 85,
                child: _buildSmartphoneMockup(isDark),
              ),

              // -------------------------------------------------------------
              // 2. WEB APP LAPTOP (CENTER)
              // -------------------------------------------------------------
              Positioned(top: 40, child: _buildLaptopMockup(isDark)),

              // Floating Web Application Bottom Card
              Positioned(bottom: 10, child: _buildWebBottomCalloutCard(isDark)),

              // -------------------------------------------------------------
              // 3. DESKTOP MONITOR (RIGHT)
              // -------------------------------------------------------------
              Positioned(
                right: 50,
                top: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeviceCalloutCard(
                      icon: Icons.desktop_windows_rounded,
                      title: 'Desktop App',
                      description: 'A focused and feature-rich\nexperience for maximum\nproductivity.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: CustomPaint(
                        size: const Size(40, 36),
                        painter: _CurvedCalloutArrowPainter(
                          color: const Color(0xFF8B5CF6),
                          direction: ArrowDirection.downRight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Desktop Monitor Frame Mockup
              Positioned(
                right: 30,
                bottom: 100,
                child: _buildDesktopMonitorMockup(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // MOBILE STACK (FOR NARROW VIEWPORTS)
  // ==========================================
  Widget _buildMobileDeviceStack(bool isDark) {
    return Column(
      children: [
        // Web Laptop (Centered)
        _buildLaptopMockup(isDark, isCompact: true),
        const SizedBox(height: 16),
        _buildWebBottomCalloutCard(isDark, isCompact: true),
        const SizedBox(height: 36),

        // Mobile Phone & Bullets
        _buildDeviceCalloutCard(
          icon: Icons.smartphone_rounded,
          title: 'Mobile App',
          description:
              'Stay productive on the go with full access to your workspace.',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildSmartphoneMockup(isDark),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _buildCheckBullet('Real-time updates', isDark),
            _buildCheckBullet('Quick actions', isDark),
            _buildCheckBullet('Stay connected', isDark),
          ],
        ),
        const SizedBox(height: 36),

        // Desktop Monitor
        _buildDeviceCalloutCard(
          icon: Icons.desktop_windows_rounded,
          title: 'Desktop App',
          description:
              'A focused and feature-rich experience for maximum productivity.',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildDesktopMonitorMockup(isDark),
        ),
      ],
    );
  }

  // ==========================================
  // CALLOUT BADGE CARDS
  // ==========================================
  Widget _buildDeviceCalloutCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebBottomCalloutCard(bool isDark, {bool isCompact = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF312E81)
                            : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        size: 20,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Web Application',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'A powerful and intuitive experience right in your browser.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildCheckBullet('Complete feature access', isDark),
                    _buildCheckBullet('Real-time collaboration', isDark),
                    _buildCheckBullet('No installation required', isDark),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF312E81)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    size: 22,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Web Application',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A powerful and intuitive experience\nright in your browser.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 28),
                Container(
                  height: 36,
                  width: 1,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCheckBullet('Complete feature access', isDark),
                    const SizedBox(height: 6),
                    _buildCheckBullet('Real-time collaboration', isDark),
                    const SizedBox(height: 6),
                    _buildCheckBullet('No installation required', isDark),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildCheckBullet(String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 12, color: Colors.white),
        ),
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
    );
  }

  // ==========================================
  // 1. SMARTPHONE MOCKUP (LEFT)
  // ==========================================
  Widget _buildSmartphoneMockup(bool isDark) {
    return Container(
      width: 200,
      height: 410,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF475569), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Top Status Bar & Dynamic Island
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      width: 54,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 10,
                          color: Color(0xFF0F172A),
                        ),
                        SizedBox(width: 3),
                        Icon(Icons.wifi, size: 10, color: Color(0xFF0F172A)),
                        SizedBox(width: 3),
                        Icon(
                          Icons.battery_full,
                          size: 12,
                          color: Color(0xFF0F172A),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Mobile App Header Greeting
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning,',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Alex 👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 14,
                            color: Color(0xFF475569),
                          ),
                        ),
                        Positioned(
                          right: 3,
                          top: 3,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 12, color: Color(0xFF94A3B8)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Search anything...',
                          style: TextStyle(
                            fontSize: 8,
                            color: Color(0xFF94A3B8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3 Quick Metrics Pills
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    _buildMobileStatPill('Leads', '248', '+12%'),
                    const SizedBox(width: 4),
                    _buildMobileStatPill('Tasks', '24', '+4%'),
                    const SizedBox(width: 4),
                    _buildMobileStatPill('Projects', '18', '+8%'),
                  ],
                ),
              ),

              // Recent Activities Section
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 4,
                  bottom: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Recent Activities',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'See all',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ),

              // 4 Activity Rows
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMobileActivityItem(
                      letter: 'A',
                      color: const Color(0xFF8B5CF6),
                      title: 'New lead from website',
                      time: '2 min ago',
                    ),
                    _buildMobileActivityItem(
                      icon: Icons.folder_outlined,
                      color: const Color(0xFF3B82F6),
                      title: 'Project updated',
                      time: '12 min ago',
                    ),
                    _buildMobileActivityItem(
                      icon: Icons.calendar_today_outlined,
                      color: const Color(0xFFF59E0B),
                      title: 'Client meeting scheduled',
                      time: '1 hour ago',
                    ),
                    _buildMobileActivityItem(
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF10B981),
                      title: 'Task completed',
                      time: '2 hours ago',
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMobileNavItem(
                      Icons.home_rounded,
                      'Home',
                      isActive: true,
                    ),
                    _buildMobileNavItem(Icons.layers_outlined, 'Projects'),
                    // Purple Center FAB
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    _buildMobileNavItem(Icons.check_box_outlined, 'Tasks'),
                    _buildMobileNavItem(Icons.more_horiz, 'More'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileStatPill(String label, String value, String change) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 7, color: Color(0xFF64748B)),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              change,
              style: const TextStyle(
                fontSize: 6.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileActivityItem({
    String? letter,
    IconData? icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: letter != null
                ? Text(
                    letter,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  )
                : Icon(icon, size: 11, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 7, color: Color(0xFF94A3B8)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 12, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: isActive ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 6,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. LAPTOP WEB APP MOCKUP (CENTER)
  // ==========================================
  Widget _buildLaptopMockup(bool isDark, {bool isCompact = false}) {
    final width = isCompact ? 340.0 : 580.0;
    final height = isCompact ? 220.0 : 365.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Laptop Screen Frame
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: const Color(0xFF334155), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              // Screen Camera Notch Bar
              Container(
                height: 12,
                color: const Color(0xFF0F172A),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF334155),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              // Screen Inner Canvas (Light Dashboard)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: Row(
                      children: [
                        // Left Mini Sidebar
                        _buildLaptopSidebar(),
                        // Main Dashboard Canvas
                        Expanded(child: _buildLaptopDashboardCanvas()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Laptop Bottom Base & Metallic Hinge
        Container(
          width: width + 60,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFCBD5E1),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 70,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF64748B),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLaptopSidebar() {
    return Container(
      width: 74,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'homio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSidebarNavItem(
            Icons.dashboard_rounded,
            'Dashboard',
            isActive: true,
          ),
          _buildSidebarNavItem(Icons.layers_outlined, 'Projects'),
          _buildSidebarNavItem(Icons.check_box_outlined, 'Tasks'),
          _buildSidebarNavItem(Icons.people_outline, 'Contacts'),
          _buildSidebarNavItem(Icons.attach_money_rounded, 'Sales'),
          _buildSidebarNavItem(Icons.bar_chart_rounded, 'Reports'),
          _buildSidebarNavItem(Icons.bolt_outlined, 'Automation'),
          const Spacer(),
          _buildSidebarNavItem(Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 9,
              color: isActive
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 6.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF64748B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaptopDashboardCanvas() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Navigation Bar
          Row(
            children: [
              const Icon(
                Icons.chevron_left,
                size: 12,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 9, color: Color(0xFF94A3B8)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Search anything...',
                          style: TextStyle(
                            fontSize: 6.5,
                            color: Color(0xFF94A3B8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 10,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.notifications_outlined,
                size: 10,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AK',
                  style: TextStyle(
                    fontSize: 5.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Greeting & Period
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Alex 👋',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      "Here's what's happening today.",
                      style: TextStyle(fontSize: 6.5, color: Color(0xFF64748B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Mon, 3 Sep 2026',
                    style: TextStyle(fontSize: 6.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'This Month',
                          style: TextStyle(
                            fontSize: 6,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 8,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 4 Metric KPI Cards
          Row(
            children: [
              _buildLaptopKpiCard(
                'Total Leads',
                '248',
                '+12%',
                Icons.people_outline,
                const Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              _buildLaptopKpiCard(
                'Active Projects',
                '18',
                '+8%',
                Icons.layers_outlined,
                const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 6),
              _buildLaptopKpiCard(
                'Tasks Due',
                '24',
                '+4%',
                Icons.check_circle_outline,
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 6),
              _buildLaptopKpiCard(
                'Revenue',
                '\$12,430',
                '+11%',
                Icons.attach_money,
                const Color(0xFF059669),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 2 Bottom Panels (Project Progress & Upcoming Tasks)
          Expanded(
            child: Row(
              children: [
                // Project Progress Panel
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Project Progress',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 6,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildProjectRow(
                          'Website Redesign',
                          0.8,
                          const Color(0xFF6366F1),
                          '80%',
                        ),
                        _buildProjectRow(
                          'Mobile App Development',
                          0.6,
                          const Color(0xFF3B82F6),
                          '60%',
                        ),
                        _buildProjectRow(
                          'Marketing Campaign',
                          0.4,
                          const Color(0xFFF59E0B),
                          '40%',
                        ),
                        _buildProjectRow(
                          'CRM Integration',
                          0.9,
                          const Color(0xFF10B981),
                          '90%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Upcoming Tasks Panel
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming Tasks',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 6,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildTaskRow(
                          'Design landing page',
                          'Today, 10:00 AM',
                          const Color(0xFF6366F1),
                        ),
                        _buildTaskRow(
                          'Client meeting',
                          'Today, 01:00 PM',
                          const Color(0xFF3B82F6),
                        ),
                        _buildTaskRow(
                          'Prepare proposal',
                          'Tomorrow, 11:00 AM',
                          const Color(0xFF8B5CF6),
                        ),
                        _buildTaskRow(
                          'Review wireframes',
                          'Tomorrow, 03:00 PM',
                          const Color(0xFF10B981),
                        ),
                      ],
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

  Widget _buildLaptopKpiCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 5.5, color: Color(0xFF64748B)),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Icon(icon, size: 7, color: iconColor),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.arrow_upward,
                  size: 6,
                  color: Color(0xFF10B981),
                ),
                Flexible(
                  child: Text(
                    change,
                    style: const TextStyle(
                      fontSize: 5.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectRow(
    String name,
    double progress,
    Color color,
    String pct,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 4,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            pct,
            style: const TextStyle(fontSize: 5.5, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 4),
          // Mini Team Avatars
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  shape: BoxShape.circle,
                ),
              ),
              Transform.translate(
                offset: const Offset(-3, 0),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(String title, String time, Color tagColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(Icons.description_outlined, size: 7, color: tagColor),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 5, color: Color(0xFF94A3B8)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. DESKTOP MONITOR MOCKUP (RIGHT - DARK)
  // ==========================================
  Widget _buildDesktopMonitorMockup(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Monitor Display Screen
        Container(
          width: 320,
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF334155), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: const Color(0xFF111827),
              child: Row(
                children: [
                  // Dark Sidebar
                  Container(
                    width: 60,
                    color: const Color(0xFF0B0F19),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Expanded(
                              child: Text(
                                'homio',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildDarkSidebarItem(
                          Icons.dashboard_outlined,
                          'Dashboard',
                        ),
                        _buildDarkSidebarItem(
                          Icons.layers_rounded,
                          'Projects',
                          isActive: true,
                        ),
                        _buildDarkSidebarItem(
                          Icons.check_box_outlined,
                          'Tasks',
                        ),
                        _buildDarkSidebarItem(Icons.people_outline, 'Contacts'),
                        _buildDarkSidebarItem(Icons.attach_money, 'Sales'),
                        _buildDarkSidebarItem(Icons.bar_chart, 'Reports'),
                        _buildDarkSidebarItem(
                          Icons.bolt_outlined,
                          'Automation',
                        ),
                        const Spacer(),
                        _buildDarkSidebarItem(
                          Icons.settings_outlined,
                          'Settings',
                        ),
                      ],
                    ),
                  ),

                  // Dark Main Canvas
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar with Search, New Project Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.chevron_left,
                                size: 10,
                                color: Color(0xFF64748B),
                              ),
                              Expanded(
                                child: Container(
                                  height: 14,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F2937),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 7,
                                        color: Color(0xFF64748B),
                                      ),
                                      SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          'Search anything...',
                                          style: TextStyle(
                                            fontSize: 5.5,
                                            color: Color(0xFF64748B),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 8,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.notifications_outlined,
                                    size: 8,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEC4899),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'AK',
                                      style: TextStyle(
                                        fontSize: 4,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Header "Projects" & "+ New Project"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Projects',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 6,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '+ New Project',
                                      style: TextStyle(
                                        fontSize: 5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Filter Tabs
                          const Row(
                            children: [
                              Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 5.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 5.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 5.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Archived',
                                style: TextStyle(
                                  fontSize: 5.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Table Header
                          const Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Team',
                                  style: TextStyle(
                                    fontSize: 5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Due Date',
                                  style: TextStyle(
                                    fontSize: 5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFF1F2937),
                            height: 4,
                            thickness: 0.5,
                          ),

                          // Table Rows
                          Expanded(
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                _buildDarkTableRow(
                                  'Website Redesign',
                                  0.8,
                                  const Color(0xFF6366F1),
                                  '80%',
                                  'Sep 12, 2026',
                                ),
                                _buildDarkTableRow(
                                  'Mobile App',
                                  0.6,
                                  const Color(0xFF3B82F6),
                                  '60%',
                                  'Sep 18, 2026',
                                ),
                                _buildDarkTableRow(
                                  'Marketing',
                                  0.4,
                                  const Color(0xFFF59E0B),
                                  '40%',
                                  'Sep 22, 2026',
                                ),
                                _buildDarkTableRow(
                                  'CRM Integration',
                                  0.9,
                                  const Color(0xFF10B981),
                                  '90%',
                                  'Oct 03, 2026',
                                ),
                                _buildDarkTableRow(
                                  'Product Launch',
                                  0.3,
                                  const Color(0xFFEC4899),
                                  '30%',
                                  'Oct 10, 2026',
                                ),
                              ],
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

        // Monitor Stand Arm & Metallic Base
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF475569),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF64748B), Color(0xFF334155)],
            ),
          ),
        ),
        Container(
          width: 70,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF64748B),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDarkSidebarItem(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1F2937) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: isActive
              ? Border.all(color: const Color(0xFF6366F1), width: 0.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 7,
              color: isActive
                  ? const Color(0xFF818CF8)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkTableRow(
    String name,
    double progress,
    Color color,
    String pct,
    String date,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 5.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1.5),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 2.5,
                      backgroundColor: const Color(0xFF1F2937),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  pct,
                  style: const TextStyle(
                    fontSize: 4.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF97316),
                    shape: BoxShape.circle,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-2, 0),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(fontSize: 5, color: Color(0xFF94A3B8)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. BOTTOM 4-PILLAR TRUST STRIP
  // ==========================================
  Widget _buildBottomTrustStrip(bool isDark, bool isMobile, bool isTablet) {
    final items = [
      _TrustPillarData(
        icon: Icons.sync_rounded,
        title: 'Always in Sync',
        subtitle:
            'Your data stays up to date across all devices, in real time.',
      ),
      _TrustPillarData(
        icon: Icons.shield_outlined,
        title: 'Enterprise Secure',
        subtitle: 'Bank-grade security to keep your data safe and private.',
      ),
      _TrustPillarData(
        icon: Icons.bolt_rounded,
        title: 'Lightning Fast',
        subtitle: 'Optimized for performance on every device.',
      ),
      _TrustPillarData(
        icon: Icons.groups_outlined,
        title: 'Work from Anywhere',
        subtitle: 'Access your workspace anytime, anywhere.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 20 : 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _buildTrustPillarItem(item, isDark),
                );
              }).toList(),
            )
          : isTablet
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 24,
                mainAxisSpacing: 20,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _buildTrustPillarItem(items[index], isDark),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildTrustPillarItem(item, isDark),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildTrustPillarItem(_TrustPillarData item, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF241D49) : const Color(0xFFF3F0FF),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF4C1D95) : const Color(0xFFDDD6FE),
              width: 1,
            ),
          ),
          child: Icon(item.icon, size: 22, color: const Color(0xFF7C3AED)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustPillarData {
  final IconData icon;
  final String title;
  final String subtitle;

  _TrustPillarData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ==========================================
// CUSTOM PAINTERS FOR CALLOUT ARROWS
// ==========================================
enum ArrowDirection { downRight, downLeft }

class _CurvedCalloutArrowPainter extends CustomPainter {
  final Color color;
  final ArrowDirection direction;

  _CurvedCalloutArrowPainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (direction == ArrowDirection.downRight) {
      path.moveTo(4, 2);
      path.quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.8,
        size.width - 6,
        size.height - 4,
      );
    } else {
      path.moveTo(size.width - 4, 2);
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.8,
        6,
        size.height - 4,
      );
    }

    canvas.drawPath(path, paint);

    // Arrowhead
    final headPaint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (direction == ArrowDirection.downRight) {
      final endX = size.width - 6;
      final endY = size.height - 4;
      canvas.drawLine(
        Offset(endX, endY),
        Offset(endX - 7, endY - 3),
        headPaint,
      );
      canvas.drawLine(
        Offset(endX, endY),
        Offset(endX - 3, endY - 7),
        headPaint,
      );
    } else {
      final endX = 6.0;
      final endY = size.height - 4;
      canvas.drawLine(
        Offset(endX, endY),
        Offset(endX + 7, endY - 3),
        headPaint,
      );
      canvas.drawLine(
        Offset(endX, endY),
        Offset(endX + 3, endY - 7),
        headPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedCalloutArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.direction != direction;
}

class _HandDrawnArrowPainter extends CustomPainter {
  final Color color;
  final bool isPointingDown;

  _HandDrawnArrowPainter({required this.color, required this.isPointingDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(4, 4);
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width * 0.8,
      size.height * 0.6,
      size.width * 0.5,
      size.height - 4,
    );

    canvas.drawPath(path, paint);

    // Arrowhead
    final end = Offset(size.width * 0.5, size.height - 4);
    canvas.drawLine(end, Offset(end.dx - 6, end.dy - 6), paint);
    canvas.drawLine(end, Offset(end.dx + 4, end.dy - 7), paint);
  }

  @override
  bool shouldRepaint(covariant _HandDrawnArrowPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.isPointingDown != isPointingDown;
}
