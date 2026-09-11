import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/theme_controller.dart';

class FinanceWorkforceSection extends StatelessWidget {
  const FinanceWorkforceSection({super.key});

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
                color: isDark ? const Color(0xFF10B981).withValues(alpha: 0.15) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF10B981).withValues(alpha: 0.5) : const Color(0xFFA7F3D0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 14, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Text(
                    'FINANCE, PROCUREMENT & WORKFORCE MANAGEMENT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Heading
            Text(
              'Control the Business Behind Every Project',
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
                'Protect project profitability with end-to-end commercial transparency: from automated supplier quotations and tax ledgers to verified field workforce attendance.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 44),

            // 1. Accounting Metrics Ribbon
            LayoutBuilder(
              builder: (context, box) {
                final isStacked = box.maxWidth < 750;
                final items = [
                  _FinanceMetric(title: 'Active Turnkey Revenue', value: '\$2,840,000', sub: '+24% YoY Growth', isDark: isDark),
                  _FinanceMetric(title: 'Receivables Outstanding', value: '\$340,000', sub: '3 Milestones Pending', isDark: isDark),
                  _FinanceMetric(title: 'Supplier Payables', value: '\$184,200', sub: '12 Vendors Verified', isDark: isDark),
                  _FinanceMetric(title: 'Net Project Margin', value: '28.4%', sub: '+3.2% vs Industry Avg', isDark: isDark, isGreen: true),
                ];

                if (isStacked) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: items.map((w) => SizedBox(width: (box.maxWidth - 12) / 2, child: w)).toList(),
                  );
                }

                return Row(
                  children: items.map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: w))).toList(),
                );
              },
            ),

            const SizedBox(height: 36),

            // 2. Side-by-Side: Customer Ledger & Procurement Comparison Table
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 920;

                final ledgerCard = _CustomerLedgerMockup(isDark: isDark);
                final procurementCard = _ProcurementComparisonMockup(isDark: isDark);

                if (isStacked) {
                  return Column(
                    children: [
                      ledgerCard,
                      const SizedBox(height: 24),
                      procurementCard,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: ledgerCard),
                    const SizedBox(width: 24),
                    Expanded(flex: 6, child: procurementCard),
                  ],
                );
              },
            ),

            const SizedBox(height: 36),

            // 3. Labour, KYC & HR Field Operations Grid
            _LabourAndFieldOpsMockup(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _FinanceMetric extends StatelessWidget {
  const _FinanceMetric({
    required this.title,
    required this.value,
    required this.sub,
    required this.isDark,
    this.isGreen = false,
  });

  final String title;
  final String value;
  final String sub;
  final bool isDark;
  final bool isGreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isGreen
                  ? const Color(0xFF10B981)
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isGreen
                  ? const Color(0xFF10B981)
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerLedgerMockup extends StatelessWidget {
  const _CustomerLedgerMockup({required this.isDark});

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
                'Live Customer Project Ledger',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'AUDITED',
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

          _ledgerRow('Opening Balance', '\$0.00', isDark),
          _ledgerRow('Invoices Issued (4 Milestones)', '\$114,400.00', isDark),
          _ledgerRow('Payments Collected & Cleared', '\$82,000.00', isDark, isGreen: true),
          _ledgerRow('Approved Variations (Italian Fixtures)', '+\$2,800.00', isDark),
          _ledgerRow('Adjustments / Retentions Held', '-\$1,200.00', isDark),

          const SizedBox(height: 14),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Outstanding Balance',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
              Text(
                '\$34,000.00',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _ledgerRow(String label, String amount, bool isDark, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isGreen
                  ? const Color(0xFF10B981)
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcurementComparisonMockup extends StatelessWidget {
  const _ProcurementComparisonMockup({required this.isDark});

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
                'Procurement & Multi-Vendor RFQ Matrix',
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
                  'VENDOR 1 WON',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'Material: Italian Travertine Slabs (1,400 Sq.Ft Requirement)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 16),

          // Vendor Comparison Rows
          _vendorRow('Verona Marmi SpA (Winner)', '\$34.50/sq.ft', 'Grade A1', '99% Trust', '8 Days Lead', true, isDark),
          const SizedBox(height: 8),
          _vendorRow('Tuscan Stoneworks', '\$38.00/sq.ft', 'Grade A2', '94% Trust', '14 Days Lead', false, isDark),
          const SizedBox(height: 8),
          _vendorRow('Carrara Direct Imports', '\$36.20/sq.ft', 'Grade A1', '91% Trust', '18 Days Lead', false, isDark),

          const SizedBox(height: 16),
          Divider(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.verified_outlined, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'PO #PO-9410 auto-generated & locked with digital warranty escrow',
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

  static Widget _vendorRow(
    String name,
    String rate,
    String quality,
    String trust,
    String lead,
    bool isWinner,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isWinner
            ? (isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWinner
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isWinner ? FontWeight.w700 : FontWeight.w500,
                    color: isWinner
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ),
                Text(
                  '$quality • $trust • $lead',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            rate,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isWinner ? const Color(0xFF10B981) : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabourAndFieldOpsMockup extends StatelessWidget {
  const _LabourAndFieldOpsMockup({required this.isDark});

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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.groups_outlined, color: Color(0xFF0D9488), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Labour, KYC & Field Operations Ecosystem',
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
                  '100% GEOFENCED',
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

          // 4 Sub-Cards for HR & Field Ops
          LayoutBuilder(
            builder: (context, box) {
              final isSmall = box.maxWidth < 700;
              final tiles = [
                _FieldTile(
                  icon: Icons.pin_drop_outlined,
                  title: 'Geofenced Attendance',
                  desc: 'Auto-punch within 50m site perimeter; biometric photo confirmation.',
                  isDark: isDark,
                ),
                _FieldTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Aadhaar / KYC Verified',
                  desc: 'All tradesmen police-verified with digitized skill trade certifications.',
                  isDark: isDark,
                ),
                _FieldTile(
                  icon: Icons.payments_outlined,
                  title: 'Instant Wage Settlement',
                  desc: 'Daily or weekly piece-rate wage calculation linked to work measurement.',
                  isDark: isDark,
                ),
                _FieldTile(
                  icon: Icons.safety_check_outlined,
                  title: 'Field Safety Protocols',
                  desc: 'Daily digital toolbox talks, PPE audit logs, and zero-hazard tracking.',
                  isDark: isDark,
                ),
              ];

              if (isSmall) {
                return Column(children: tiles.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: t)).toList());
              }

              return Row(
                children: tiles.map((t) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: t))).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.title,
    required this.desc,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String desc;
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
          Icon(icon, size: 20, color: const Color(0xFF0D9488)),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              height: 1.4,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
