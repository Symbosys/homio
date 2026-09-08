import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/dispute_case_card.dart';
import '../widgets/evidence_dossier_modal.dart';
import '../widgets/legal_dispute_modal.dart';

class LegalHubPage extends StatefulWidget {
  const LegalHubPage({super.key});

  @override
  State<LegalHubPage> createState() => _LegalHubPageState();
}

class _LegalHubPageState extends State<LegalHubPage> {
  final List<DisputeCase> _cases = List.from(LabourMockData.disputeCases);
  final List<BlacklistRecord> _blacklists = List.from(LabourMockData.blacklistRegistry);
  final List<PanelLawyer> _lawyers = List.from(LabourMockData.panelLawyers);

  String _activeTab = 'CASES'; // 'CASES', 'BLACKLIST', 'LAWYERS'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final courtCasesCount = _cases.where((c) => c.legalStatus == DisputeLegalStatus.labourCourtFiled).length;
    final totalClaimValue = _cases.map((c) => c.amountInDispute).reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Legal Dispute & Protection Hub',
              subtitle: 'Binding legal safety net for clients & workers. Labour Court Section 138 recovery, company panel counsel, certified evidence dossiers & blacklisting.',
              activeTab: 'Legal Recourse & Arbitration',
              trailing: ElevatedButton.icon(
                onPressed: () => _openNewDisputeModal(context),
                icon: const Icon(Icons.gavel_rounded, size: 16),
                label: const Text('File Formal Legal Dispute'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Scoreboard
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Active Legal Disputes',
                        value: '${_cases.length} Cases',
                        subtitle: 'Under formal proceedings',
                        icon: Icons.gavel_rounded,
                        color: AppColors.error,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Total Disputed Claim Value',
                        value: '₹${totalClaimValue.toStringAsFixed(0)}',
                        subtitle: 'Escalated for recovery',
                        icon: Icons.currency_rupee,
                        color: const Color(0xFFEC4899),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Labour Court Cases Filed',
                        value: '$courtCasesCount Court Cases',
                        subtitle: 'Pataudi & Saket Courts',
                        icon: Icons.account_balance_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Empanelled Advocates',
                        value: '${_lawyers.length} Advocates',
                        subtitle: 'Zero upfront cost to worker',
                        icon: Icons.person_pin_circle_rounded,
                        color: const Color(0xFF3B82F6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Blacklist Registry',
                        value: '${_blacklists.length} Locked',
                        subtitle: 'Aadhaar / Phone frozen',
                        icon: Icons.block_rounded,
                        color: const Color(0xFF7F1D1D),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Sub-Navigation Tabs
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNavTab('Active Legal Cases (${_cases.length})', 'CASES', Icons.gavel_outlined, textSecondaryColor),
                        const SizedBox(width: 6),
                        _buildNavTab('Blacklist & Fraud Registry (${_blacklists.length})', 'BLACKLIST', Icons.block_rounded, textSecondaryColor),
                        const SizedBox(width: 6),
                        _buildNavTab('Empanelled Legal Counsel (${_lawyers.length})', 'LAWYERS', Icons.account_balance_outlined, textSecondaryColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Main Content Area based on activeTab
                  if (_activeTab == 'CASES') ...[
                    // Search Bar
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search cases by Case Number, Project Name, Claimant, or Respondent...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: surfaceColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._cases.where((c) {
                      if (_searchQuery.isEmpty) return true;
                      final q = _searchQuery.toLowerCase();
                      return c.caseNumber.toLowerCase().contains(q) ||
                          c.projectName.toLowerCase().contains(q) ||
                          c.initiator.toLowerCase().contains(q) ||
                          c.respondent.toLowerCase().contains(q);
                    }).map((c) {
                      return DisputeCaseCard(
                        dispute: c,
                        onViewDossier: () => _openDossierModal(context, c),
                        onAssignLawyer: () => _assignLawyerDialog(context, c),
                        onIssueNotice: () => _issueNoticeDialog(context, c),
                        onArbitrate: () => _arbitrateDialog(context, c),
                      );
                    }),
                  ] else if (_activeTab == 'BLACKLIST') ...[
                    _buildBlacklistRegistryView(surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, textMutedColor),
                  ] else ...[
                    _buildLawyersPanel(surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, textMutedColor),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlacklistRegistryView(
    Color surfaceColor,
    Color borderColor,
    Color textPrimaryColor,
    Color textSecondaryColor,
    Color textMutedColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.error, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Homio Platform-Wide Permanent Blacklist Registry',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      Text(
                        'Entities locked here are permanently banned from booking services, taking jobs, or accessing turnkey contractor portals.',
                        style: TextStyle(fontSize: 12, color: textSecondaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _blacklists.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: borderColor),
            itemBuilder: (context, index) {
              final item = _blacklists[index];
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.block, color: AppColors.error, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.entityName,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.entityType,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(item.identifier, style: TextStyle(fontSize: 11, color: textMutedColor)),
                          const SizedBox(height: 6),
                          Text(item.reason, style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Default / Damage Value', style: TextStyle(fontSize: 11, color: textMutedColor)),
                          Text(
                            '₹${item.defaultAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.error),
                          ),
                          const SizedBox(height: 4),
                          Text('Locked on ${_formatDate(item.blacklistedAt)}', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                          Text('By: ${item.lockedByAdmin}', style: TextStyle(fontSize: 10, color: textMutedColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLawyersPanel(
    Color surfaceColor,
    Color borderColor,
    Color textPrimaryColor,
    Color textSecondaryColor,
    Color textMutedColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Homio Empanelled Legal Advocates & Labour Arbitrators',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          'All empanelled legal counsel represent tradesmen at zero upfront cost to enforce statutory wage compliance.',
          style: TextStyle(fontSize: 12, color: textSecondaryColor),
        ),
        const SizedBox(height: 16),
        ..._lawyers.map((lawyer) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(lawyer.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Bar No: ${lawyer.barCouncilNo}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(lawyer.specialization, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondaryColor)),
                      const SizedBox(height: 2),
                      Text('Jurisdiction: ${lawyer.courtJurisdiction}', style: TextStyle(fontSize: 11, color: textMutedColor)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lawyer.activeCases} Active Cases Assigned', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text('${lawyer.phone} • ${lawyer.email}', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNavTab(String title, String tabKey, IconData icon, Color textSecondaryColor) {
    final isSelected = _activeTab == tabKey;
    return InkWell(
      onTap: () => setState(() => _activeTab = tabKey),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : textSecondaryColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: textMutedColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _openDossierModal(BuildContext context, DisputeCase c) {
    showDialog(
      context: context,
      builder: (ctx) => EvidenceDossierModal(dispute: c),
    );
  }

  void _openNewDisputeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LegalDisputeModal(
        onDisputeFiled: (newCase) {
          setState(() => _cases.insert(0, newCase));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Legal Dispute ${newCase.caseNumber} registered.')),
          );
        },
      ),
    );
  }

  void _assignLawyerDialog(BuildContext context, DisputeCase c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reassign Legal Counsel: ${c.caseNumber}'),
        content: const Text('Select a specialized Bar Council certified lawyer from the Homio Legal Panel.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adv. Rajeshwar Swaroop assigned to case.')),
              );
            },
            child: const Text('Confirm Assignment'),
          ),
        ],
      ),
    );
  }

  void _issueNoticeDialog(BuildContext context, DisputeCase c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Statutory Legal Demand Notice: ${c.caseNumber}'),
        content: Text('Generate 15-day statutory notice for ₹${c.amountInDispute.toStringAsFixed(0)} to ${c.respondent} under Section 138 NI Act & Payment of Wages Code.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statutory Notice dispatched via Registered Post & WhatsApp.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Dispatch Legal Notice'),
          ),
        ],
      ),
    );
  }

  void _arbitrateDialog(BuildContext context, DisputeCase c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Arbitration & Settlement: ${c.caseNumber}'),
        content: const Text('Record mutual settlement agreement or enforce permanent platform blacklist locking.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dispute settled and closed in arbitration.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            child: const Text('Mark Case Settled'),
          ),
        ],
      ),
    );
  }
}
