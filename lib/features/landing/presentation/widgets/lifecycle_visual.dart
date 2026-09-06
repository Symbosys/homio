import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

/// The Complete Business Lifecycle & Continuous Operational Foundation section.
/// Matches the exact desktop and mobile mockups with pixel-perfect precision.
class LifecycleVisual extends StatelessWidget {
  const LifecycleVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 72),
      child: AdaptiveContainer(
        child: Column(
          children: [
            // Top Badge: ∞ END-TO-END BUSINESS CONTINUUM
            _buildTopBadge(isDark),

            const SizedBox(height: 18),

            // Section Headline: The Complete Business Lifecycle
            _buildHeadline(isDark, isMobile),

            const SizedBox(height: 14),

            // Subtitle Description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'Homio connects every stage from initial prospect inquiry to site completion,\nclient handover, and executive intelligence.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 13.5 : 15.5,
                  height: 1.6,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 38),

            // Main Flow Card: Horizontal on desktop, Vertical Timeline on mobile
            isMobile
                ? _buildMobileFlowCard(context, isDark)
                : _buildDesktopFlowCard(context, isDark),

            const SizedBox(height: 20),

            // Bottom Foundation Card: Continuous Operational Foundation
            _buildOperationalFoundationCard(context, isDark, isMobile),
          ],
        ),
      ),
    );
  }

  /// Pill badge with infinity icon
  Widget _buildTopBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6.5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.6) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? const Color(0xFF3730A3) : const Color(0xFFE0E7FF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.all_inclusive_rounded,
            size: 16,
            color: Color(0xFF4F46E5),
          ),
          const SizedBox(width: 8),
          Text(
            'END-TO-END BUSINESS CONTINUUM',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: const Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  /// Two-tone headline
  Widget _buildHeadline(bool isDark, bool isMobile) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: isMobile ? 26 : 42,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        children: [
          TextSpan(
            text: 'The Complete ',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const TextSpan(
            text: 'Business Lifecycle',
            style: TextStyle(
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  // Stages Dataset
  List<_StageData> _getStages() {
    return [
      _StageData(
        number: '01',
        title: 'Leads',
        description: 'Capture, qualify &\nnurture potential\nopportunities.',
        color: const Color(0xFF7C3AED),
        bgColor: const Color(0xFFF5F3FF),
        borderColor: const Color(0xFFDDD6FE),
        icon: Icons.people_outline_rounded,
      ),
      _StageData(
        number: '02',
        title: 'Sales',
        description: 'Convert leads into\nvaluable customers\nwith confidence.',
        color: const Color(0xFF10B981),
        bgColor: const Color(0xFFECFDF5),
        borderColor: const Color(0xFFA7F3D0),
        icon: Icons.trending_up_rounded,
      ),
      _StageData(
        number: '03',
        title: 'Quotations',
        description: 'Create accurate,\nprofessional quotes\nthat win deals.',
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFFFBEB),
        borderColor: const Color(0xFFFDE68A),
        icon: Icons.description_outlined,
      ),
      _StageData(
        number: '04',
        title: 'Site Execution',
        description: 'Plan, track & execute\nprojects with clarity\nand control.',
        color: const Color(0xFF6366F1),
        bgColor: const Color(0xFFEEF2FF),
        borderColor: const Color(0xFFC7D2FE),
        isCrane: true,
      ),
      _StageData(
        number: '05',
        title: 'Payments',
        description: 'Automate billing,\ntrack payments &\nensure cash flow.',
        color: const Color(0xFF059669),
        bgColor: const Color(0xFFF0FDF4),
        borderColor: const Color(0xFFBBF7D0),
        icon: Icons.account_balance_wallet_outlined,
      ),
      _StageData(
        number: '06',
        title: 'Handover',
        description: 'Deliver with quality\nand complete\nclient handover.',
        color: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
        borderColor: const Color(0xFFBFDBFE),
        icon: Icons.handshake_outlined,
      ),
      _StageData(
        number: '07',
        title: 'Intelligence',
        description: 'Gain insights & make\nsmarter decisions\nwith real-time data.',
        color: const Color(0xFFDB2777),
        bgColor: const Color(0xFFFDF2F8),
        borderColor: const Color(0xFFFBCFE8),
        icon: Icons.psychology_outlined,
      ),
    ];
  }

  /// DESKTOP / TABLET FLOW CARD (Horizontal)
  Widget _buildDesktopFlowCard(BuildContext context, bool isDark) {
    final stages = _getStages();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Background connecting dashed line & soft wave line
            Positioned.fill(
              child: CustomPaint(
                painter: _DesktopConnectingLinePainter(isDark: isDark),
              ),
            ),

            // Horizontal Stages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final fitsInRow = constraints.maxWidth >= 1050;

                  Widget flowRow = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < stages.length; i++) ...[
                        Expanded(
                          child: _buildDesktopStageItem(stages[i], isDark),
                        ),
                        if (i < stages.length - 1)
                          _buildConnectorChevron(isDark),
                      ],
                    ],
                  );

                  if (fitsInRow) {
                    return flowRow;
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 1080),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < stages.length; i++) ...[
                            SizedBox(
                              width: 125,
                              child: _buildDesktopStageItem(stages[i], isDark),
                            ),
                            if (i < stages.length - 1)
                              _buildConnectorChevron(isDark),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// MOBILE FLOW CARD (Vertical Timeline matching exact mockup)
  Widget _buildMobileFlowCard(BuildContext context, bool isDark) {
    final stages = _getStages();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Vertical Timeline with connected colored dots
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 12),
            child: Column(
              children: [
                for (int i = 0; i < stages.length; i++) ...[
                  // Bullet dot centered on the card height
                  SizedBox(
                    height: 56,
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: stages[i].color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  if (i < stages.length - 1)
                    SizedBox(
                      height: 10,
                      width: 2,
                      child: CustomPaint(
                        painter: _DashedVerticalLinePainter(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // Right Column with 7 Stage Cards
          Expanded(
            child: Column(
              children: [
                for (int i = 0; i < stages.length; i++) ...[
                  _buildMobileStageCard(stages[i], isDark),
                  if (i < stages.length - 1)
                    const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile Individual Stage Card (e.g. [Icon] 01. Leads >)
  Widget _buildMobileStageCard(_StageData stage, bool isDark) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Stage Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? stage.color.withValues(alpha: 0.18) : stage.bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: stage.isCrane
                  ? _CraneIcon(color: stage.color, size: 20)
                  : Icon(
                      stage.icon,
                      size: 20,
                      color: stage.color,
                    ),
            ),
          ),
          const SizedBox(width: 14),

          // Number & Title
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${stage.number}.  ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: stage.color,
                  ),
                ),
                TextSpan(
                  text: stage.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Chevron Right Icon
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }

  /// Desktop Stage Column Item
  Widget _buildDesktopStageItem(_StageData stage, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular Icon Badge
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? stage.color.withValues(alpha: 0.15) : stage.bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? stage.color.withValues(alpha: 0.4) : stage.borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: stage.color.withValues(alpha: isDark ? 0.25 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: stage.isCrane
                ? _CraneIcon(color: stage.color, size: 26)
                : Icon(
                    stage.icon,
                    size: 26,
                    color: stage.color,
                  ),
          ),
        ),

        const SizedBox(height: 12),

        // Stage Number
        Text(
          stage.number,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: stage.color,
          ),
        ),

        const SizedBox(height: 2),

        // Stage Title
        Text(
          stage.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 6),

        // Stage Description
        Text(
          stage.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            height: 1.45,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// Small circular chevron indicator between stages on desktop
  Widget _buildConnectorChevron(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 22, left: 2, right: 2),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 13,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      ),
    );
  }

  /// Bottom Foundation Card
  Widget _buildOperationalFoundationCard(BuildContext context, bool isDark, bool isMobile) {
    final foundations = [
      _FoundationData(
        title: 'WhatsApp Cloud\nAutomation',
        description: 'Automate conversations\n& engage instantly.',
        icon: Icons.chat_bubble_outline_rounded,
        color: const Color(0xFF6366F1),
        bgColor: const Color(0xFFEEF2FF),
      ),
      _FoundationData(
        title: 'Real-Time\nAI Copilot',
        description: 'Smart suggestions &\nassistance in real-time.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFEC4899),
        bgColor: const Color(0xFFFDF2F8),
      ),
      _FoundationData(
        title: 'Team Hierarchy &\nAttendance',
        description: 'Manage teams, roles &\ntrack attendance easily.',
        icon: Icons.groups_outlined,
        color: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
      ),
      _FoundationData(
        title: 'Vendor & Material\nLedgers',
        description: 'Track vendors, materials\n& maintain ledgers.',
        icon: Icons.description_outlined,
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFFFBEB),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 18 : 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header divider with centered text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.published_with_changes_rounded,
                      size: 14,
                      color: Color(0xFF4F46E5),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'CONTINUOUS OPERATIONAL FOUNDATION',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 9.5 : 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  thickness: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 4 Foundation Cards (2x2 on mobile, 4-in-a-row on desktop)
          if (isMobile)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildFoundationCard(foundations[0], isDark, isMobile)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildFoundationCard(foundations[1], isDark, isMobile)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildFoundationCard(foundations[2], isDark, isMobile)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildFoundationCard(foundations[3], isDark, isMobile)),
                  ],
                ),
              ],
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 960;

                if (isDesktop) {
                  return Row(
                    children: [
                      for (int i = 0; i < foundations.length; i++) ...[
                        Expanded(
                          child: _buildFoundationCard(foundations[i], isDark, false),
                        ),
                        if (i < foundations.length - 1)
                          const SizedBox(width: 14),
                      ],
                    ],
                  );
                }

                // Tablet 2x2
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildFoundationCard(foundations[0], isDark, false)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildFoundationCard(foundations[1], isDark, false)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFoundationCard(foundations[2], isDark, false)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildFoundationCard(foundations[3], isDark, false)),
                      ],
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  /// Individual Foundation Card
  Widget _buildFoundationCard(_FoundationData data, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 16,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Icon Squircle
          Container(
            width: isMobile ? 36 : 44,
            height: isMobile ? 36 : 44,
            decoration: BoxDecoration(
              color: isDark ? data.color.withValues(alpha: 0.15) : data.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              data.icon,
              size: isMobile ? 18 : 22,
              color: data.color,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 14),

          // Text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 11 : 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 9.5 : 11,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
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

/// Helper model for the 7 stages
class _StageData {
  _StageData({
    required this.number,
    required this.title,
    required this.description,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    this.icon = Icons.circle,
    this.isCrane = false,
  });

  final String number;
  final String title;
  final String description;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final IconData icon;
  final bool isCrane;
}

/// Helper model for the 4 foundations
class _FoundationData {
  _FoundationData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
}

/// Custom Vector Painter for Site Execution Tower Crane
class _CraneIcon extends StatelessWidget {
  const _CraneIcon({required this.color, this.size = 26});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CranePainter(color: color),
      ),
    );
  }
}

class _CranePainter extends CustomPainter {
  _CranePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Vertical Mast
    canvas.drawLine(Offset(w * 0.38, h * 0.92), Offset(w * 0.38, h * 0.28), strokePaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.92), Offset(w * 0.50, h * 0.28), strokePaint);
    // Mast cross braces
    canvas.drawLine(Offset(w * 0.38, h * 0.76), Offset(w * 0.50, h * 0.62), strokePaint);
    canvas.drawLine(Offset(w * 0.38, h * 0.48), Offset(w * 0.50, h * 0.34), strokePaint);

    // Horizontal Jib / Boom
    canvas.drawLine(Offset(w * 0.12, h * 0.28), Offset(w * 0.88, h * 0.28), strokePaint);

    // Tower Apex Peak
    canvas.drawLine(Offset(w * 0.38, h * 0.28), Offset(w * 0.44, h * 0.10), strokePaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.28), Offset(w * 0.44, h * 0.10), strokePaint);

    // Stay cables from apex
    canvas.drawLine(Offset(w * 0.44, h * 0.10), Offset(w * 0.18, h * 0.28), strokePaint);
    canvas.drawLine(Offset(w * 0.44, h * 0.10), Offset(w * 0.74, h * 0.28), strokePaint);

    // Counterweight at rear
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.28, w * 0.12, h * 0.14),
        const Radius.circular(2),
      ),
      fillPaint,
    );

    // Trolley & Hanging Hook Line
    canvas.drawLine(Offset(w * 0.72, h * 0.28), Offset(w * 0.72, h * 0.62), strokePaint);
    // Hook block
    canvas.drawCircle(Offset(w * 0.72, h * 0.66), 2.2, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _CranePainter oldDelegate) => oldDelegate.color != color;
}

/// Desktop background connecting line (smooth connecting wave line running across the circles)
class _DesktopConnectingLinePainter extends CustomPainter {
  _DesktopConnectingLinePainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    // Single clean connecting horizontal dashed line behind the circles
    final dashPaint = Paint()
      ..color = (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double x = 40;
    while (x < w - 40) {
      canvas.drawLine(Offset(x, 66), Offset(x + 4, 66), dashPaint);
      x += 8;
    }
  }

  @override
  bool shouldRepaint(covariant _DesktopConnectingLinePainter oldDelegate) => oldDelegate.isDark != isDark;
}

/// Vertical dashed line for mobile timeline
class _DashedVerticalLinePainter extends CustomPainter {
  _DashedVerticalLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(size.width / 2, y), Offset(size.width / 2, y + 2.5), paint);
      y += 5.5;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
