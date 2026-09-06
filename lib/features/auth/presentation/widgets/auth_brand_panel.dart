import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';

/// Left-hand brand showcase panel matching the exact high-fidelity SaaS design.
/// Non-scrolling on standard desktop viewports, with identical branding in both themes.
class AuthBrandPanel extends StatelessWidget {
  const AuthBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E144F),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background 3D Illustration aligned right
          Image.asset(
            AppAssets.loginBg,
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),

          // Deep purple gradient overlay for perfect left-side readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF160E3D).withValues(alpha: 0.94),
                  const Color(0xFF22175C).withValues(alpha: 0.72),
                  const Color(0xFF22175C).withValues(alpha: 0.15),
                ],
                stops: const [0.0, 0.52, 1.0],
              ),
            ),
          ),

          // Content Layer
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompactHeight = constraints.maxHeight < 640;

              Widget content = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isCompactHeight
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Header
                    _buildHeaderLogo(),

                    const SizedBox(height: 20),

                    // Headline
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -0.8,
                        ),
                        children: const [
                          TextSpan(
                            text: 'One workspace.\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Every operation.\n',
                            style: TextStyle(color: Color(0xFFC4B5FD)), // Soft Lavender
                          ),
                          TextSpan(
                            text: 'Total control.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subheading
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Text(
                        'Join 1,200+ organizations that run faster, collaborate smarter, and grow stronger with Homio Workspace.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFE0E7FF).withValues(alpha: 0.85),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 3 Feature Bullets
                    _buildFeatureBullet(
                      icon: Icons.shield_outlined,
                      title: 'Enterprise Grade Security',
                      subtitle: 'SOC 2 Type II • 256-bit Encryption',
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureBullet(
                      icon: Icons.bolt_rounded,
                      title: 'Blazing Fast Performance',
                      subtitle: '99.99% Uptime • Global Infrastructure',
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureBullet(
                      icon: Icons.groups_rounded,
                      title: 'Trusted by Industry Leaders',
                      subtitle: 'From startups to Fortune 500 companies',
                    ),

                    const SizedBox(height: 20),

                    // Glassmorphic Metrics Card
                    _buildMetricsCard(),

                    const SizedBox(height: 18),

                    // Security Trust Footer
                    Wrap(
                      spacing: 20,
                      runSpacing: 6,
                      children: const [
                        _TrustBadge(icon: Icons.shield_rounded, text: 'SOC 2 Type II'),
                        _TrustBadge(icon: Icons.lock_rounded, text: '256-bit Encryption'),
                        _TrustBadge(icon: Icons.cloud_done_rounded, text: '99.99% Uptime'),
                      ],
                    ),
                  ],
                ),
              );

              if (isCompactHeight) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: content,
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                child: content,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.layers_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Homio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.7,
                    ),
                  ),
                  child: Text(
                    'WORKSPACE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              'Unified Business OS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFC7D2FE),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureBullet({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 1.5),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFC7D2FE),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Built for results that matter',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCol(
                icon: Icons.account_box_outlined,
                stat: '1,200+',
                label: 'Active\nOrganizations',
              ),
              _buildStatCol(
                icon: Icons.shield_rounded,
                stat: '99.99%',
                label: 'System\nUptime',
              ),
              _buildStatCol(
                icon: Icons.event_note_rounded,
                stat: '2.5M+',
                label: 'Tasks\nAutomated',
              ),
              _buildStatCol(
                icon: Icons.public_rounded,
                stat: '150+',
                label: 'Countries\nServed',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol({
    required IconData icon,
    required String stat,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: const Color(0xFFC7D2FE)),
        const SizedBox(height: 6),
        Text(
          stat,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC7D2FE).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFFC7D2FE).withValues(alpha: 0.8)),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC7D2FE).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
