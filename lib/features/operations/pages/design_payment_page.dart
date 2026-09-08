import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/operations_mock_data.dart';
import '../models/operations_models.dart';

class DesignPaymentPage extends StatefulWidget {
  const DesignPaymentPage({super.key});

  @override
  State<DesignPaymentPage> createState() => _DesignPaymentPageState();
}

class _DesignPaymentPageState extends State<DesignPaymentPage> {
  late List<DesignPaymentMilestone> _milestones;
  PaymentLinkStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _milestones = List.from(OperationsMockData.designMilestones);
  }

  List<DesignPaymentMilestone> get _filteredMilestones {
    if (_statusFilter == null) return _milestones;
    return _milestones.where((m) => m.status == _statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalValue = _milestones.fold<double>(0, (sum, m) => sum + m.totalAmount);
    final totalCollected = _milestones
        .where((m) => m.status == PaymentLinkStatus.paid || m.status == PaymentLinkStatus.disbursed)
        .fold<double>(0, (sum, m) => sum + m.totalAmount);
    final totalPending = _milestones
        .where((m) => m.status == PaymentLinkStatus.pending)
        .fold<double>(0, (sum, m) => sum + m.totalAmount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Metrics Cards
                _buildMetricsBar(isDark, isMobile, totalValue, totalCollected, totalPending),

                const SizedBox(height: 24),

                // 3. Filter Bar
                _buildFilterBar(isDark),

                const SizedBox(height: 16),

                // 4. Milestones List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredMilestones.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _buildMilestoneCard(context, _filteredMilestones[index], isDark, isMobile);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1435), const Color(0xFF131127), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF5F3FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 6),
                    Text(
                      'DESIGN MILESTONE DISPATCHES',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showNewMilestoneDialog(context),
                icon: const Icon(Icons.add_link_rounded, size: 16),
                label: Text(
                  'Generate Payment Link',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Design Milestone Payment Links & WhatsApp Billing',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Instant branded invoice links generated per design phase (2D Concept 20%, 3D Photorealism 30%, GFC 50%) dispatched directly via WhatsApp Cloud API.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsBar(bool isDark, bool isMobile, double total, double collected, double pending) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 24) / 3 : double.infinity;

        final items = [
          (label: 'Total Design Billed', amount: '₹${(total / 100000).toStringAsFixed(2)} L', count: '${_milestones.length} Invoices', color: const Color(0xFF6366F1), icon: Icons.receipt_long_rounded),
          (label: 'Total Collected & Cleared', amount: '₹${(collected / 100000).toStringAsFixed(2)} L', count: '${_milestones.where((m) => m.status != PaymentLinkStatus.pending).length} Settled', color: const Color(0xFF10B981), icon: Icons.check_circle_rounded),
          (label: 'Awaiting Client Payment', amount: '₹${(pending / 1000).toInt()} K', count: '${_milestones.where((m) => m.status == PaymentLinkStatus.pending).length} Pending', color: const Color(0xFFF59E0B), icon: Icons.pending_actions_rounded),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 22, color: item.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                item.amount,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.count,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: item.color),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Row(
      children: [
        Text(
          'Filter by Status: ',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        _buildFilterChip('All (${_milestones.length})', null, isDark),
        const SizedBox(width: 6),
        _buildFilterChip('Pending', PaymentLinkStatus.pending, isDark),
        const SizedBox(width: 6),
        _buildFilterChip('Paid', PaymentLinkStatus.paid, isDark),
        const SizedBox(width: 6),
        _buildFilterChip('Disbursed', PaymentLinkStatus.disbursed, isDark),
      ],
    );
  }

  Widget _buildFilterChip(String label, PaymentLinkStatus? status, bool isDark) {
    final isSelected = _statusFilter == status;
    return InkWell(
      onTap: () => setState(() => _statusFilter = status),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, DesignPaymentMilestone m, bool isDark, bool isMobile) {
    Color statusColor;
    String statusText;
    switch (m.status) {
      case PaymentLinkStatus.pending:
        statusColor = const Color(0xFFF59E0B);
        statusText = 'AWAITING PAYMENT';
        break;
      case PaymentLinkStatus.paid:
        statusColor = const Color(0xFF10B981);
        statusText = 'CLEARED VIA PG';
        break;
      case PaymentLinkStatus.disbursed:
        statusColor = const Color(0xFF8B5CF6);
        statusText = 'DISBURSED TO DESIGNER';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        m.invoiceNumber ?? m.id,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF6366F1)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        m.projectTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Phase Title
          Text(
            m.phaseTitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),

          // Client Details & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client: ${m.clientName} (${m.clientPhone})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Generated: ${_formatDate(m.generatedDate)}${m.paidDate != null ? ' • Paid: ${_formatDate(m.paidDate!)}' : ''}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${m.totalAmount.toInt()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'Base: ₹${m.baseAmount.toInt()} + 18% GST',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.link_rounded, size: 16, color: Color(0xFF6366F1)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    m.paymentLinkUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF6366F1), fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                if (m.status == PaymentLinkStatus.pending) ...[
                  FilledButton.icon(
                    onPressed: () => _simulatePaymentWebhook(m),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 13),
                    label: Text('Simulate Paid', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                FilledButton.icon(
                  onPressed: () => _sendWhatsAppInvoice(m),
                  icon: const Icon(Icons.send_rounded, size: 13),
                  label: Text('WhatsApp Link', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePaymentWebhook(DesignPaymentMilestone m) {
    setState(() {
      final index = _milestones.indexWhere((item) => item.id == m.id);
      if (index != -1) {
        _milestones[index] = m.copyWith(
          status: PaymentLinkStatus.paid,
          paidDate: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment webhook received! ₹${m.totalAmount.toInt()} marked as PAID for ${m.projectTitle}.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _sendWhatsAppInvoice(DesignPaymentMilestone m) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice & payment link dispatched to ${m.clientName} (${m.clientPhone}) via WhatsApp Cloud API!'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  void _showNewMilestoneDialog(BuildContext context) {
    final projectCtrl = TextEditingController(text: 'DLF Magnolias #402');
    final clientCtrl = TextEditingController(text: 'Rajeev Singhania');
    final phoneCtrl = TextEditingController(text: '+91 98101 22910');
    final amountCtrl = TextEditingController(text: '75000');
    String selectedPhase = 'Phase 2: 3D Photorealistic 4K Walkthrough Renders (30%)';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Generate Design Payment Link', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: projectCtrl, decoration: const InputDecoration(labelText: 'Project Name')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: clientCtrl, decoration: const InputDecoration(labelText: 'Client Name'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'WhatsApp Phone'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPhase,
                    decoration: const InputDecoration(labelText: 'Design Phase Milestone'),
                    items: [
                      'Phase 1: 2D Spatial CAD Layouts & Floor Zoning (20%)',
                      'Phase 2: 3D Photorealistic 4K Walkthrough Renders (30%)',
                      'Phase 3: GFC (Good-For-Construction) Working Drawings (50%)',
                      'Turnkey Luxury Architectural Consulting Retainer',
                    ].map((p) => DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.plusJakartaSans(fontSize: 12)))).toList(),
                    onChanged: (val) {
                      if (val != null) selectedPhase = val;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Base Amount in ₹ (Excl. 18% GST)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final base = double.tryParse(amountCtrl.text) ?? 50000;
                setState(() {
                  _milestones.insert(
                    0,
                    DesignPaymentMilestone(
                      id: 'DPM-${106 + _milestones.length}',
                      projectTitle: projectCtrl.text,
                      clientName: clientCtrl.text,
                      clientPhone: phoneCtrl.text,
                      phaseTitle: selectedPhase,
                      baseAmount: base,
                      status: PaymentLinkStatus.pending,
                      paymentLinkUrl: 'https://pay.homio.in/design/LINK-${DateTime.now().millisecondsSinceEpoch % 10000}',
                      generatedDate: DateTime.now(),
                      invoiceNumber: 'HOM-DES-2026-0${100 + _milestones.length}',
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment link generated and ready for WhatsApp dispatch!')),
                );
              },
              child: const Text('Generate Link'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
