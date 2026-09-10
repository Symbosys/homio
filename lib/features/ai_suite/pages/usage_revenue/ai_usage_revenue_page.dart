import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/ai_metric_card.dart';
import '../../widgets/job_refund_modal.dart';
import '../../widgets/ai_commercial_config_dialog.dart';
import '../../widgets/compact_ai_suite_actions.dart';

class AiUsageRevenuePage extends StatefulWidget {
  const AiUsageRevenuePage({super.key});

  @override
  State<AiUsageRevenuePage> createState() => _AiUsageRevenuePageState();
}

class _AiUsageRevenuePageState extends State<AiUsageRevenuePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
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
                      'AI Usage & Revenue',
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
                        labelColor: const Color(0xFF7C3AED),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF7C3AED),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                        tabs: [
                          const Tab(icon: Icon(Icons.dashboard_outlined, size: 14), text: 'Overview'),
                          const Tab(icon: Icon(Icons.show_chart_rounded, size: 14), text: 'AI Usage'),
                          const Tab(icon: Icon(Icons.currency_rupee_rounded, size: 14), text: 'Revenue'),
                          Tab(icon: const Icon(Icons.memory_rounded, size: 14), text: 'AI Jobs (${repo.jobs.length})'),
                          Tab(icon: const Icon(Icons.error_outline_rounded, size: 14), text: 'Failed Jobs (${repo.pendingFailedJobsCount})'),
                          const Tab(icon: Icon(Icons.handshake_outlined, size: 14), text: 'Designer Revenue'),
                          Tab(icon: const Icon(Icons.receipt_long_rounded, size: 14), text: 'Transactions (${repo.transactions.length})'),
                          const Tab(icon: Icon(Icons.history_edu_rounded, size: 14), text: 'Reports & Audit'),
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
                    _buildAiUsageTab(context, isDark, repo),
                    _buildRevenueTab(context, isDark, repo),
                    _buildAiJobsTab(context, isDark, repo),
                    _buildFailedJobsTab(context, isDark, repo),
                    _buildDesignerRevenueTab(context, isDark, repo),
                    _buildTransactionsTab(context, isDark, repo),
                    _buildReportsAuditTab(context, isDark, repo),
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
  // TAB 1: EXECUTIVE OVERVIEW (11.1)
  // ==========================================================================
  Widget _buildOverviewTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Executive Commercial KPIs', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100 ? 4 : (constraints.maxWidth > 650 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.3,
                children: [
                  AiMetricCard(title: 'TOTAL AI REVENUE', value: '₹${repo.totalGrossRevenue.toInt()}', icon: Icons.payments_rounded, accentColor: const Color(0xFF10B981), trend: '+28.4%'),
                  AiMetricCard(title: 'HOMIO PLATFORM SHARE', value: '₹${repo.platformNetShare.toInt()}', icon: Icons.account_balance_rounded, accentColor: const Color(0xFF7C3AED), trend: 'Net Profit'),
                  AiMetricCard(title: 'DESIGNER PAYOUTS', value: '₹${repo.designerPayouts.toInt()}', icon: Icons.badge_rounded, accentColor: const Color(0xFFEC4899), trend: '50-50 Split'),
                  AiMetricCard(title: 'CREDITS SOLD / HELD', value: '${repo.creditsSold}', icon: Icons.toll_rounded, accentColor: const Color(0xFF3B82F6), trend: 'Float'),
                  AiMetricCard(title: 'AI JOBS GENERATED', value: '${repo.jobs.length}', icon: Icons.auto_awesome_rounded, accentColor: const Color(0xFF8B5CF6), trend: '${repo.jobSuccessRate.toStringAsFixed(1)}%'),
                  AiMetricCard(title: 'FAILED JOBS', value: '${repo.pendingFailedJobsCount}', icon: Icons.error_outline_rounded, accentColor: Colors.redAccent, trend: 'Triage'),
                  AiMetricCard(title: 'CONSULTATIONS', value: '${repo.consultations.length}', icon: Icons.video_call_rounded, accentColor: const Color(0xFF0284C7), trend: '₹300 avg'),
                  AiMetricCard(title: 'AVG REVENUE / USER', value: '₹1,240', icon: Icons.person_outline_rounded, accentColor: const Color(0xFFF59E0B), trend: '+14% LTV'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 2: AI USAGE ANALYTICS (11.4)
  // ==========================================================================
  Widget _buildAiUsageTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temporal AI Usage & Model Invocations', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weekly Usage Trends (Generations / Day)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Mon', 42),
                      _buildBar('Tue', 58),
                      _buildBar('Wed', 74),
                      _buildBar('Thu', 89),
                      _buildBar('Fri', 110),
                      _buildBar('Sat', 135),
                      _buildBar('Sun', 95),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, int count) {
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Container(
          width: 22,
          height: (count * 0.7).clamp(16.0, 95.0),
          decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
      ],
    );
  }

  // ==========================================================================
  // TAB 3: REVENUE
  // ==========================================================================
  Widget _buildRevenueTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Commercial Revenue Streams', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildRevenueCard('Credit Pack Sales', '₹${(repo.creditsSold * 3.5).toInt()}', const Color(0xFF10B981))),
              const SizedBox(width: 8),
              Expanded(child: _buildRevenueCard('Video Consultations', '₹${repo.consultations.length * 300}', const Color(0xFFEC4899))),
              const SizedBox(width: 8),
              Expanded(child: _buildRevenueCard('Paid Doubt Queries', '₹350', const Color(0xFFF59E0B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)),
          const SizedBox(height: 4),
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 4: REAL-TIME GPU AI JOBS QUEUE (11.5)
  // ==========================================================================
  Widget _buildAiJobsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.jobs.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final job = repo.jobs[index];
        return Card(
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(job.status.icon, size: 18, color: job.status.color),
            title: Text(job.title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('ID: ${job.id} • User: ${job.user} • Prompt: ${job.prompt}', style: const TextStyle(fontSize: 10)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: job.status.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(job.status.label, style: TextStyle(color: job.status.color, fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 5: FAILED AI JOBS TRIAGE DESK (11.6)
  // ==========================================================================
  Widget _buildFailedJobsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final failedJobs = repo.jobs.where((j) => j.status == AiJobStatus.failed).toList();

    if (failedJobs.isEmpty) {
      return Center(
        child: Text('Zero failed jobs in queue. High-availability GPU cluster operational.', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: failedJobs.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final job = failedJobs[index];
        return Card(
          color: Colors.red.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.redAccent)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job.title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('${job.creditsCharged} Credits Charged', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('User: ${job.user} • Failure: ${job.failureReason ?? 'Tensor memory overflow'}', style: const TextStyle(fontSize: 11, color: Colors.redAccent)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => repo.retryJob(job.id),
                      icon: const Icon(Icons.replay_rounded, size: 12),
                      label: const Text('Retry GPU Job'),
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => JobRefundModal.show(context, job),
                      icon: const Icon(Icons.undo_rounded, size: 12),
                      label: const Text('Refund Credits'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 6: DESIGNER REVENUE SHARING (12)
  // ==========================================================================
  Widget _buildDesignerRevenueTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.designers.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final d = repo.designers[index];
        final gross = d.consultationsCount * d.consultationFee;
        final designerShare = gross * (repo.commercialConfig.designerRevenueSharePercent / 100.0);
        final platformShare = gross * (repo.commercialConfig.platformRevenueSharePercent / 100.0);

        return Card(
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: CircleAvatar(radius: 16, backgroundImage: NetworkImage(d.avatarUrl)),
            title: Text(d.name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Gross: ₹${gross.toInt()} • Designer: ₹${designerShare.toInt()} • Homio: ₹${platformShare.toInt()}', style: const TextStyle(fontSize: 10)),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payout settlement batch initiated for ${d.name}!'), backgroundColor: const Color(0xFF10B981)),
                );
              },
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 10),
              ),
              child: const Text('Settle Payout'),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 7: TRANSACTIONS (11.3)
  // ==========================================================================
  Widget _buildTransactionsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.transactions.length,
      separatorBuilder: (_, _) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final t = repo.transactions[index];
        return Card(
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(t.type.icon, size: 18),
            title: Text(t.title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Client: ${t.clientName ?? 'N/A'} • Ref: ${t.referenceId} • Amount: ₹${t.rupeeAmount.toInt()}', style: const TextStyle(fontSize: 10)),
            trailing: Text('${t.credits} Credits', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 8: REPORTS & AUDIT TRAIL (21)
  // ==========================================================================
  Widget _buildReportsAuditTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Audit Trail & Commercial Rules', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
              ElevatedButton.icon(
                onPressed: () => AiCommercialConfigDialog.show(context),
                icon: const Icon(Icons.tune_rounded, size: 14),
                label: const Text('Edit Commercial Rules'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repo.auditRecords.length,
            separatorBuilder: (_, _) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final a = repo.auditRecords[index];
              return Card(
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(Icons.history_toggle_off_rounded, size: 18, color: Color(0xFF7C3AED)),
                  title: Text('${a.action} (${a.entity})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: Text('User: ${a.user} • "${a.previousValue}" → "${a.newValue}"\nReason: ${a.reason}', style: const TextStyle(fontSize: 10)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
