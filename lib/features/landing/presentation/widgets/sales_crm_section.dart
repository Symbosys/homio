import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class SalesCrmSection extends StatefulWidget {
  const SalesCrmSection({super.key});

  @override
  State<SalesCrmSection> createState() => _SalesCrmSectionState();
}

class _SalesCrmSectionState extends State<SalesCrmSection> {
  int _activeCommTab = 0;

  final List<String> _commChannels = [
    'WhatsApp Client Thread',
    'Internal Design Notes',
    'Automated Broadcasts',
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
                  const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'SALES CRM & CUSTOMER EXPERIENCE',
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
              'Every Customer Conversation, Connected',
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
                'Bring leads, design proposals, WhatsApp conversations, and milestone updates into one coherent view so every team member speaks with total clarity.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 44),

            // Lead Pipeline Funnel Stages
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      Text(
                        'DYNAMIC SALES PIPELINE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        'Total Active Pipeline: \$4.8M',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _PipelineStage(name: 'New Lead', count: '32 Leads', isDark: isDark, color: const Color(0xFF6366F1)),
                        _pipelineArrow(isDark),
                        _PipelineStage(name: 'Qualified', count: '18 Verified', isDark: isDark, color: const Color(0xFF8B5CF6)),
                        _pipelineArrow(isDark),
                        _PipelineStage(name: 'Site Visit', count: '12 Scheduled', isDark: isDark, color: const Color(0xFF06B6D4)),
                        _pipelineArrow(isDark),
                        _PipelineStage(name: 'Quotation', count: '9 Delivered', isDark: isDark, color: const Color(0xFFF59E0B)),
                        _pipelineArrow(isDark),
                        _PipelineStage(name: 'Negotiation', count: '6 Finalizing', isDark: isDark, color: const Color(0xFFEC4899)),
                        _pipelineArrow(isDark),
                        _PipelineStage(name: 'Won & Onboard', count: '14 Executing', isDark: isDark, color: const Color(0xFF10B981)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Side-by-Side: Customer 360 + Communication Hub
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 900;

                final leftProfile = _Customer360Mockup(isDark: isDark);
                final rightComm = _CommunicationHubMockup(
                  isDark: isDark,
                  channels: _commChannels,
                  activeTab: _activeCommTab,
                  onTabChange: (i) => setState(() => _activeCommTab = i),
                );

                if (isStacked) {
                  return Column(
                    children: [
                      leftProfile,
                      const SizedBox(height: 24),
                      rightComm,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: leftProfile),
                    const SizedBox(width: 24),
                    Expanded(flex: 6, child: rightComm),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _pipelineArrow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: isDark ? Colors.white24 : Colors.black26),
    );
  }
}

class _PipelineStage extends StatelessWidget {
  const _PipelineStage({
    required this.name,
    required this.count,
    required this.isDark,
    required this.color,
  });

  final String name;
  final String count;
  final bool isDark;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            count,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Customer360Mockup extends StatelessWidget {
  const _Customer360Mockup({required this.isDark});

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      'SM',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Siddharth Malhotra',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'The Skyview Penthouse • 4BHK Turnkey Fitout',
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
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CLIENT 360',
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

          _itemRow('Lead Source', 'Private Architect Referral', isDark),
          _itemRow('Quotation #', 'QT-2026-084 • \$114,400 (Locked)', isDark),
          _itemRow('Meetings', '3 In-Person • 4 Virtual 3D Reviews', isDark),
          _itemRow('Assigned Team', 'Ar. Anya Sen (Design) + Rajesh V. (Site PM)', isDark),
          _itemRow('Next Task', 'Marble Slab Dry-Lay Verification (Tomorrow)', isDark),

          const SizedBox(height: 16),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PAYMENT RECOVERY',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '\$82,000 / \$114,400 (71%)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Milestone 4 Pending',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _itemRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
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

class _CommunicationHubMockup extends StatelessWidget {
  const _CommunicationHubMockup({
    required this.isDark,
    required this.channels,
    required this.activeTab,
    required this.onTabChange,
  });

  final bool isDark;
  final List<String> channels;
  final int activeTab;
  final ValueChanged<int> onTabChange;

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
          // Header tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(channels.length, (idx) {
                final isCurrent = activeTab == idx;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onTabChange(idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Text(
                        channels[idx],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent ? AppColors.primary : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 18),

          // Message Previews
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                // Message 1 from Client
                _bubble(
                  sender: 'Dr. Siddharth Malhotra (Client)',
                  message: 'Anya, we love the revised Italian travertine samples from yesterday’s 3D walk! Can we finalize the dining lighting fixture as well?',
                  time: '10:42 AM',
                  isClient: true,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                // Message 2 from Studio
                _bubble(
                  sender: 'Ar. Anya Sen (Studio)',
                  message: 'Wonderful! We locked lot #842 from the HOMIO Marketplace. The Artemide pendant is spec’d in the updated BOQ for your review.',
                  time: '10:45 AM',
                  isClient: false,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                // System Auto-Trigger Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Automated Milestone 3 Invoice Cleared (\$34,200 via Bank Transfer)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Omnichannel Sync: WhatsApp • Email • Client Mobile App',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Connected',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
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

  static Widget _bubble({
    required String sender,
    required String message,
    required String time,
    required bool isClient,
    required bool isDark,
  }) {
    return Align(
      alignment: isClient ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isClient
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : (isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isClient
                ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                : const Color(0xFF818CF8).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: isClient ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sender,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                height: 1.4,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
