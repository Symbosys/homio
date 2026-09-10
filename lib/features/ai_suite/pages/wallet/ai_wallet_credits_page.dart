import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/credit_purchase_modal.dart';
import '../../widgets/compact_ai_suite_actions.dart';

class AiWalletCreditsPage extends StatefulWidget {
  const AiWalletCreditsPage({super.key});

  @override
  State<AiWalletCreditsPage> createState() => _AiWalletCreditsPageState();
}

class _AiWalletCreditsPageState extends State<AiWalletCreditsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = AiSuiteRepository.instance;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          return Column(
            children: [
              // Sleek 46px top header bar
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF111827) : Colors.white,
                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Text(
                      'AI Wallet / Credits',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const VerticalDivider(width: 16, indent: 12, endIndent: 12),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF10B981),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF10B981),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                        tabs: [
                          const Tab(icon: Icon(Icons.account_balance_wallet_outlined, size: 15), text: 'Overview'),
                          const Tab(icon: Icon(Icons.add_shopping_cart_rounded, size: 15), text: 'Buy Credits'),
                          Tab(icon: const Icon(Icons.receipt_long_outlined, size: 15), text: 'Transactions (${repo.transactions.length})'),
                          const Tab(icon: Icon(Icons.donut_large_outlined, size: 15), text: 'Usage Breakdown'),
                          const Tab(icon: Icon(Icons.request_quote_outlined, size: 15), text: 'Payment History & Invoices'),
                        ],
                      ),
                    ),
                    const CompactAiSuiteActions(),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(context, isDark, repo),
                    _buildBuyCreditsTab(context, isDark, repo),
                    _buildTransactionsTab(context, isDark, repo),
                    _buildUsageBreakdownTab(context, isDark, repo),
                    _buildPaymentHistoryTab(context, isDark, repo),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================================
  // TAB 1: OVERVIEW
  // ==========================================================================
  Widget _buildOverviewTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Balance Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AVAILABLE AI CREDITS', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70)),
                    const SizedBox(height: 2),
                    Text('${repo.totalCredits}', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('≈ ₹${(repo.totalCredits * 5.0).toInt()} Value • Rollover Active', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => CreditPurchaseModal.show(context),
                  icon: const Icon(Icons.add_circle_outline, size: 14),
                  label: const Text('Top Up Credits'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF064E3B),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4 Metric Breakdown Cards
          Row(
            children: [
              Expanded(child: _buildMetricTile('Credits Purchased', '${repo.creditsSold}', const Color(0xFF7C3AED))),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricTile('Credits Consumed', '${repo.creditsConsumed}', const Color(0xFF3B82F6))),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricTile('Credits Refunded', '10', const Color(0xFF10B981))),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricTile('Credits Expiring', '0', const Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 2: BUY CREDITS (TIERED PACKAGES)
  // ==========================================================================
  Widget _buildBuyCreditsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: repo.packages.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 210,
      ),
      itemBuilder: (context, index) {
        final pkg = repo.packages[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: pkg.isPopular ? const Color(0xFF10B981) : Colors.transparent, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pkg.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(4)),
                    child: const Text('MOST POPULAR', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                Text(pkg.title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('₹${pkg.price.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
                Text('${pkg.totalCredits} Credits (${pkg.credits}+${pkg.bonusCredits})', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                const Spacer(),
                Text(pkg.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      repo.purchaseCredits(pkg);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully recharged ${pkg.totalCredits} Credits!'), backgroundColor: const Color(0xFF10B981)),
                      );
                      _tabController.animateTo(0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Purchase Package'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 3: TRANSACTIONS
  // ==========================================================================
  Widget _buildTransactionsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.transactions.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final t = repo.transactions[index];
        final isCredit = t.credits > 0;
        return Card(
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(t.type.icon, size: 18, color: isCredit ? const Color(0xFF10B981) : const Color(0xFF3B82F6)),
            title: Text(t.title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Ref: ${t.referenceId} • ${t.date.day}/${t.date.month}/${t.date.year} • ${t.status}', style: const TextStyle(fontSize: 10)),
            trailing: Text(
              '${isCredit ? '+' : ''}${t.credits} Credits',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: isCredit ? const Color(0xFF10B981) : Colors.redAccent),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 4: USAGE BREAKDOWN
  // ==========================================================================
  Widget _buildUsageBreakdownTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Consumption Breakdown', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _buildUsageBar('Room Designer', 420, 685, const Color(0xFF7C3AED)),
          _buildUsageBar('Vastu Consultant', 80, 685, const Color(0xFF0284C7)),
          _buildUsageBar('Doubt Solver', 120, 685, const Color(0xFFF59E0B)),
          _buildUsageBar('Budget Calculator', 50, 685, const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildUsageBar(String label, int used, int total, Color color) {
    final pct = (used / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text('$used Credits (${(pct * 100).toInt()}%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: pct, minHeight: 6, backgroundColor: Colors.grey.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 5: PAYMENT HISTORY & INVOICES
  // ==========================================================================
  Widget _buildPaymentHistoryTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final purchases = repo.transactions.where((t) => t.type == WalletTransactionType.purchase).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: purchases.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final p = purchases[index];
        return Card(
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: const Icon(Icons.receipt_long_rounded, size: 18, color: Color(0xFF10B981)),
            title: Text('${p.title} - Invoice #INV-${p.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Paid ₹${p.rupeeAmount.toInt()} (Incl. 18% GST) • Ref: ${p.referenceId}', style: const TextStyle(fontSize: 10)),
            trailing: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('GST Tax Invoice #INV-${p.id} downloaded successfully!'), backgroundColor: const Color(0xFF10B981)),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 12),
              label: const Text('Invoice'),
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        );
      },
    );
  }
}
