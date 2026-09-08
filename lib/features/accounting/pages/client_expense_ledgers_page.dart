import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/accounting_mock_data.dart';
import '../models/accounting_models.dart';

class ClientExpenseLedgersPage extends StatefulWidget {
  const ClientExpenseLedgersPage({super.key});

  @override
  State<ClientExpenseLedgersPage> createState() => _ClientExpenseLedgersPageState();
}

class _ClientExpenseLedgersPageState extends State<ClientExpenseLedgersPage> {
  late List<LedgerTransaction> _transactions;
  LedgerCategory? _categoryFilter;
  TransactionPaymentStatus? _statusFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _transactions = List.from(AccountingMockData.transactions);
  }

  List<LedgerTransaction> get _filteredTransactions {
    return _transactions.where((t) {
      if (_categoryFilter != null && t.category != _categoryFilter) return false;
      if (_statusFilter != null && t.paymentStatus != _statusFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = t.payeeOrVendor.toLowerCase().contains(q) ||
            t.clientName.toLowerCase().contains(q) ||
            t.voucherNo.toLowerCase().contains(q) ||
            t.remarks.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalCommission = _transactions.fold<double>(0, (sum, t) => sum + t.commissionEarned);
    final totalMaterial = _transactions
        .where((t) => t.category == LedgerCategory.material)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final totalLabour = _transactions
        .where((t) => t.category == LedgerCategory.labour)
        .fold<double>(0, (sum, t) => sum + t.amount);

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
                // 1. Header Banner
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Metrics Bar
                _buildMetricsBar(isDark, isMobile, totalCommission, totalMaterial, totalLabour),

                const SizedBox(height: 24),

                // 3. Filter & Search Controls
                _buildFilterControls(isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Ledger Data Table / List
                _buildLedgerView(context, isDark, isMobile),

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
              : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF), Colors.white],
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
                    const Icon(Icons.receipt_long_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 6),
                    Text(
                      'COMMISSION & EXPENSE LEDGERS',
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
                onPressed: () => _showAddTransactionDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Record Transaction',
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
            'Client Expense Ledgers & Vendor Commissions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Itemized records for every site transaction: Material purchases, trade contractor labour payouts, paid vs unpaid dues status, and vendor kickback commission tracking.',
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

  Widget _buildMetricsBar(bool isDark, bool isMobile, double commission, double material, double labour) {
    final items = [
      (label: 'Total Commissions Realized', value: '₹${commission.toInt()}', sub: 'Earned from wholesale suppliers', color: const Color(0xFF10B981), icon: Icons.monetization_on_rounded),
      (label: 'Material Procurement Spend', value: '₹${(material / 100000).toStringAsFixed(2)} L', sub: 'Across verified suppliers', color: const Color(0xFF3B82F6), icon: Icons.inventory_2_rounded),
      (label: 'Trade Labour Disbursements', value: '₹${(labour / 1000).toInt()} K', sub: 'Carpenters, Masons, MEP', color: const Color(0xFFF59E0B), icon: Icons.handyman_rounded),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 24) / 3 : double.infinity;

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
                          Text(
                            item.value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.sub,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item.color,
                            ),
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

  Widget _buildFilterControls(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search voucher #, payee, vendor, or client...',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<TransactionPaymentStatus?>(
                value: _statusFilter,
                underline: const SizedBox(),
                hint: Text('All Payment Status', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: [
                  DropdownMenuItem(value: null, child: Text('All Statuses', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: TransactionPaymentStatus.paid, child: Text('Paid', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: TransactionPaymentStatus.partial, child: Text('Partial', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: TransactionPaymentStatus.unpaid, child: Text('Unpaid', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                ],
                onChanged: (val) => setState(() => _statusFilter = val),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category Pills
          Row(
            children: [
              _buildCategoryChip('All Transactions', null, isDark),
              const SizedBox(width: 8),
              _buildCategoryChip('Material Bills', LedgerCategory.material, isDark),
              const SizedBox(width: 8),
              _buildCategoryChip('Labour Payouts', LedgerCategory.labour, isDark),
              const SizedBox(width: 8),
              _buildCategoryChip('Supervision Fees', LedgerCategory.supervisionFee, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, LedgerCategory? cat, bool isDark) {
    final isSelected = _categoryFilter == cat;
    return InkWell(
      onTap: () => setState(() => _categoryFilter = cat),
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

  Widget _buildLedgerView(BuildContext context, bool isDark, bool isMobile) {
    if (_filteredTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.md,
        ),
        child: Text(
          'No matching transactions found.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF94A3B8)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredTransactions.length,
        separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        itemBuilder: (context, index) {
          final t = _filteredTransactions[index];

          Color statusColor;
          String statusLabel;
          switch (t.paymentStatus) {
            case TransactionPaymentStatus.paid:
              statusColor = const Color(0xFF10B981);
              statusLabel = 'PAID';
              break;
            case TransactionPaymentStatus.partial:
              statusColor = const Color(0xFFF59E0B);
              statusLabel = 'PARTIAL';
              break;
            case TransactionPaymentStatus.unpaid:
              statusColor = const Color(0xFFEF4444);
              statusLabel = 'UNPAID';
              break;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (t.category == LedgerCategory.material
                            ? const Color(0xFF3B82F6)
                            : t.category == LedgerCategory.labour
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF8B5CF6))
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    t.category == LedgerCategory.material
                        ? Icons.inventory_2_rounded
                        : t.category == LedgerCategory.labour
                            ? Icons.handyman_rounded
                            : Icons.architecture_rounded,
                    size: 20,
                    color: t.category == LedgerCategory.material
                        ? const Color(0xFF3B82F6)
                        : t.category == LedgerCategory.labour
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            t.voucherNo,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  ${_formatDate(t.date)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
                              statusLabel,
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.payeeOrVendor,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Project: ${t.projectTitle} (${t.clientName})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.remarks,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${t.amount.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+₹${t.commissionEarned.toInt()} Commission (${t.commissionRatePercent}%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final voucherCtrl = TextEditingController(text: 'VCH-2026-0817');
    final payeeCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final clientCtrl = TextEditingController(text: 'Rajeev Singhania');
    final projectCtrl = TextEditingController(text: 'DLF Magnolias #402');
    final remarksCtrl = TextEditingController();
    final commRateCtrl = TextEditingController(text: '6.0');
    LedgerCategory selectedCat = LedgerCategory.material;
    TransactionPaymentStatus selectedStatus = TransactionPaymentStatus.paid;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Record Transaction & Commission', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: TextField(controller: voucherCtrl, decoration: const InputDecoration(labelText: 'Voucher Number'))),
                          const SizedBox(width: 12),
                          Expanded(child: TextField(controller: payeeCtrl, decoration: const InputDecoration(labelText: 'Payee / Supplier Name'))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: amountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Invoice Amount (₹)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: commRateCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Commission Rate (%)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: clientCtrl, decoration: const InputDecoration(labelText: 'Client Name'))),
                          const SizedBox(width: 12),
                          Expanded(child: TextField(controller: projectCtrl, decoration: const InputDecoration(labelText: 'Project Name'))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: remarksCtrl, decoration: const InputDecoration(labelText: 'Transaction Remarks & Scope')),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    final amt = double.tryParse(amountCtrl.text) ?? 10000;
                    final rate = double.tryParse(commRateCtrl.text) ?? 5.0;
                    final comm = amt * (rate / 100);

                    setState(() {
                      _transactions.insert(
                        0,
                        LedgerTransaction(
                          id: 'TXN-${907 + _transactions.length}',
                          voucherNo: voucherCtrl.text,
                          date: DateTime.now(),
                          clientName: clientCtrl.text,
                          projectTitle: projectCtrl.text,
                          category: selectedCat,
                          payeeOrVendor: payeeCtrl.text.isNotEmpty ? payeeCtrl.text : 'Verified Material Supplier',
                          amount: amt,
                          paymentStatus: selectedStatus,
                          commissionRatePercent: rate,
                          commissionEarned: comm,
                          remarks: remarksCtrl.text.isNotEmpty ? remarksCtrl.text : 'Procurement bill recorded',
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction recorded! ₹${comm.toInt()} commission accrued.')),
                    );
                  },
                  child: const Text('Save Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
